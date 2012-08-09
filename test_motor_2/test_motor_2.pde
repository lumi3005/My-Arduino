// walkerForward.pde - Two servo walker. Forward.
// (c) Kimmo Karvinen & Tero Karvinen http://BotBook.com
// updated - Joe Saavedra, 2010
#include <Servo.h>

const int pingPin = 11;
int motorPinR = 1;
int motorPinL =3;
long duration, distanceCm;

void moveForward()
{
frontServo.write(frontRightUp);
rearServo.write(backLeftForward);
delay(325);
frontServo.write(centerPos);
rearServo.write(centerPos);
delay(265);
frontServo.write(frontLeftUp);
rearServo.write(backRightForward);
delay(325);
frontServo.write(centerPos);
rearServo.write(centerPos);
delay(265);
}
void setup()
{
Serial.begin(9600);
frontServo.attach(4);
rearServo.attach(5);
}
void loop()
{
if (distanceCm > 20)
{
duration = pulseIn(pingPin, HIGH);
distanceCm = microsecondsToCentimeters(duration);
Serial.print(distanceCm);
Serial.print("cm");
Serial.println();
  digitalWrite(ledPin, HIGH);
moveForward();
delay(50); //time between each step taken, speed of walk
pinMode(pingPin, OUTPUT);
digitalWrite(pingPin, LOW);
delayMicroseconds(2);
digitalWrite(pingPin, HIGH);
delayMicroseconds(5);
digitalWrite(pingPin, LOW);
pinMode(pingPin, INPUT);
}
else
{
  digitalWrite(ledPin, LOW);
}
delay(10);
}
long microsecondsToCentimeters(long microseconds)
{
return microseconds / 29 / 2;
}
