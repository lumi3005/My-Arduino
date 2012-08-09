#include <Servo.h>
// set the names of the servos
/*
hip1 = front right hip
knee11 = front right knee
hip2 = front left hip
knee21 = front left knee
hip3 = rear left hip
knee31 = rear left knee
hip4 = rear right hip
knee41 = rear right knee
eye = sevor for sensor
*/
Servo hip1;
Servo knee11;
Servo hip2;
Servo knee21;
Servo hip3;
Servo knee31;
Servo hip4;
Servo knee41;
Servo eye;
//////////////////////////////////////
void setup()
{
  pinMode(13, OUTPUT);  // LED pin
  // assign servos to pins and center servos
  hip1.attach(5);
  hip1.write(20);
  knee11.attach(6);
  knee11.write(90);
  hip2.attach(7);
  hip2.write(90);
  knee21.attach(8);
  knee21.write(90);
  hip3.attach(9);
  hip3.write(90);
  knee31.attach(10);
  knee31.write(90);
  hip4.attach(11);
  hip4.write(90);
  knee41.attach(12);
  knee41.write(90);
  eye.attach(4);
  eye.write(90);
  //
  //digitalRead(sensor);
}

void loop()
{
 // nothing here
}
