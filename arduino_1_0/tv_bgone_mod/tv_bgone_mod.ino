/*
AIM Lap Trigger Beacon using TV-B-Gone Hardware 

Portions (c) by:
TV-B-Gone Firmware version 1.2
for use with ATtiny85v and v1.2 hardware
(c) Mitch Altman + Limor Fried 2009
Last edits, August 16 2009

With some code from:
Kevin Timmerman & Damien Good 7-Dec-07

Distributed under Creative Commons 2.5 -- Attib & Share Alike
*/
#include <avr/io.h>

// What pins do what
#define LED    PB2
#define IRLED  PB0

// Shortcut to insert single, non-optimized-out nop
#define NOP __asm__ __volatile__ ("nop")

#define freq_to_timerval(x) ((F_CPU/x - 1)/2)

//for 8MHz we want to delay 8 cycles per microsecond
//this code is tweaked to give about that amount
void delay_us(uint16_t us) {
  while (us != 0) {
    NOP;      
    NOP;      
    us--;      
  }
}

//This function is the 'workhorse' of transmitting IR codes.
void xmitCodeElement(uint16_t ontime, uint16_t offtime) {
  //start outputting the carrier frequency on OC0A, PB0, pin 5
  TCNT0 = 0; //reset the timers so they are aligned
  TIFR = 0;  //clean out the timer flags
  //timer0 mode #2 CTC, with OCRA as TOP, toggling OC0A(PB0) on compare match, no prescaling
  TCCR0A =_BV(COM0A0) | _BV(WGM01);
  TCCR0B = _BV(CS00);
  delay_us(ontime);
  //turn off timer0
  TCCR0A = 0;
  TCCR0B = 0;
  //make sure that the IR LED is off since timer may have stopped while the LED is on
  PORTB |= _BV(IRLED);
  delay_us(offtime);
}

int main(void) {
    uint16_t flash;

    DDRB = _BV(LED) | _BV(IRLED);    //set the visible and IR LED pins to outputs
    PORTB = _BV(LED) | _BV(IRLED);   //LEDs are off when pins are high
    OCR0A = (uint8_t)freq_to_timerval(195200); //value for 38kHz --- changed from 38000 to 195200
    TCCR0A = 0;     //stop timer0
    TCCR0B = 0;

    flash = 0;
    while(1) {
        flash++;
        if (flash == 2000)
            PORTB &= ~_BV(LED);      //turn on visible LED at PB0 by pulling pin to ground
        //measured AIM beacon pattern [inverted by PNA4602M]:
        //high 6ms/low 624us/high 1.2ms/low 624us/high 1.2ms/low 624us [repeat]
        //Alternative Private Beacon Code:
        //300us ON / 1200us OFF / 300us ON / 1200us OFF / 300us ON / 6000us OFF
        //900us ON/9300us = 9.7% duty time
        xmitCodeElement(622, 1195);  //timing tweaked via AVR Studio Stopwatch
        xmitCodeElement(622, 1195);
        xmitCodeElement(622, 5994);  //IRLED on 1.872ms/off 8.4ms = 18.2% on time
        
        
        
        if (flash == 2005) {
            PORTB |= _BV(LED);       //turn off visible LED
            flash = 0;
        }
    }
}



