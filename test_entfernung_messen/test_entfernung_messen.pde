const int pingPin = 13;
int ledPin = 8;
long duration, distanceCm;
void setup()
{
Serial.begin(9600);
}
void loop()
{
pinMode(pingPin, OUTPUT);
digitalWrite(pingPin, LOW);
delayMicroseconds(2);
digitalWrite(pingPin, HIGH);
delayMicroseconds(5);
digitalWrite(pingPin, LOW);
pinMode(pingPin, INPUT);
duration = pulseIn(pingPin, HIGH);
distanceCm = microsecondsToCentimeters(duration);
Serial.print(distanceCm);
Serial.print("cm");
Serial.println();
// wenn näher als 20cm LED an
if (distanceCm < 20)
{
  digitalWrite(ledPin, HIGH);
}
else
{
  digitalWrite(ledPin, LOW);
}


delay(100);
}
long microsecondsToCentimeters(long microseconds)
{
return microseconds / 29 / 2;
}
