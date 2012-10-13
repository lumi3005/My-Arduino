#include "Servo8Bit.h"
Servo8Bit myServo;  //create a servo object.
                        //a maximum of five servo objects can be created

void setup()
{

    myServo.attach(1);  //attach the servo to pin PB1

    /*myServo.write(0);   //rotate to the 0 degree position
    delay(2000);        //wait 2 seconds

    myServo.write(180); //rotate to the 180 degree position
    delay(2000);        //wait 2 seconds
    
    myServo.write(90);  //rotate to the center (90 degree) position
    delay(4000);        //wait 2 seconds*/
    
    pinMode(0, OUTPUT);
    pinMode(2, OUTPUT);
}


void loop(){
  
  digitalWrite(0, HIGH);   // set the LED on
  delay(1000);              // wait for a second
  digitalWrite(0, LOW);    // set the LED off
  delay(500);
  for(int pos = 0; pos < 180; pos++)  // goes from 0 degrees to 180 degrees
  {                                   // in steps of 1 degree
    myServo.write(pos);             // tell servo to go to position in variable 'pos'
    delay(10);                      // waits 15ms for the servo to reach the position
  }
  for(int pos = 180; pos > 1; pos--)  // goes from 180 degrees to 0 degrees
  {
    myServo.write(pos);             // tell servo to go to position in variable 'pos'
    delay(10);                      // waits 15ms for the servo to reach the position
  }
}
