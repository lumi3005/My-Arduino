#include <Servo.h>

//Servo ID
#define lls 0
#define lfs 1
#define rls 2
#define rfs 3
#define hh 4
#define hv 5

#define bankLeft -1
#define bankNeutral 0
#define bankRight 1

#define walkLeft -1
#define walkNeutral 0
#define walkRight 1

Servo servos[6];
int offset[6] = {-3, -5, -3, 11, 0, 0};
int ports[6] = {2, 3, 4, 5, 6, 7};
int servoPos[6];
int leftBankAngles[3] = {-25, 0, 45};
int rightBankAngles[3] = {-45, 0, 25};
int leftSpeeds[3] = {1, 1, 2};
int rightSpeeds[3] = {2, 1, 1};
int leftLegAngles[3] = {15, 0, -15};
int rightLegAngles[3] = {15, 0, -15};
int legSpeed = 1;


void setup()
{

  for (int i = lls; i <= hv; i++) {
    moveServo(i, 0);
    servos[i].attach(ports[i]);
    moveServo(i, 0);
  }

  for(int i = 0; i < 50; i++) {
    Servo::refresh();  
    delay(50);
  }  

}

void moveServo(int servo, int pos) 
{
  servos[servo].write(90+offset[servo]+pos);
  servoPos[servo] = pos;
  delay(10);
}

void bank(int direction)
{
  int lfPos = servoPos[lfs];
  int rfPos = servoPos[rfs];
  int lfMoveTo = leftBankAngles[direction + 1];
  int rfMoveTo = rightBankAngles[direction + 1];
  int bankDone = 0;
  int lfDir, rfDir;

  if (lfPos > lfMoveTo)
    lfDir = -1;
  else
    lfDir = 1;

  if (rfPos > rfMoveTo)
    rfDir = -1;
  else
    rfDir = 1;

  while (!bankDone) {
    bankDone = 1;
    if (lfMoveTo + leftSpeeds[direction+1] - 1 < lfPos || lfMoveTo - leftSpeeds[direction+1] + 1 > lfPos) {
      moveServo(lfs, lfPos+lfDir*leftSpeeds[direction+1]);
      bankDone = 0;
    }

    if (rfMoveTo + rightSpeeds[direction+1] - 1 < rfPos || rfMoveTo - rightSpeeds[direction+1] + 1 > rfPos) {
      moveServo(rfs, rfPos+rfDir*rightSpeeds[direction+1]);
      bankDone = 0;
    }

    lfPos = servoPos[lfs];
    rfPos = servoPos[rfs];

    Servo::refresh();
  }

}


void moveLegs(int direction)
{
  int llPos = servoPos[lls];
  int rlPos = servoPos[rls];
  int llMoveTo = leftLegAngles[direction + 1];
  int rlMoveTo = rightLegAngles[direction + 1];
  int walkDone = 0;
  int llDir, rlDir;

  if (llPos > llMoveTo)
    llDir = -1;
  else
    llDir = 1;

  if (rlPos > rlMoveTo)
    rlDir = -1;
  else
    rlDir = 1;

  while (!walkDone) {
    walkDone = 1;
    if (llMoveTo + legSpeed - 1 < llPos || llMoveTo - legSpeed + 1 > llPos) {
      moveServo(lls, llPos+llDir*legSpeed);
      walkDone = 0;
    }

    if (rlMoveTo + legSpeed - 1 < rlPos || rlMoveTo - legSpeed + 1 > rlPos) {
      moveServo(rls, rlPos+rlDir*legSpeed);
      walkDone = 0;
    }

    llPos = servoPos[lls];
    rlPos = servoPos[rls];

    Servo::refresh();
  }  
}

void busyWait(int duration) 
{
  for(int i = 0; i < duration/20; i++) {
    delay(20);
    Servo::refresh();
  }
}


int i,j,dir = 0;

void loop()
{

  bank(bankLeft);
//  busyWait(500);
  moveLegs(walkLeft);
//  busyWait(500);
  bank(bankNeutral);
//  busyWait(500);
  bank(bankRight);
//  busyWait(500);
  moveLegs(walkRight);
//  busyWait(500);
  bank(bankNeutral);
//  busyWait(500);

}
