

int ledPin = 13;

void setup() {
  //Serial.begin(9600);
  pinMode(2, INPUT);
  pinMode(ledPin, OUTPUT);
}

void loop() {
  int sensorValue = digitalRead(2);
  //Serial.println(sensorValue);
  delay(100);
  if (sensorValue == LOW)
  {
      digitalWrite (ledPin, HIGH);
  }
  else if (sensorValue == HIGH)
  {
      digitalWrite (ledPin, LOW);
  }
  //delay(200);
}



