/*    LMouse 
      from Lutz Michaelis http://www.roboter-selbstgebaut.com/
*/
int ledPin = 7;
int motorPinRF = 9;
int motorPinRB = 10;
int motorPinLF = 11;
int motorPinLB = 12;
int pingPin = 4; 
int inPin = 5;
int distance;

long microsecondsToInches(long microseconds)
{
  // According to Parallax's datasheet for the PING))), there are
  // 73.746 microseconds per inch (i.e. sound travels at 1130 feet per
  // second).  This gives the distance travelled by the ping, outbound
  // and return, so we divide by 2 to get the distance of the obstacle.
  // See: http://www.parallax.com/dl/docs/prod/acc/28015-PING-v1.3.pdf
  return microseconds / 74 / 2;
}

long microsecondsToCentimeters(long microseconds)
{
  // The speed of sound is 340 m/s or 29 microseconds per centimeter.
  // The ping travels out and back, so to find the distance of the
  // object we take half of the distance travelled.
  return microseconds / 29 / 2;
}

void motorStop() {
// motor stop function
  digitalWrite(motorPinRF, LOW);
  digitalWrite(motorPinLF, LOW);
  digitalWrite(motorPinRB, LOW);
  digitalWrite(motorPinLB, LOW);
}

void motorGo() {
// motor Go function
  digitalWrite(motorPinRF, HIGH);
  digitalWrite(motorPinLF, HIGH);
  digitalWrite(motorPinRB, LOW);
  digitalWrite(motorPinLB, LOW);
}

void motorBackLeft() {
// motor back function
    digitalWrite(motorPinRF, LOW);
    digitalWrite(motorPinLF, LOW);
    digitalWrite(motorPinRB, HIGH);
    digitalWrite(motorPinLB, HIGH);
    delay(1000);
    digitalWrite(motorPinRF, HIGH);
    digitalWrite(motorPinLF, LOW);
    digitalWrite(motorPinRB, LOW);
    digitalWrite(motorPinLB, HIGH);
    delay(500);
}

void turnRight() {
// vehicle right turn function
  digitalWrite(motorPinRF, LOW);
  digitalWrite(motorPinLF, HIGH);
  digitalWrite(motorPinRB, LOW);
  digitalWrite(motorPinLB, HIGH);
}

void turnLeft() {
// vehicle left turn function
  digitalWrite(motorPinRF, HIGH);
  digitalWrite(motorPinLF, LOW);
  digitalWrite(motorPinRB, LOW);
  digitalWrite(motorPinLB, HIGH);
}

void setup() {
  pinMode(ledPin, OUTPUT);
  pinMode(motorPinRF, OUTPUT);
  pinMode(motorPinRB, OUTPUT);
  pinMode(motorPinLF, OUTPUT);
  pinMode(motorPinLB, OUTPUT);
}

void loop()
{
  // establish variables for duration of the ping,
  // and the distance result in inches and centimeters:
  long duration; 
  pinMode(pingPin, OUTPUT); 
  digitalWrite(pingPin, LOW); 
  delayMicroseconds(2); 
  digitalWrite(pingPin, HIGH); 
  delayMicroseconds(10); 
  digitalWrite(pingPin, LOW);
  
  pinMode(inPin, INPUT); 
  duration = pulseIn(inPin, HIGH);
  
  distance = microsecondsToCentimeters(duration);
  
  digitalWrite(ledPin, HIGH);
  
  motorGo();
  digitalWrite(ledPin, HIGH);

  if (distance < 30 && distance > 20)
  {
    turnLeft();
  }
  else if (distance < 20 && distance > 10)
  {
    motorStop();
  }
  else if (distance < 10)
  {
    motorStop();
    motorBackLeft();
  }


}
