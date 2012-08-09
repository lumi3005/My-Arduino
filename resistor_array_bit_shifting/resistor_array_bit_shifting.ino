/*
  Blink
  Turns on an LED on for one second, then off for one second, repeatedly.
 
  This example code is in the public domain.
 */
byte pattern =0b00000000;

void setup() {                
  // initialize the digital pin as an output.
  // Pin 13 has an LED connected on most Arduino boards:
  pinMode(0, OUTPUT); 
  pinMode(1, OUTPUT); 
  pinMode(2, OUTPUT); 
  pinMode(3, OUTPUT); 
  pinMode(4, OUTPUT); 
}

int h = HIGH;

void loop() {
  //PORTB= 0b00001111;
  
  PORTB = pattern;
  digitalWrite(4, h);
  h = h ? LOW : HIGH;
  delay(1000);              // wait for a second
  pattern++;
  if (pattern == 0b00010000){
   pattern = 0b00000000;
   digitalWrite(4, HIGH);
   delay(300);
   digitalWrite(4, LOW); 
   delay(300);
  }
  
  //digitalWrite(0, HIGH);
  
}
