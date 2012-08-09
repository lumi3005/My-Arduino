
#include <Servo.h>
Servo hip1;
Servo knee11;
Servo hip2;
Servo knee21;
Servo hip3;
Servo knee31;
Servo hip4;
Servo knee41;

int b;
int x;
int up;
int up2;
int steps;

void setup()
{
  pinMode(13, OUTPUT);

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
 void idle()
 {
  delay(70);
 }
 
void test()
{
    for(b = 0; b < 5; b++)  // goes from 0 degrees to 180 degrees 
    {
      digitalWrite(13, HIGH);   // set the LED on
      delay(1000);              // wait for a second
      digitalWrite(13, LOW);    // set the LED off
      delay(1000);
    }  
}

void blink()
{
  if (b < 3)
  {
    for(b = 0; b < 2; b++)  // goes from 0 degrees to 180 degrees 
    {
      digitalWrite(13, HIGH);   // set the LED on
      delay(1000);              // wait for a second
      digitalWrite(13, LOW);    // set the LED off
      delay(500);
    }
  }
  
}

void sit()
{
  up2 = 80;
  hip1.write(70);
  //knee11.write(170);
  hip2.write(80);
  //knee21.write(20);
  
  for(up = 90; up < 170; up++)
  {
  knee11.write(up);
  up2 = up2-1;
  knee21.write(up2);
  delay(15);
  }
  
  hip1.write(70);
  //knee11.write(170);
  hip2.write(80);
  //knee21.write(20);
  hip3.write(120);
  knee31.write(90);
  hip4.write(30);
  knee41.write(90); 

}

void standup()
{
  up2 = 90;
  hip1.write(70);
  knee11.write(170);
  hip2.write(80);
  knee21.write(20);
  hip3.write(120);
  for(up = 90; up < 180; up++)
  {
  knee31.write(up);
  up2 = up2-1;
  knee41.write(up2);
  delay(15);
  }
/*  hip4.write(100);
  for(up2 = 90; up2 < 1; up2 = up2 - 1)
  {
  knee41.write(up2);
  delay(15);
  }*/
}

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

void forward()
{
  knee11.write(150);
  idle();
  hip1.write(45);
  hip4.write(90);
  idle();
  knee11.write(170);
  
  knee31.write(150); 
  idle();
  hip3.write(120);
  hip1.write(90);
  idle();
  knee31.write(170);
  
  knee21.write(40);
  idle();
  hip2.write(110);
  hip3.write(90);
  idle();
  knee21.write(20);
  
  knee41.write(40); 
  idle();
  hip4.write(30);
  hip2.write(80);
  idle();
  knee41.write(20);
  idle();
  steps = steps + 1;
}

void loop()
{
  //blink();
  //sleep();
  //delay(300);
  //stand();
  //delay(100);
  //forward();
  if(b < 1)
  {
    test();
    sit(); 
    standup();
  }
  if(steps < 20)
  {
    forward();
  } 
   else
  {
    sit();
    delay(1000);
    sleep();
    delay(50000);
  } 
}
