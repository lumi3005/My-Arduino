//Author:	HE Qichen
//Email:	heqichen(a)gaishi.vicp.net
//Website:	http://gaishi.vicp.net
//Date:	2011-5-1

int status;

//#define LEFT_SPEED   6
#define LEFT_FORWARD  7
#define LEFT_BACKWARD  8

//#define RIGHT_SPEED  10
#define RIGHT_FORWARD  11
#define RIGHT_BACKWARD  12

#define ULTRASONIC_ECHO  3
#define ULTRASONIC_TRIG  4

//int ledPin = 6;

//#define NORMAL_SPEED  100
//#define STOP_SPEED  0

void setup()
{
  Serial.begin(9600);
  setupMove();
  setupUltrasonic();
}

void loop()
{
  unsigned int d;
  moveForward();
  d = readDistance();
  Serial.println(d, DEC);
  if (d < 700)
  {
    //digitalWrite(ledPin, LOW);
    moveBackward();
    delay(1000);
    turnLeft();
    delay(600);
  }
  //digitalWrite(ledPin, HIGH);
}

void moveForward()
{
  //analogWrite(LEFT_SPEED, NORMAL_SPEED);
  digitalWrite(LEFT_BACKWARD, LOW);
  digitalWrite(LEFT_FORWARD, HIGH);
  //analogWrite(RIGHT_SPEED, NORMAL_SPEED);
  digitalWrite(RIGHT_BACKWARD, LOW);
  digitalWrite(RIGHT_FORWARD, HIGH);
}

void moveBackward()
{
  //analogWrite(LEFT_SPEED, NORMAL_SPEED);
  digitalWrite(LEFT_BACKWARD, HIGH);
  digitalWrite(LEFT_FORWARD, LOW);
  //analogWrite(RIGHT_SPEED, NORMAL_SPEED);
  digitalWrite(RIGHT_BACKWARD, HIGH);
  digitalWrite(RIGHT_FORWARD, LOW);
}

void turnLeft()
{
  //analogWrite(LEFT_SPEED, NORMAL_SPEED);
  digitalWrite(LEFT_BACKWARD, HIGH);
  digitalWrite(LEFT_FORWARD, LOW);
  //analogWrite(RIGHT_SPEED, NORMAL_SPEED);
  digitalWrite(RIGHT_BACKWARD, LOW);
  digitalWrite(RIGHT_FORWARD, HIGH);
}

void turnRight()
{
  //analogWrite(LEFT_SPEED, NORMAL_SPEED);
  digitalWrite(LEFT_BACKWARD, LOW);
  digitalWrite(LEFT_FORWARD, HIGH);
  //analogWrite(RIGHT_SPEED, NORMAL_SPEED);
  digitalWrite(RIGHT_BACKWARD, HIGH);
  digitalWrite(RIGHT_FORWARD, LOW);
}

void moveStop()
{
  //analogWrite(LEFT_SPEED, STOP_SPEED);
  digitalWrite(LEFT_BACKWARD, LOW);
  digitalWrite(LEFT_FORWARD, LOW);
  //analogWrite(RIGHT_SPEED, STOP_SPEED);
  digitalWrite(RIGHT_BACKWARD, LOW);
  digitalWrite(RIGHT_FORWARD, LOW);
}

void setupMove()
{
  //pinMode(LEFT_SPEED, OUTPUT);
  pinMode(LEFT_FORWARD, OUTPUT);
  pinMode(LEFT_BACKWARD, OUTPUT);
  //pinMode(RIGHT_SPEED, OUTPUT);
  pinMode(RIGHT_FORWARD, OUTPUT);
  pinMode(RIGHT_BACKWARD, OUTPUT);

  //analogWrite(LEFT_SPEED, STOP_SPEED);
  digitalWrite(LEFT_FORWARD, LOW);
  digitalWrite(LEFT_BACKWARD, LOW);
  //analogWrite(RIGHT_SPEED, STOP_SPEED);
  digitalWrite(RIGHT_FORWARD, LOW);
  digitalWrite(RIGHT_BACKWARD, LOW);
}

unsigned int readDistance()
{

  int duration;
  digitalWrite(ULTRASONIC_TRIG, LOW);
  delayMicroseconds(2);
  digitalWrite(ULTRASONIC_TRIG, HIGH);
  delayMicroseconds(5);
  digitalWrite(ULTRASONIC_TRIG, LOW);

  // The same pin is used to read the signal from the PING))): a HIGH
  // pulse whose duration is the time (in microseconds) from the sending
  // of the ping to the reception of its echo off of an object.
  duration = pulseIn(ULTRASONIC_ECHO, HIGH);
  return duration;

}

void  setupUltrasonic()
{
  pinMode(ULTRASONIC_TRIG, OUTPUT);
  pinMode(ULTRASONIC_ECHO, INPUT);

  digitalWrite(ULTRASONIC_TRIG, LOW);
}

