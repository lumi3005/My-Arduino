/* Ping))) Sensor
 
   This sketch reads a PING))) ultrasonic rangefinder and returns the
   distance to the closest object in range. To do this, it sends a pulse
   to the sensor to initiate a reading, then listens for a pulse
   to return.  The length of the returning pulse is proportional to
   the distance of the object from the sensor.
     
   The circuit:
    * +V connection of the PING))) attached to +5V
    * GND connection of the PING))) attached to ground
    * SIG connection of the PING))) attached to digital pin 7

   http://www.arduino.cc/en/Tutorial/Ping
   
   created 3 Nov 2008
   by David A. Mellis
   modified 30 Jun 2009
   by Tom Igoe
 
   This example code is in the public domain.

 */

// this constant won't change.  It's the pin number
// of the sensor's output:
int pingPin = 4; 
int inPin = 5;
int ledPin = 7;
int motorPinRF = 9;
int motorPinRB = 10;
int motorPinLF = 11;
int motorPinLB = 12;
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
  delay(1000);
}

void motorBackLeft() {
// motor back function
  if (distance < 20){
    digitalWrite(motorPinRF, LOW);
    digitalWrite(motorPinLF, LOW);
    digitalWrite(motorPinRB, HIGH);
    digitalWrite(motorPinLB, HIGH);
    delay(1000);
    digitalWrite(motorPinRF, HIGH);
    digitalWrite(motorPinLF, LOW);
    digitalWrite(motorPinRB, LOW);
    digitalWrite(motorPinLB, HIGH);
  }
}

void motorGo() {
// motor Go function
  digitalWrite(motorPinRF, HIGH);
  digitalWrite(motorPinLF, HIGH);
  digitalWrite(motorPinRB, LOW);
  digitalWrite(motorPinLB, LOW);
}

void turnRight() {
// vehicle right turn function
 if (distance <10){
  digitalWrite(motorPinRF, LOW);
  digitalWrite(motorPinLF, HIGH);
  digitalWrite(motorPinRB, LOW);
  digitalWrite(motorPinLB, HIGH);
 }
}

void turnLeft() {
// vehicle left turn function
 if (distance >25){
  digitalWrite(motorPinRF, HIGH);
  digitalWrite(motorPinLF, LOW);
  digitalWrite(motorPinRB, LOW);
  digitalWrite(motorPinLB, HIGH);
 }
}

void setup() {
  // initialize serial communication:
  Serial.begin(9600);
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

  Serial.print(distance); // in centimeter
  Serial.print("cm");
  Serial.println();
 
  delay(100);

  if (distance < 20)
  {
    digitalWrite(ledPin, LOW);
    delay(30);
    digitalWrite(ledPin, HIGH);
    delay(30);
    digitalWrite(ledPin, LOW);
    delay(30);
    digitalWrite(ledPin, HIGH);
    delay(30);
    digitalWrite(ledPin, LOW);
    delay(30);
    digitalWrite(ledPin, HIGH);
    delay(30);
    digitalWrite(ledPin, LOW);
    delay(30);
    digitalWrite(ledPin, HIGH);
    delay(30);
    digitalWrite(ledPin, LOW);
    delay(30);
    digitalWrite(ledPin, HIGH);
    delay(30);
    digitalWrite(ledPin, LOW);
    delay(30);
    digitalWrite(ledPin, HIGH);
    delay(30);
    digitalWrite(ledPin, LOW);
    delay(30);
    digitalWrite(ledPin, HIGH);
    delay(30);
    digitalWrite(ledPin, LOW);
    delay(30);
    digitalWrite(ledPin, HIGH);
    delay(30);
    motorBackLeft();
    delay(300);
  }
  else
  {
    digitalWrite(ledPin, HIGH);
    motorGo();
  }
}
