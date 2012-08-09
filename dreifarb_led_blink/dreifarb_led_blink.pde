/*
  Blink
  Turns on an LED on for one second, then off for 0,5 second, repeatedly.
 
  This example code is in the public domain.
 */

void setup() {                
  // initialize the digital pin as an output.
  // Pin 2-4 has an LED connected
  pinMode(2, OUTPUT);  
  pinMode(3, OUTPUT);
  pinMode(4, OUTPUT);  
}

void loop() {
  digitalWrite(2, HIGH);   // set the LED on
  delay(500);              // wait for 0,5 second
  digitalWrite(2, LOW);    // set the LED off
  delay(500);              // wait for 0,5 second
  digitalWrite(3, HIGH);   // set the LED on
  delay(500);              // wait for 0,5 second
  digitalWrite(3, LOW);    // set the LED off
  delay(500);              // wait for 0,5 second
  digitalWrite(4, HIGH);   // set the LED on
  delay(500);              // wait for 0,5 second
  digitalWrite(4, LOW);    // set the LED off
  delay(500);              // wait for 0,5 second
}
