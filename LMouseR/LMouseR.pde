/*    LMouseR 
      by Lutz Michaelis aka Lumi http://www.roboter-selbstgebaut.com/ and http://letsmakerobots.com/user/14721
*/
// set the pins for input and output
int ledPin = 7;
int motorPinRF = 9;
int motorPinRB = 10;
int motorPinLF = 11;
int motorPinLB = 12;
int pingPin = 4; 
int inPin = 5;
int distance;
// analog light sensor
int sensorLeft = A0;    
int sensorRight = A1;

int sensorValueLeft = 0;  
int sensorValueRight = 0;

int diff;

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
// Motor functions...nothing to explain, just try to get the two moptors running as you want that they do.
void motorStop() {
// motor stop function
  digitalWrite(motorPinRF, LOW);
  digitalWrite(motorPinLF, LOW);
  digitalWrite(motorPinRB, LOW);
  digitalWrite(motorPinLB, LOW);
}

void motorGo() {
// motor Go function
  digitalWrite(motorPinRF, HIGH); // Right motor forward
  digitalWrite(motorPinLF, HIGH); // Left motor forward
  digitalWrite(motorPinRB, LOW);  // Right motor NOT backward
  digitalWrite(motorPinLB, LOW);  // Left motor NOT backward
}
// For the other functions just refer to motorGo above
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

  motorGo();  // if no interuption because of something in my way then just go straight forward as long as the batteries can power me
  digitalWrite(ledPin, HIGH); // turn on some light ;-)

  if (distance < 30 && distance > 20)      // Some decisions to make - turn left if distance is less than 30cm but more than 20cm
  {
    turnLeft();
  }
  else if (distance < 20 && distance > 10)  // ok, now it's critical. Somehow the dstance is in the danger value...so just stop the motor and wait...there is nothing what could make me moving again but to remove this obstacle in front of me or wave with your hand in front of my eyes.
  {
    motorStop();
  }
  else if (distance < 10) // ok, retreat...there is something very close, so stop and then move backwards 
  {
    motorStop();
    delay(1000);
    motorBackLeft();
  }


}
