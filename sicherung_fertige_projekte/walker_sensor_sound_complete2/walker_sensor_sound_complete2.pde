// walkerForwardComplete.pde - Two servo walker.
// Complete code with obstacle avoidance
// (c) Kimmo Karvinen & Tero Karvinen http://BotBook.com
// Updated by Joe Saavedra, 2010
// Modified by Lutz Michaelis (add sound function, adjust the servo variables), April 2011 http://www.roboter-selbstgebaut.com
#include <Servo.h>
Servo frontServo;
Servo rearServo;
/* Servo motors - global variables */
int centerPos = 90;
int frontRightUp = 60;
int frontLeftUp = 120;
int backRightForward = 60;
int backLeftForward = 120;
int walkSpeed = 500; // How long to wait between steps in milliseconds
int centerTurnPos = 81;
int frontTurnRightUp = 63;
int frontTurnLeftUp = 117;
int backTurnRightForward = 66;
int backTurnLeftForward = 96;
/* Ping distance measurement - global variables */
int pingPin = 4;
/* sound variables */
int soundPin = 7;
/* distance measuring variables */
long int duration, distanceInches;
long distanceFront=0; //cm
int startAvoidanceDistance=20; //cm
long microsecondsToInches(long microseconds)
{
return microseconds / 74 / 2;
}
long microsecondsToCentimeters(long microseconds)
{
return microseconds / 29 / 2;
}
long distanceCm(){
pinMode(pingPin, OUTPUT);
digitalWrite(pingPin, LOW);
delayMicroseconds(2);
digitalWrite(pingPin, HIGH);
delayMicroseconds(5);
digitalWrite(pingPin, LOW);
pinMode(pingPin, INPUT);
duration = pulseIn(pingPin, HIGH);
distanceInches = microsecondsToInches(duration);
return microsecondsToCentimeters(duration);
}
void center()
{
frontServo.write(centerPos);
rearServo.write(centerPos);
}
void moveForward()
{
frontServo.write(frontRightUp);
rearServo.write(backLeftForward);
delay(225);
frontServo.write(centerPos);
rearServo.write(centerPos);
delay(165);
frontServo.write(frontLeftUp);
rearServo.write(backRightForward);
delay(225);
frontServo.write(centerPos);
rearServo.write(centerPos);
delay(165);
}
void moveBackRight()
{
frontServo.write(frontRightUp);
rearServo.write(backRightForward-6);
delay(225);
frontServo.write(centerPos);
rearServo.write(centerPos-6);
delay(165);
frontServo.write(frontLeftUp+9);
rearServo.write(backLeftForward-6);
delay(225);
frontServo.write(centerPos);
rearServo.write(centerPos);
delay(165);
}
void moveTurnLeft()
{
frontServo.write(frontTurnRightUp);
rearServo.write(backTurnLeftForward);
delay(225);
frontServo.write(centerTurnPos);
rearServo.write(centerTurnPos);
delay(165);
frontServo.write(frontTurnLeftUp);
rearServo.write(backTurnRightForward);
delay(225);
frontServo.write(centerTurnPos);
rearServo.write(centerTurnPos);
delay(165);
}
//Sound function
void beeper()
{
// Sound by detecting an obstacle
for(int i=0; i<=8; i++) {
  digitalWrite(soundPin, HIGH);
  delay(30);
  digitalWrite(soundPin, LOW);
  delay(30);
}
}

void setup()
{
frontServo.attach(2);
rearServo.attach(3);
pinMode(pingPin, OUTPUT);
}

void loop()
{
distanceFront=distanceCm();
if (distanceFront > 1){ // Filters out any stray 0.00 error readings 7
if (distanceFront<startAvoidanceDistance) {
beeper();
for(int i=0; i<=8; i++) {
moveBackRight();
delay(walkSpeed);
}
for(int i=0; i<=10; i++) {
moveTurnLeft();
delay(walkSpeed);
}
} else {
moveForward();
delay(walkSpeed/100);
}
}
}
