/***************************************************/
/////////////////////////////////////////////////////
///    Beetleduino (Speed reduced)                ///
///                                               ///
///    by Lutz Michaelis, June 2011               ///  
///    http://www.roboter-selbstgebaut.com        ///
///                                               ///
///    This code is in the public domain.         ///
///                                               ///
///                                               ///
/////////////////////////////////////////////////////
/***************************************************/
/////////////////////////////////////
// setup the output and input pins
/////////////////////////////////////
int frontPing = 2;      // initialize front sensor
int frontEcho = 3;      // initialize front echo  
int rightPing = 4;      // initialize right sensor
int rightEcho = 5;      // initialize right echo
int ledPin = 13;        // some lights 
int front_distance;     // front distance in centimeter
int right_distance;     // right distance in centimeter
//////////////////////////////////
// setup output for motor pins
//////////////////////////////////
int forward = 8;        // drive forward
int reverse = 9;        // drive reverse
int turnRight = 10;     // steer right
int turnLeft = 11;      // steer left
//////////////////////////////////////////////////////////////////////////////////////////////////////////
// initialize the ultra sound sensor and calculate the distance in centimeter (see description below)
//////////////////////////////////////////////////////////////////////////////////////////////////////////

  // According to Parallax's datasheet for the PING))), there are
  // 73.746 microseconds per inch (i.e. sound travels at 1130 feet per
  // second).  This gives the distance travelled by the ping, outbound
  // and return, so we divide by 2 to get the distance of the obstacle.
  // See: http://www.parallax.com/dl/docs/prod/acc/28015-PING-v1.3.pdf

long microsecondsToCentimeters(long microseconds)
{
  // The speed of sound is 340 m/s or 29 microseconds per centimeter.
  // The ping travels out and back, so to find the distance of the
  // object we take half of the distance travelled.
  return microseconds / 29 / 2;
}
////////////////////////////////////////////////////////////////////
// functions for driving and steering
////////////////////////////////////////////////////////////////////

void straight_forward(){          // nothing in front and perfect in line :-)
    digitalWrite(forward, HIGH);
    digitalWrite(reverse, LOW);
    digitalWrite(turnLeft, LOW);
    digitalWrite(turnRight,LOW);
}

void incoming(){                  // obstacle incoming steer a little bit to the left but do not reduce speed
    digitalWrite(forward, HIGH);
    digitalWrite(reverse, LOW);
    digitalWrite(turnLeft, HIGH);
    digitalWrite(turnRight, LOW);
}

void left_drift_turn(){          // danger of very near obstacle- reverse engine, steer right then steer left and g forward
    digitalWrite(forward, LOW);
    digitalWrite(reverse, HIGH);
    digitalWrite(turnLeft, LOW);
    digitalWrite(turnRight,HIGH);
    delay(500);
    digitalWrite(turnLeft, HIGH);
    digitalWrite(turnRight, LOW);
    digitalWrite(forward, HIGH);
    digitalWrite(reverse, LOW);
}

void left_turn(){                // to close to the wall, steer left
    digitalWrite(ledPin, HIGH);
    digitalWrite(turnLeft, HIGH);
    digitalWrite(turnRight, LOW);
}

void right_turn(){              // wall on the right side to far away, steer right
    digitalWrite(ledPin, LOW);
    digitalWrite(turnRight, HIGH);
    digitalWrite(turnLeft, LOW);
}

void setup() {
  // initialize serial communication for testing and debugging
  Serial.begin(9600);
  
  pinMode(ledPin, OUTPUT);     // some light
  pinMode(forward, OUTPUT);    // pin forward
  pinMode(reverse, OUTPUT);    // pin reverse
  pinMode(turnRight, OUTPUT);  // pin steer right
  pinMode(turnLeft, OUTPUT);   // pin steer left
  
}
// ok here we go...the race can start
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
/////////////////////////////////////////////////////////////////////////
// now wait 10ms that the next ping of the right sensor is not jammed
////////////////////////////////////////////////////////////////////////
  delay(10);
  //////////////////////////////////////////////////////
  // variables for duration of the right ping,
  //////////////////////////////////////////////////////
  long right_duration; 
  pinMode(rightPing, OUTPUT); 
  digitalWrite(rightPing, LOW); 
  delayMicroseconds(2); 
  digitalWrite(rightPing, HIGH); 
  delayMicroseconds(10); 
  digitalWrite(rightPing, LOW);

  pinMode(rightEcho, INPUT); 
  right_duration = pulseIn(rightEcho, HIGH);
////////////////////////////////////////////////////////////
// store the distance to the right side  (in centimeter)
///////////////////////////////////////////////////////////
  right_distance = microsecondsToCentimeters(right_duration);
///////////////////////////////////////////////////////////////////////////////////////////////
// serial communication - un-comment them to read the values of the front and right sensor
///////////////////////////////////////////////////////////////////////////////////////////////

  Serial.print("Right ");
  Serial.print(right_distance); // in centimeter
  Serial.print("cm ---- ");
  Serial.print("Front ");
  Serial.print(front_distance); // in centimeter
  Serial.print("cm");
  Serial.println();
 
  delay(100);

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// here is the important stuff. Decisions what to do during driving and what to do if sensor values reach a specific point
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if (front_distance < 50 && front_distance > 30)  // oh, there is an obstacle in my path but no need to panic it's still not in the danger zone, just steer to the left to avoid a crash
  {
    incoming();
  }
  else if (front_distance < 30 && front_distance >20)  // panic, there is something coming and already very close. try to drift by shortly reverse the engine and then go forward again
  {
    left_drift_turn();
  }
  else
  {
    straight_forward();  // everything is fine, nothing in front, right the wall is in the right distance...full trottle ;-)
    delay(250);
  }

  if (right_distance < 20)  // why is that wall on the right coming closer? Steer a little bit to the left.
  {
    left_turn();
  }
  else if (right_distance > 30 && front_distance > 50)  // Panic again, where is my wall, i am a wall racer and there is no wall. Steer to the right to find the wall again.
  {
    right_turn();
  }
 
}
