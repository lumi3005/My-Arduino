/*
  DigitalReadSerial
 Reads a digital input on pin 4, prints the result to the serial monitor 
 
 This example code is in the public domain.
 
int motorPinRF = 10;
int motorPinRB = 11;
int motorPinLF = 12;
int motorPinLB = 13;
*/
void setup() {
  Serial.begin(9600);
  pinMode(4, INPUT);
/*  pinMode(motorPinRF, OUTPUT);
  pinMode(motorPinRB, OUTPUT);
  pinMode(motorPinLF, OUTPUT);
  pinMode(motorPinLB, OUTPUT); */
}

void loop() {
  int sensorValue = digitalRead(4);
  Serial.print(sensorValue, DEC);
  Serial.print(", ");
  delay(100);
/*  digitalWrite(motorPinRF, HIGH);
  digitalWrite(motorPinLF, HIGH);
  digitalWrite(motorPinRB, LOW);
  digitalWrite(motorPinLB, LOW);
  delay(2000);
  digitalWrite(motorPinRF, LOW);
  digitalWrite(motorPinLF, LOW);
  digitalWrite(motorPinRB, HIGH);
  digitalWrite(motorPinLB, HIGH);
  delay(2000);  */
}







