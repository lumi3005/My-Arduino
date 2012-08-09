//twoServosCenter.pde - Center two servos
// (c) Kimmo Karvinen & Tero Karvinen http://BotBook.com
//updated - Joe Saavedra, 2010
#include <Servo.h>
Servo Servo1;
Servo Servo2;
Servo Servo3;
Servo Servo4;

void setup()
{
Servo1.attach(8);
Servo1.write(90);
Servo2.attach(9);
Servo2.write(90);
Servo3.attach(10);
Servo3.write(90);
Servo4.attach(11);
Servo4.write(90);

}
void loop()
{
  
  Servo1.write(0);
  delay(100);
  Servo2.write(0);
  delay(100);
  Servo3.write(0);
  delay(100);
  Servo4.write(0);
  delay(1000);
  Servo1.write(180);
  delay(100);
  Servo2.write(180);
  delay(100);
  Servo3.write(180);
  delay(100);
  Servo4.write(180);
  delay(1000);
}
