int RIGHT_CTRL_P = 5;
int RIGHT_CTRL_B = 6;
int RIGHT_CTRL_F = 7;

int LEFT_CTRL_P = 8;
int LEFT_CTRL_B = 9;
int LEFT_CTRL_F = 10;

int frontPing = 11;      // initialize front sensor
int frontEcho = 12;      // initialize front echo 
int ledPin = 13;        // some lights 

int front_distance;

long microsecondsToCentimeters(long microseconds)
{
  // The speed of sound is 340 m/s or 29 microseconds per centimeter.
  // The ping travels out and back, so to find the distance of the
  // object we take half of the distance travelled.
  return microseconds / 29 / 2;
}

/*
#define RIGHT_CTRL_1 5
#define RIGHT_CTRL_2 6
#define RIGHT_CTRL_3 7

#define LEFT_CTRL_1 8
#define LEFT_CTRL_2 9
#define LEFT_CTRL_3 10
*/

void setup()
{
 pinMode(RIGHT_CTRL_B, OUTPUT);
 pinMode(RIGHT_CTRL_F, OUTPUT);
 pinMode(LEFT_CTRL_B, OUTPUT);
 pinMode(LEFT_CTRL_F, OUTPUT);
}

void back_left() 
{
  digitalWrite(RIGHT_CTRL_B, HIGH);
  digitalWrite(RIGHT_CTRL_F, LOW);
  analogWrite(RIGHT_CTRL_P, 350);
  digitalWrite(LEFT_CTRL_B, HIGH);
  digitalWrite(LEFT_CTRL_F, LOW);
  analogWrite(LEFT_CTRL_P, 250);
}

void go()
{
  digitalWrite(RIGHT_CTRL_B, LOW);
  digitalWrite(RIGHT_CTRL_F, HIGH);
  analogWrite(RIGHT_CTRL_P, 500);
  digitalWrite(LEFT_CTRL_B, LOW);
  digitalWrite(LEFT_CTRL_F, HIGH);
  analogWrite(LEFT_CTRL_P, 500);
}

void loop()
{

//////////////////////////////////////////////////
// variables for duration of the front ping,
//////////////////////////////////////////////////
  long front_duration; 
  pinMode(frontPing, OUTPUT); 
  digitalWrite(frontPing, LOW); 
  delayMicroseconds(2); 
  digitalWrite(frontPing, HIGH); 
  delayMicroseconds(10); 
  digitalWrite(frontPing, LOW);

  pinMode(frontEcho, INPUT); 
  front_duration = pulseIn(frontEcho, HIGH);
/////////////////////////////////////////////////
// store the distance in front (in centimeter)
/////////////////////////////////////////////////
  front_distance = microsecondsToCentimeters(front_duration);
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// here is the important stuff. Decisions what to do during driving and what to do if sensor values reach a specific point
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (front_distance < 20)  // oh, there is an obstacle in my path
  {
    back_left();
  }
  else // noithing there...just go
  {
    go();
  }
}
