#include <Servo.h>

Servo myservo [4];  // create servo object to control four servos

int pos [4] = 0;    // variable to store the servo position

void setup()
{
  myservo[0].attach(9);  // attaches the servo on pin 9 to a servo object
  myservo[1].attach(8);  // attaches the servo on pin 8 to a servo object
  myservo[2].attach(7);  // attaches the servo on pin 7 to a servo object
  myservo[3].attach(5);  // attaches the servo on pin 5 to a servo object
}

void loop()
{
  for (int i = 0; i < 4; ++i) {
      for(pos[i] = 0; pos[i] < 180; pos[i] += 1)
    {
       myservo[i].write(pos[i]);
       delay(5);                       // waits 5ms for the servo to reach the position
    }
    for(pos[i] = 180; pos[i]>=1; pos[i]-=1)     // goes from 180 degrees to 0 degrees
    {
       myservo[i].write(pos[i]);              // tell servo to go to position in variable 'pos'
       delay(5);                       // waits 5ms for the servo to reach the position
    }
  }
}
 
