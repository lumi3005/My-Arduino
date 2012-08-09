/*
  Blink
  Turns on an LED on for one second, then off for one second, repeatedly.
 
  This example code is in the public domain.
 */
int sensorPin = 2;
int sensorValue;

void setup() {                
  // initialize the digital pin as an output.
  // Pin 13 has an LED connected on most Arduino boards:
  pinMode(0, OUTPUT); 
  pinMode(1, OUTPUT);
  pinMode(sensorPin, INPUT);

  
}

void loop() { 
  
  digitalWrite(0, HIGH);   // set the LED on
  digitalWrite(1, HIGH);   // set the LED on
  delay(100);              
  digitalWrite(0, LOW);   // set the LED on
  digitalWrite(1, LOW);   // set the LED on
  delay(100);  
  digitalWrite(0, HIGH);   // set the LED on
  digitalWrite(1, HIGH);   // set the LED on
  delay(100);              
  digitalWrite(0, LOW);   // set the LED on
  digitalWrite(1, LOW);   // set the LED on
  delay(100);  
  digitalWrite(0, HIGH);   // set the LED on
  digitalWrite(1, HIGH);   // set the LED on
  delay(100);              
  digitalWrite(0, LOW);   // set the LED on
  digitalWrite(1, LOW);   // set the LED on
  delay(100);  
  
  
  
  
}
