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
// Sweep
// by BARRAGAN <http://barraganstudio.com> 
// This example code is in the public domain.


#include <Servo.h> 
 
Servo myservo;  // create servo object to control a servo 
                // a maximum of eight servo objects can be created 
 
int pos = 0;    // variable to store the servo position
// this constant won't change.  It's the pin number
// of the sensor's output:
int pingPin = 4; 
int inPin = 5;
int ledPinL = 7;
int ledPinR = 3;
int distance;
int leftDistance;
int rightDistance;

int motorPinRF = 10;
int motorPinRB = 11;
int motorPinLF = 12;
int motorPinLB = 13;

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

void motorBack() {
// motor back function
    digitalWrite(motorPinRF, LOW);
    digitalWrite(motorPinLF, LOW);
    digitalWrite(motorPinRB, HIGH);
    digitalWrite(motorPinLB, HIGH);
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
  digitalWrite(motorPinRF, LOW);
  digitalWrite(motorPinLF, HIGH);
  digitalWrite(motorPinRB, HIGH);
  digitalWrite(motorPinLB, LOW);
}

void turnLeft() {
// vehicle left turn function
  digitalWrite(motorPinRF, HIGH);
  digitalWrite(motorPinLF, LOW);
  digitalWrite(motorPinRB, LOW);
  digitalWrite(motorPinLB, HIGH);
}

void ping() {
  // establish variables for duration of the ping,
  // and the distance result in centimeters:
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
}

void setup() {
  // initialize serial communication:
  //Serial.begin(9600);
  myservo.attach(9);  // attaches the servo on pin 9 to the servo object
  // LED for checking without motor
  pinMode(ledPinL, OUTPUT);
  pinMode(ledPinR, OUTPUT);
  pinMode(motorPinRF, OUTPUT);
  pinMode(motorPinRB, OUTPUT);
  pinMode(motorPinLF, OUTPUT);
  pinMode(motorPinLB, OUTPUT);
}

void loop()
{
  ping();  
  //Serial.println();
  //delay(100);

  if (distance > 20){
    motorGo();
    //Serial.print(distance); // in centimeter
    //Serial.print(" distance front .... ");
  }
  else if (distance < 20)
  {
    // motor stop
    motorStop();
    /* start sweep */
    for(pos = 80; pos < 180; pos +=2)    // goes from 0 degrees to 180 degrees 
  {                                      // in steps of 1 degree 
    myservo.write(pos);                 // tell servo to go to position in variable 'pos'                    
    delay(15);                          // waits 15ms for the servo to reach the position 
  } 
  ping();
  // save the ping value
  leftDistance = distance;
  for(pos = 180; pos>=1; pos-=2)         // goes from 180 degrees to 0 degrees 
  {                                
    myservo.write(pos);                 // tell servo to go to position in variable 'pos' 
    delay(15);                         // waits 15ms for the servo to reach the position
  /* end sweep */
  myservo.write(80);
  } 
  ping();
  // save the ping value
  rightDistance = distance; 
  if (leftDistance < rightDistance) {
    //Serial.print(rightDistance); // in centimeter
    //Serial.print(" cm right");
    //Serial.println();
    turnLeft();
    //digitalWrite(ledPinR, HIGH);
    delay(200); 
  }
  else if (leftDistance > rightDistance)
  {
    //Serial.print(leftDistance); // in centimeter
    //Serial.print(" cm left ");
    //Serial.println();
    turnRight();
    //digitalWrite(ledPinL, HIGH);
    delay(200);
  }
  }
}
