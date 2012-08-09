/*
  DigitalReadSerial
 Reads a digital input on pin 4, prints the result to the serial monitor 
 
 This example code is in the public domain.
*/ 
int rf = 0;
int rb = 1;
int lf = 3;
int lb = 4;
int sensorValue;

void setup() {
  //Serial.begin(9600);
  pinMode(rf, OUTPUT);
  pinMode(rb, OUTPUT);
  pinMode(lf, OUTPUT);
  pinMode(lb, OUTPUT); 
  pinMode(sensorValue, INPUT);
}

void loop() {
  
  sensorValue = analogRead(1);
  
  if (sensorValue > 900)
  {
    digitalWrite (rf,HIGH);
    digitalWrite (rb,HIGH);
  }
  else
  {
    digitalWrite (rf,LOW);
    digitalWrite (rb,LOW);
  }
}







