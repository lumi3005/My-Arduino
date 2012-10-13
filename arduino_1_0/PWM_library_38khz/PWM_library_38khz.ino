#define NOP __asm__ __volatile__ ("nop")
#define DELAY_CNT 11

int status = HIGH;
int f = 0;

void delay_ten_us(uint16_t us) {
  uint8_t timer;
  while (us != 0) {
    // for 8MHz we want to delay 80 cycles per 10 microseconds
    // this code is tweaked to give about that amount.
    for (timer=0; timer <= DELAY_CNT; timer++) {
      NOP;
      NOP;
    }
    NOP;
    us--;
  }
}


void code(uint16_t ontime, uint16_t offtime, uint8_t power) // power from 0 ~ 15
{
  
  if(power > 15) power = 15;
  power = power << 1;  // leave port 0 out
  PORTB &= 0b11100001; // clear all power control bit;
  PORTB |= power;      // set the corresponding power control bit
  
  // start Timer0 outputting the carrier frequency to IR emitters on and OC0A 
  // (PB0, pin 5)
  TCNT0 = 0; // reset the timers so they are aligned
  TIFR = 0;  // clean out the timer flags

  // 99% of codes are PWM codes, they are pulses of a carrier frequecy
  // Usually the carrier is around 38KHz, and we generate that with PWM
  // timer 0
  TCCR0A = _BV(COM0A0) | _BV(WGM01);          // set up timer 0
  TCCR0B = _BV(CS00);
  
  // Now we wait, allowing the PWM hardware to pulse out the carrier 
  // frequency for the specified 'on' time
  delay_ten_us(ontime);
  // Now we have to turn it off so disable the PWM output
  TCCR0A = 0;
  TCCR0B = 0;
  // And make sure that the IR LED is off too (since the PWM may have 
  // been stopped while the LED is on!)
  PORTB &= ~_BV(0);           // turn off IR LED

  // Now we wait for the specified 'off' time
  delay_ten_us(offtime);
}

void setup(){
  pinMode(0, OUTPUT);
  pinMode(1, OUTPUT);
  pinMode(2, OUTPUT);
  pinMode(3, OUTPUT);
  pinMode(4, OUTPUT);
  
  TCCR0A = 0;
  TCCR0B = 0;
  OCR0A = 107;
}

//Resister values used: 750, 330, 150, 65

uint8_t p = 0;
void loop() {
  code(60, 0, 15);
  if(p > 15) {/*
    code(60000, 60000, 15);
    code(60000, 60000, 15);
    code(60000, 0, 15);
    code(60000, 0, 15);
    code(60000, 0, 15);
    code(60000, 0, 15);
    code(60000, 0, 15);
    code(60000, 0, 15);
    code(60000, 60000, 15);
    code(60000, 60000, 15);
    code(60000, 60000, 15);
    code(60000, 0, 0);
    code(60000, 0, 0);
    code(60000, 0, 0);
    code(60000, 0, 0);
    code(60000, 0, 0);
    code(60000, 0, 0);
    code(60000, 60000, 15);
    code(60000, 60000, 15);
    code(60000, 60000, 15);
    code(60000, 60000, 15);*/
    p = 0;
  }
}

