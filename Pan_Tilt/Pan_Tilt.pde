// Sweep
// by BARRAGAN <http://barraganstudio.com> 
// This example code is in the public domain.


#include <Servo.h> 
 
Servo myservo1;  // create servo object to control a servo 
                // a maximum of eight servo objects can be created 
Servo myservo2;  // create servo object to control a servo 
                // a maximum of eight servo objects can be created
 
int pos1 = 0;    // variable to store the servo position 
int pos2 = 0;    // variable to store the servo position 
 
void setup() 
{ 
  myservo1.attach(11);  // attaches the servo on pin 9 to the servo object
  myservo2.attach(12);  // attaches the servo on pin 9 to the servo object
} 
 
 
void loop() 
{ 
  for(pos1 = 0; pos1 < 180; pos1 += 1)  // goes from 0 degrees to 180 degrees 
  {                                  // in steps of 1 degree 
    myservo1.write(pos1);              // tell servo to go to position in variable 'pos' 
    delay(15);                       // waits 15ms for the servo to reach the position 
  } 
  for(pos1 = 180; pos1>=1; pos1-=1)     // goes from 180 degrees to 0 degrees 
  {                                
    myservo1.write(pos1);              // tell servo to go to position in variable 'pos' 
    delay(15);                       // waits 15ms for the servo to reach the position 
  } 
  
  for(pos2 = 0; pos2 < 180; pos2 += 1)  // goes from 0 degrees to 180 degrees 
  {                                  // in steps of 1 degree 
    myservo2.write(pos2);              // tell servo to go to position in variable 'pos' 
    delay(15);                       // waits 15ms for the servo to reach the position 
  } 
  for(pos2 = 180; pos2>=1; pos2-=1)     // goes from 180 degrees to 0 degrees 
  {                                
    myservo2.write(pos2);              // tell servo to go to position in variable 'pos' 
    delay(15);                       // waits 15ms for the servo to reach the position 
  }
} 
