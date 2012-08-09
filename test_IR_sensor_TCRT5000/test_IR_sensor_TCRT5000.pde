/*
IR diode D3
IR receiver A0

  AnalogReadSerial
 Reads an analog input on pin 0, prints the result to the serial monitor 
 
 This example code is in the public domain.
 */

void setup() {
  Serial.begin(9600);
  pinMode(3, OUTPUT);
}

void loop() {
  
  int sensorValue = analogRead(A0);
  
  Serial.println(sensorValue);
  if (sensorValue < 900)
  {
    digitalWrite (3, HIGH);
  }
  else
  {
    digitalWrite (3, LOW);
  }
}
