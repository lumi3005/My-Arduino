/***************************************************/
/////////////////////////////////////////////////////
///    Chopstick Junior 1.0                       ///
///                                               ///
///    Code version 1.0.2                         ///
///    -> forward, left turn, right turn,         ///
///    -> stand up, sit down, sleep + gym         ///
///                                               ///
///    by Lutz Michaelis, November 2011           ///  
///    more about this robot and contact form:    ///
///    http://letsmakerobots.com/node/29708       ///
///    powered by                                 ///
///    http://www.roboter-selbstgebaut.com        ///
///                                               ///
///    This code is in the public domain.         ///
///                                               ///
/////////////////////////////////////////////////////
/*********************************************************************************************************************/
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///                                                                                                                 ///
///  Ok, some words to this code. This code is working with MY robot. You are free to copy that code and you can    ///
///  use it for your robot as well . If you publish it in any way again, then please keep my credits in here.       ///
///  There is no guarantee that it's also working with yours since it's a quadruped and there is all about balance. ///
///  Even the slightest weight difference will bring your robot in danger of falling over.                          ///
///  I tried to comment as much as I could but I also know that some of you will not understand the code at all.    ///
///  As I am quite busy I can not response to each question so please be patience and wait for the updated code     ///
///  (hopefully with more comments and better structure ;-)                                                         ///
///  Now...please do not waste time and proceed with your project and share it on letsmakerobots.com                ///
///                                                                                                                 ///
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*********************************************************************************************************************/

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
*/
Servo hip1;
Servo knee11;
Servo hip2;
Servo knee21;
Servo hip3;
Servo knee31;
Servo hip4;
Servo knee41;
// set variables needed for some tasks
int b;
int x;
int w;
int up;
int up2;
int up3;
int down;
int down2;
int steps;
int rightsteps;
int leftsteps;
int back;
//////////////////////////////////////
void setup()
{
  pinMode(13, OUTPUT);  // LED pin
  // assign servos to pins and center servos
  hip1.attach(5);
  hip1.write(90);
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
}
//////////////////////////////////////
void idle() // this is the delay between the steps -> walking speed
 {
  delay(70);  // if set to a bigger number (more delay between the steps -> slower walking) you will see the walking pattern more clearly
 }
////////////////////////////////////// 
void test() /* just for debugging -> if need a delay between the subroutines 
               you can let the LED blink as an indicator that something is still running  */
{
    for(b = 0; b < 2; b++) // this let the LED blink 5 times 
    {
      digitalWrite(13, HIGH);   // turn the LED on
      delay(200);               // wait for .5 second
      digitalWrite(13, LOW);    // turn the LED off
      delay(100);
    }  
}
//////////////////////////////////////
void standup()
{
  up2 = 90;
  up3 = 90;
  hip1.write(70);
  hip2.write(80);
  hip3.write(120);
  hip4.write(70);
  for(up = 90; up < 170; up++)
  {
    knee11.write(up);
    up2 = up2 - 1;
    knee21.write(up2);
    delay(20);
  }
  
  for(up = 90; up < 180; up++)
  {
    knee31.write(up);
    up3 = up3 - 1;
    knee41.write(up3);
    delay(15);
  }
}
//////////////////////////////////////
void sleep()
{
  // hips
  hip1.write(70);
  hip2.write(90);
  hip3.write(70);
  hip4.write(90);
  // knees
  knee11.write(0);
  knee21.write(180);
  knee31.write(0);
  knee41.write(180);
}
//////////////////////////////////////
void stand()
{
  hip1.write(70);
  knee11.write(170);
    delay(20);
  hip2.write(80);
  knee21.write(20);
    delay(20);
  hip3.write(80);
  knee31.write(170);
    delay(20);
  hip4.write(70);
  knee41.write(20); 
    delay(20);
}
//////////////////////////////////////
void forward()
{
  // lift front right knee, move front right hip forward and rear right hip backward, lower front right knee
  knee11.write(150);
  idle();
  hip1.write(45);
  hip4.write(90);
  idle();
  knee11.write(170);
  // lift rear left knee, move rear left hip forward and front right hip backward, lower rear left knee 
  knee31.write(150); 
  idle();
  hip3.write(120);
  hip1.write(110);
  idle();
  knee31.write(170);
  // lift front left knee, move front left hip forward and rear left hip backward, lower front left knee
  knee21.write(40);
  idle();
  hip2.write(110);
  hip3.write(60);
  idle();
  knee21.write(20);
  // lift rear right knee, move rear right hip forward and front left hip backward, lower rear right knee  
  knee41.write(40); 
  idle();
  hip4.write(30);
  hip2.write(80);
  idle();
  knee41.write(20);
  idle();
}
/////////////////////////////////////
void rightturn()
{
  // lift front right knee, move front right hip forward and rear right hip backward, lower front right knee
  knee11.write(150);
  idle();
  hip1.write(30);
  hip4.write(90);
  idle();
  knee11.write(170);
  // lift rear left knee, move rear left hip forward and front right hip backward, lower rear left knee 
  knee31.write(150); 
  idle();
  hip3.write(130);
  hip1.write(100);
  idle();
  knee31.write(170);
  // lift front left knee, move front left hip forward and rear left hip backward, lower front left knee
  knee21.write(40);
  idle();
  hip2.write(130);
  hip3.write(50);
  idle();
  knee21.write(20);
  // lift rear right knee, move rear right hip forward and front left hip backward, lower rear right knee  
  knee41.write(40); 
  idle();
  hip4.write(70);
  hip2.write(50);
  idle();
  knee41.write(20);
  idle();
}
/////////////////////////////////////
void leftturn()
{
  // lift front right knee, move front right hip forward and rear right hip backward, lower front right knee
  knee11.write(150);
  idle();
  hip1.write(30);
  hip4.write(100);
  idle();
  knee11.write(170);
  // lift rear left knee, move rear left hip forward and front right hip backward, lower rear left knee 
  knee31.write(150); 
  idle();
  hip3.write(90);
  hip1.write(120);
  idle();
  knee31.write(170);
  // lift front left knee, move front left hip forward and rear left hip backward, lower front left knee
  knee21.write(40);
  idle();
  hip2.write(90);
  hip3.write(60);
  idle();
  knee21.write(20);
  // lift rear right knee, move rear right hip forward and front left hip backward, lower rear right knee  
  knee41.write(40); 
  idle();
  hip4.write(30);
  hip2.write(80);
  idle();
  knee41.write(20);
  idle();
}
/////////////////////////////////////
void backward()
{
// lift front right knee, move front right hip backward and rear right hip forward, lower front right knee
  knee11.write(150);
  idle();
  hip1.write(100);
  hip4.write(50);
  idle();
  knee11.write(170);
  // lift rear left knee, move rear left hip backward and front right hip forward, lower rear left knee 
  knee31.write(150); 
  idle();
  hip3.write(60);
  hip1.write(45);
  idle();
  knee31.write(170);
  // lift front left knee, move front left hip backward and rear left hip forward, lower front left knee
  knee21.write(40);
  idle();
  hip2.write(70);
  hip3.write(120);
  idle();
  knee21.write(20);
  // lift rear right knee, move rear right hip backward and front left hip forward, lower rear right knee  
  knee41.write(40); 
  idle();
  hip4.write(110);
  hip2.write(110);
  idle();
  knee41.write(20);
  idle();
}
/////////////////////////////////////
void laydowndown() // lay down
{
  hip1.write(70);
  hip2.write(80); 
  for (down = 170; down > 90; down = down - 1){
      knee11.write(down);
      down2 = 190 - down;
      knee21.write(down2);
      delay(15);
   } 
  delay(1000);
  hip3.write(80);
  hip4.write(70);
  for (down = 170; down > 90; down = down - 1){
      knee31.write(down);
      down2 = 190 - down;
      knee41.write(down2);
      delay(15);
  }
}
/////////////////////////////////////
void gym() // ok, this is not very serious but I needed to cheer me up a bit ;-) just see...
{
  int y;
  hip1.write(70);
  knee31.write(130);
  delay(200);
  knee21.write(40);
  hip2.write(110);
  knee21.write(20);
    delay(20);
  knee11.write(60);
    delay(20);
  hip3.write(120);
      delay(20);
  hip4.write(70);
  knee41.write(20); 
    delay(20);   
}
/////////////////////////////////////
void wink()
{
  for (b = 0; b < 3; b++){
  for (w = 60; w < 20; w = w -1)
  {
    knee11.write(w);
    delay(10);
  }
    for (w = 20; w < 60; w++)
  {
    knee11.write(w);
    delay(10);
  }
    delay(200);
  }
}
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
void loop()
{
  sleep();                      // start from this position
  test();                       // this is the delay between each pattern
  standup();                    // let the robot go from sleep to standing position
  test();                       // this is the delay between each pattern  
  while(steps < 10){            // just a loop for 10 steps forward since he still have no eyes
  forward();
  steps++;
  }
  test();
  while(rightsteps < 10){       // just a loop for 10 steps right turn since he still have no eyes
  rightturn();
  rightsteps++;
  }
  test();                       // this is the delay between each pattern
  while(leftsteps < 10){        // just a loop for 10 steps left turn since he still have no eyes
  leftturn();
  leftsteps++;
  }
  while(back < 10){        // just a loop for 10 steps left turn since he still have no eyes
  backward();
  back++;
  }
  gym();                        // doing some funny (i think) move 
  test();                       // this is the delay between each pattern
  wink();
  test();
  laydowndown();                // lay down after these exercises
  test();                       // this is the delay between each pattern
}
