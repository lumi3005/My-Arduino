
/*
Sound & Light Machine
Firmware
for use with ATtiny2313
Make Magazine issue #10
Mitch Altman
19-Mar-07
*/
#include <avr/io.h>             // this contains all the IO port definitions
#include <avr/interrupt.h>      // definitions for interrupts
#include <avr/sleep.h>          // definitions for power-down modes
#include <avr/pgmspace.h>       // definitions or keeping constants in program memory
#define TIMER0_PRESCALE_1 1
#define TIMER0_PRESCALE_8 2
#define TIMER0_PRESCALE_64 3
#define TIMER0_PRESCALE_256 4
#define TIMER0_PRESCALE_1024 5
#define TIMER1_PRESCALE_1 1
#define TIMER1_PRESCALE_8 2
#define TIMER1_PRESCALE_64 3
#define TIMER1_PRESCALE_256 4
#define TIMER1_PRESCALE_1024 5
/*
The hardware for this project is very simple:
     ATtiny2313 has 20 pins:
       pin 1   connects to serial port programming circuitry
       pin 10  ground
       pin 12  PB0 - Left eye LED1
       pin 13  PB1 - Right eye LED1
       pin 14  OC0A - Left ear speaker (base-frequency)
       pin 15  OC1A - Right ear speaker (Offset Frequencies for binaural beats)
       pin 17  connects to serial port programming circuitry
       pin 18  connects to serial port programming circuitry
       pin 19  connects to serial port programming circuitry
       pin 20  +3v
    All other pins are unused
    This firmware requires that the clock frequency of the ATtiny 
      is the default that it is shipped with:  8.0MHz
*/
/*
The C compiler creates code that will transfer all constants into RAM when the microcontroller
resets.  Since this firmware has a table (brainwaveTab) that is too large to transfer into RAM,
the C compiler needs to be told to keep it in program memory space.  This is accomplished by
the macro PROGMEM (this is used, below, in the definition for the brainwaveTab).  Since the
C compiler assumes that constants are in RAM, rather than in program memory, when accessing
the brainwaveTab, we need to use the pgm_read_byte() and pgm_read_dword() macros, and we need
to use the brainwveTab as an address, i.e., precede it with "&".  For example, to access 
brainwaveTab[3].bwType, which is a byte, this is how to do it:
     pgm_read_byte( &brainwaveTab[3].bwType );
And to access brainwaveTab[3].bwDuration, which is a double-word, this is how to do it:
     pgm_read_dword( &brainwaveTab[3].bwDuration );
*/
// table of values for meditation 
//   start with lots of Beta (awake / conscious)
//   add Alpha (dreamy / trancy to connect with subconscious Theta that'll be coming up)
//   reduce Beta (less conscious)
//   start adding Theta (more subconscious)
//   pulse in some Delta (creativity)
//   and then reverse the above to come up refreshed
struct brainwaveElement {
  char bwType;  // 'a' for Alpha, 'b' for Beta, 't' for Theta, or 'd' for Delta ('0' signifies last entry in table
  unsigned long int bwDuration;  // Duration of this Brainwave Type (divide by 10,000 to get seconds)
} const brainwaveTab[] PROGMEM = {
  { 'b', 600000 },
  { 'a', 100000 },
  { 'b', 200000 },
  { 'a', 150000 },
  { 'b', 150000 },
  { 'a', 200000 },
  { 'b', 100000 },
  { 'a', 300000 },
  { 'b',  50000 },
  { 'a', 600000 },
  { 't', 100000 },
  { 'a', 300000 },
  { 't', 200000 },
  { 'a', 300000 },
  { 't', 300000 },
  { 'a', 150000 },
  { 't', 600000 },
  { 'a', 150000 },
  { 'b',  10000 },
  { 'a', 150000 },
  { 't', 600000 },
  { 'd',  10000 },
  { 't', 100000 },
  { 'd',  10000 },
  { 't', 100000 },
  { 'd',  10000 },
  { 't', 300000 },
  { 'a', 150000 },
  { 'b',  10000 },
  { 'a', 150000 },
  { 't', 300000 },
  { 'a', 150000 },
  { 'b',  10000 },
  { 'a', 200000 },
  { 'b',  50000 },
  { 'a', 200000 },
  { 'b', 150000 },
  { 'a', 150000 },
  { 'b', 200000 },
  { 'a', 100000 },
  { 'b', 250000 },
  { 'a',  50000 },
  { 'b', 600000 },
  { '0',      0 }
};
// This function delays the specified number of 1/10 milliseconds
void delay_one_tenth_ms(unsigned long int ms) {
  unsigned long int timer;
  const unsigned long int DelayCount=87;  // this value was determined by trial and error
  while (ms != 0) {
    // Toggling PD0 is done here to force the compiler to do this loop, rather than optimize it away
    for (timer=0; timer <= DelayCount; timer++) {PIND |= 0b0000001;};
    ms--;
  }
}
// This function blinks the LEDs (connected to PB0, PB1 - for Left eye, Right eye, respectively)
//   at the rate determined by onTime and offTime
//   and keeps them blinking for the Duration specified (Duration given in 1/10 millisecs)
// This function also acts as a delay for the Duration specified
void blink_LEDs( unsigned long int duration, unsigned long int onTime, unsigned long int offTime) {
  for (int i=0; i<(duration/(onTime+offTime)); i++) {
    PORTB |= 0b00000011;          // turn on LEDs at PB0, PB1
    delay_one_tenth_ms(onTime);   //   for onTime
    PORTB &= 0b11111100;          // turn off LEDs at PB0, PB1
    delay_one_tenth_ms(offTime);  //   for offTime
  }
}
// This function starts the Offset Frequency audio in the Right ear through output OC1A  (using Timer 1)
//   to create a binaural beat (between Left and Right ears) for a Brainwave Element
//   (the base-frequency of 400.641Hz is already assumed to be playing in the Left ear before calling this function)
//   and blinks the LEDs at the same frequency for the Brainwave Element
//   and keeps it going for the Duration specified for the Brainwave Element
// The timing for the Right ear is done with 16-bit Timer 1 (set up for CTC Mode, toggling output on each compare)
//   Output frequency = Fclk / (2 * Prescale * (1 + OCR1A) ) = 8,000,000 / (2 * (1 + OCR1A) )
void do_brainwave_element(int index) {
    char brainChr = pgm_read_byte(&brainwaveTab[index].bwType);
    if (brainChr == 'b') {
         // PORTB &= 0b00001100;  // (for debugging purposes only -- commented out for SLM)
         // PORTB |= 0b10000000;
      // Beta
      // start Timer 1 with the correct Offset Frequency for a binaural beat for the Brainwave Type
      //   to Right ear speaker through output OC1A (PB3, pin 15)
      OCR1A = 9637;  // T1 generates 415.024Hz, for a binaural beat of 14.4Hz
      // delay for the time specified in the table while blinking the LEDs at the correct rate
      //   onTime = 34.7ms, offTime = 34.7ms --> 14.4Hz
      blink_LEDs( pgm_read_dword(&brainwaveTab[index].bwDuration), 347, 347 );
      return;   // Beta
    }
    else if (brainChr == 'a') {
         // PORTB &= 0b00001100;  // (for debugging purposes only -- commented out for SLM)
         // PORTB |= 0b01000000;
      // Alpha
      // start Timer 1 with the correct Offset Frequency for a binaural beat for the Brainwave Type
      //   to Right ear speaker through output OC1A (PB3, pin 15)
      OCR1A = 9714;  // T1 generates 411.734Hz, for a binaural beat of 11.1Hz
      // delay for the time specified in the table while blinking the LEDs at the correct rate
      //   onTime = 45.1ms, offTime = 45.0ms --> 11.1Hz
      blink_LEDs( pgm_read_dword(&brainwaveTab[index].bwDuration), 451, 450 );
      return;   // Alpha
    }
    else if (brainChr == 't') {
         // PORTB &= 0b00001100;  // (for debugging purposes only -- commented out for SLM)
         // PORTB |= 0b00100000;
      // Theta
      // start Timer 1 with the correct Offset Frequency for a binaural beat for the Brainwave Type
      //   to Right ear speaker through output OC1A (PB3, pin 15)
      OCR1A = 9836;  // T1 generates 406.628Hz, for a binaural beat of 6.0Hz
      // delay for the time specified in the table while blinking the LEDs at the correct rate
      //   onTime = 83.5ms, offTime = 83.5ms --> 6.0Hz
      blink_LEDs( pgm_read_dword(&brainwaveTab[index].bwDuration), 835, 835 );
      return;   // Theta
    }
    else if (brainChr == 'd') {
         // PORTB &= 0b00001100;  // (for debugging purposes only -- commented out for SLM)
         // PORTB |= 0b00010000;
      // Delta
      // start Timer 1 with the correct Offset Frequency for a binaural beat for the Brainwave Type
      //   to Right ear speaker through output OC1A (PB3, pin 15)
      OCR1A = 9928;  // T1 generates 402.860Hz, for a binaural beat of 2.2Hz
      // delay for the time specified in the table while blinking the LEDs at the correct rate
      //   onTime = 225.3ms, offTime = 225.3ms --> 2.2Hz
      blink_LEDs( pgm_read_dword(&brainwaveTab[index].bwDuration), 2253, 2253 );
      return;   // Delta
    }
    // this should never be executed, since we catch the end of table in the main loop
    else {
         // PORTB &= 0b00001100;  // (for debugging purposes only -- commented out for SLM)
         // PORTB |= 0b00000010;
      return;      // end of table
    }
}
int main(void) {
  TIMSK = 0x00;  // no Timer interrupts enabled
  DDRB = 0xFF;   // set all PortB pins as outputs
  PORTB = 0x00;  // all PORTB output pins Off
  // start up Base frequency = 400.641Hz on Left ear speaker through output OC0A (using Timer 0)
  //   8-bit Timer 0 OC0A (PB2, pin 14) is set up for CTC mode, toggling output on each compare
  //   Fclk = Clock = 8MHz
  //   Prescale = 256
  //   OCR0A = 38
  //   F = Fclk / (2 * Prescale * (1 + OCR0A) ) = 400.641Hz
  TCCR0A = 0b01000010;  // COM0A1:0=01 to toggle OC0A on Compare Match
                        // COM0B1:0=00 to disconnect OC0B
                        // bits 3:2 are unused
                        // WGM01:00=10 for CTC Mode (WGM02=0 in TCCR0B)
  TCCR0B = 0b00000100;  // FOC0A=0 (no force compare)
                        // F0C0B=0 (no force compare)
                        // bits 5:4 are unused
                        // WGM2=0 for CTC Mode (WGM01:00=10 in TCCR0A)
                        // CS02:00=100 for divide by 256 prescaler
  OCR0A = 38;  // to output 400.641Hz on OC0A (PB2, pin 14)
  // set up T1 to accept Offset Frequencies on Right ear speaker through OC1A (but don't actually start the Timer 1 here)
  //   16-bit Timer 1 OC1A (PB3, pin 15) is set up for CTC mode, toggling output on each compare
  //   Fclk = Clock = 8MHz
  //   Prescale = 1
  //   OCR0A = value for Beta, Alpha, Theta, or Delta (i.e., 9520, 9714, 9836, or 9928)
  //   F = Fclk / (2 * Prescale * (1 + OCR0A) )
  TCCR1A = 0b01000000;  // COM1A1:0=01 to toggle OC1A on Compare Match
                        // COM1B1:0=00 to disconnect OC1B
                        // bits 3:2 are unused
                        // WGM11:10=00 for CTC Mode (WGM13:12=01 in TCCR1B)
  TCCR1B = 0b00001001;  // ICNC1=0 (no Noise Canceller)
                        // ICES1=0 (don't care about Input Capture Edge)
                        // bit 5 is unused
                        // WGM13:12=01 for CTC Mode (WGM11:10=00 in TCCR1A)
                        // CS12:10=001 for divide by 1 prescaler
  TCCR1C = 0b00000000;  // FOC1A=0 (no Force Output Compare for Channel A)
                        // FOC1B=0 (no Force Output Compare for Channel B)
                        // bits 5:0 are unused
  // loop through entire Brainwave Table of Brainwave Elements
  //   each Brainwave Element consists of a Brainwave Type (Beta, Alpha, Theta, or Delta) and a Duration
  // Seeing the LEDs blink and hearing the binaural beats for the sequence of Brainwave Elements
  //   synchs up the user's brain to follow the sequence (hopefully it is a useful sequence)
  int j = 0;
  while (pgm_read_byte(&brainwaveTab[j].bwType) != '0') {  // '0' signifies end of table
    do_brainwave_element(j);
    j++;
  }
  // Shut down everything and put the CPU to sleep
  TCCR0B &= 0b11111000;  // CS02:CS00=000 to stop Timer0 (turn off audio in Right ear speaker)
  TCCR1B &= 0b11111000;  // CS12:CS10=000 to stop Timer1 (turn off audio in Left ear speaker)
  MCUCR |= 0b00100000;   // SE=1 (bit 5)
  MCUCR |= 0b00010000;   // SM1:0=01 to enable Power Down Sleep Mode (bits 6, 4)
  delay_one_tenth_ms(10000);  // wait 1 second
  PORTB = 0x00;          // turn off all PORTB outputs
  DDRB = 0x00;           // make PORTB all inputs
  sleep_cpu();           // put CPU into Power Down Sleep Mode

