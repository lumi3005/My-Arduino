
#include <Servo.h>
Servo hip1;
Servo knee11;
Servo hip2;
Servo knee21;
Servo hip3;
Servo knee31;
Servo hip4;
Servo knee41;

int x;

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
 
void blink()
{
  if (x < 3)
  {
    for(x = 0; x < 3; x++)  // goes from 0 degrees to 180 degrees 
    {
      digitalWrite(13, HIGH);   // set the LED on
      delay(1000);              // wait for a second
      digitalWrite(13, LOW);    // set the LED off
      delay(500);
    }
  }
  
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

void forward()
{
  knee11.write(150);
  idle();
  hip1.write(45);
  hip4.write(80);
  idle();
  knee11.write(170);
  
  knee31.write(150); 
  idle();
  hip3.write(120);
  hip1.write(80);
  idle();
  knee31.write(170);
  
  knee21.write(40);
  idle();
  hip2.write(110);
  hip3.write(80);
  idle();
  knee21.write(20);
  
  knee41.write(40); 
  idle();
  hip4.write(30);
  hip2.write(80);
  idle();
  knee41.write(20);
  idle();
  
}

void stand()
{
  hip1.write(80);
  knee11.write(170);
    delay(20);
  hip2.write(80);
  knee21.write(20);
    delay(20);
  hip3.write(80);
  knee31.write(170);
    delay(20);
  hip4.write(80);
  knee41.write(20); 
    delay(20);
}
  
void loop()
{
  blink();
  //sleep();
  //delay(300);
  //stand();
  //delay(100);
  forward();  
  
}
