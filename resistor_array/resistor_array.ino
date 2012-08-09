/*
  Blink
  Turns on an LED on for one second, then off for one second, repeatedly.
 
  This example code is in the public domain.
 */

void setup() {                
  // initialize the digital pin as an output.
  // Pin 13 has an LED connected on most Arduino boards:
  pinMode(1, OUTPUT); 
  pinMode(2, OUTPUT); 
  pinMode(3, OUTPUT); 
  pinMode(4, OUTPUT); 
}

void loop() {
  digitalWrite(1, HIGH);   // set the LED on
  delay(1000);              // wait for a second
  digitalWrite(1, LOW);    // set the LED off
  delay(1000);              // wait for a second
  digitalWrite(2, HIGH);   // set the LED on
  delay(1000);              // wait for a second
  digitalWrite(2, LOW);    // set the LED off
  delay(1000);
  digitalWrite(3, HIGH);   // set the LED on
  delay(1000);              // wait for a second
  digitalWrite(3, LOW);    // set the LED off
  delay(1000);              // wait for a second
  digitalWrite(4, HIGH);   // set the LED on
  delay(1000);              // wait for a second
  digitalWrite(4, LOW);    // set the LED off
  delay(1000);
}
