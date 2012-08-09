

int sensorLeft = A0;    
int sensorRight = A1;

int ledLeft = 7;
int ledRight = 4;      
int sensorValueLeft = 0;  
int sensorValueRight = 0;

void setup() {
  // declare the ledPin as an OUTPUT:
  pinMode(ledLeft, OUTPUT);  
  pinMode(ledRight, OUTPUT); 
  Serial.begin(9600);
}

void loop() {
  
  digitalWrite(ledLeft, LOW);
  digitalWrite(ledRight, LOW);
  // read the value from the sensors:
  sensorValueLeft = analogRead(sensorLeft);
  sensorValueRight = analogRead(sensorRight); 
   Serial.print("Left eye = ");   
   Serial.print(sensorValueLeft);
   Serial.print(" ----- Right eye = ");
   Serial.println(sensorValueRight); 
delay(10);   
  
  if (sensorValueLeft < sensorValueRight)
  {
    digitalWrite(ledRight, HIGH);
  }
  else if (sensorValueLeft > sensorValueRight)
  {
    digitalWrite(ledLeft, HIGH);
  }
  else if (sensorValueLeft == sensorValueRight+15 || sensorValueLeft+15 == sensorValueRight)
  {
    digitalWrite(ledLeft, HIGH);
    digitalWrite(ledRight, HIGH);
  }
}
