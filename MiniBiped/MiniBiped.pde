#include <EEPROM.h>
#include <Servo.h>
#include "IO_pins.h"


// define global variables

byte botID=0;                                                  // This is the soccerbots ID number 0-5
byte mode=0;                                                   // 0 = stop/kick/look  1 = walk  
byte cmode=0;                                                  // 0 = hip calibration  1 = knee calibration

int Lkc;                                                       // initial value 1550
int Rkc;                                                       // initial value 1550
int Lhc;                                                       // initial value 1500
int Rhc;                                                       // initial value 1500

int Lkp;
int Rkp;
int Lhp;
int Rhp;

int stride=400;
int flift=140;
boolean Lstop=0;
boolean Rstop=0;

int led=1;

int IRC;
int pulse;
int i=0;
int j=0;

byte dir=0;
int turn90=4;
int turn45=2;
int stopTime=100;
int stepTime=3;
int IRdistance=0;
int treshold=20; //20cm min distance

#define center 80

// define servos
Servo Pan;
Servo Lknee;
Servo Rknee;
Servo Lhip;
Servo Rhip;

void setup()
{
  /*Lkc=EEPROM.read(0)*256;                                    // high byte - initial value 1550
  Lkc+=EEPROM.read(1);                                       // low byte

  Rkc=EEPROM.read(2)*256;                                    // high byte - initial value 1550
  Rkc+=EEPROM.read(3);                                       // low byte

  Lhc=EEPROM.read(4)*256;                                    // high byte - initial value 1500
  Lhc+=EEPROM.read(5);                                       // low byte

  Rhc=EEPROM.read(6)*256;                                    // high byte - initial value 1500
  Rhc+=EEPROM.read(7);                                       // low byte
  
  botID=EEPROM.read(8);                                      // read soccerbot ID from EEPROM
  
  if (Lkc<1000 || Lkc>2000 || Lhc<1000 || Lhc>2000 || Rkc<1000 || Rkc>2000 || Rhc<1000 || Rhc>2000)
  {*/
    Lkc=1500;
    Lhc=1500;
    Rkc=1500; //+50
    Rhc=1500; //-30
    //Store();
  //}
  
  Lkp=Lkc;
  Rkp=Rkc;
  Lhp=Lhc;
  Rhp=Rhc;

  Pan.attach(Panpin);
  Lknee.attach(Lkneepin);
  Rknee.attach(Rkneepin);
  Lhip.attach(Lhippin);
  Rhip.attach(Rhippin);

  Servopos();
  Pan.write(center);
  
  //pinMode(IRpin,OUTPUT);                                     // IR and Arduino LEDs
  pinMode(LEDpin,OUTPUT);                                    // Back pack LED
  pinMode(Speakerpin,OUTPUT);                                // Speaker

  Serial.begin(19200);
  Serial.println("start");

  //----------------------------- play tune on powerup / reset -----------------------------------------

  int melody[] = {262,196,196,220,196,1,247,262};
  int noteDurations[] = {4,8,8,4,4,4,4,4};
  for (byte Note = 0; Note < 8; Note++)                                  // Play eight notes
  {
    long pulselength = 1000000/melody[Note];
    long noteDuration = 1000/noteDurations[Note];
    long pulses=noteDuration*1000/pulselength;
    if (pulselength>100000)
    {
      delay(noteDuration);
    }
    else
    {
      for(int p=0;p<pulses;p++)
      {
        digitalWrite(Speakerpin,HIGH);
        delayMicroseconds(pulselength/2);
        digitalWrite(Speakerpin,LOW);
        delayMicroseconds(pulselength/2);
      }
      int pauseBetweenNotes = noteDuration * 0.30;
      delay(pauseBetweenNotes);
    }
  }
}

void loop(){
  Drive();
  //Walk();
  //Stop();
  //delay(500);
  //Kick();
  //delay(500);
  //Forward();
  //square();
  //while(1){}
}

void Walk()
{//------------------------------------------ Walking Routine -------------------------------------------

  Rkp=Rkp+flift;                                             // lift right toe so it does not have traction
  for (i=stride;i>-stride;i-=4)
  {
    j=i-4;
    Servopos();
    delay(stepTime);
    //if(pulseIn(IRXpin, LOW,time) >2000) IRcommand();         // start bit is greater than 2100uS
  }
  //Rkp=Rkp-flift;
  Rkp=Rkc;
  delay(stepTime);
  //if(pulseIn(IRXpin, LOW,time) >2000) IRcommand();           // start bit is greater than 2100uS

  Lkp=Lkp-flift+10;                                             // lift left toe so it does not have traction
  for (i=-stride;i<stride;i+=4)
  {
    j=i+4;
    Servopos();
    delay(stepTime);
    //if(pulseIn(IRXpin, LOW,time) >2000) IRcommand();         // start bit is greater than 2100uS
  }
  //Lkp=Lkp+flift-10;
  Lkp=Lkc;
  delay(stepTime);
  //if(pulseIn(IRXpin, LOW,time) >2000) IRcommand();           // start bit is greater than 2100uS
}

void Servopos()                                            // move all servos to new positions
{
  if (Lstop && !Rstop)
  {
    Lknee.writeMicroseconds(Lkp+i/2);
    Lhip.writeMicroseconds(Lhp+j/2);
  } else {  
    Lknee.writeMicroseconds(Lkp+i);
    Lhip.writeMicroseconds(Lhp+j);
  }
  if (Rstop && !Lstop)
  {
    Rknee.writeMicroseconds(Rkp+50+i/2); //+50
    Rhip.writeMicroseconds(Rhp-30+j/2); //-30
  } else {
    Rknee.writeMicroseconds(Rkp+i+50); //+50
    Rhip.writeMicroseconds(Rhp+j-30); //-30
  }
}

void Forward(){
    Lstop=0;
    Rstop=0;
    flift=abs(flift);
}

void Backward(){
    Lstop=0;
    Rstop=0;
    flift=-abs(flift);
}

void Stop(){
    Lstop=1;
    Rstop=1;
    Servopos();
}

void Right(){                                                // turn / kick right
    Rstop=1;
    Lstop=0;
    flift=abs(flift);
}

void Left(){                                                // turn / kick left
    Lstop=1;
    Rstop=0;
    flift=abs(flift);
}

int Read_Sharp_Eye() {
  int value = 0;
  value = analogRead(SharpEyepin);
  return 5*1384.4*pow(value,-.9988); //I had to multiply by 5, different sensor
}


void Store()
{
  EEPROM.write(0,highByte(Lkc));
  EEPROM.write(1,lowByte(Lkc));

  EEPROM.write(2,highByte(Rkc));
  EEPROM.write(3,lowByte(Rkc));

  EEPROM.write(4,highByte(Lhc));
  EEPROM.write(5,lowByte(Lhc));

  EEPROM.write(6,highByte(Rhc));
  EEPROM.write(7,lowByte(Rhc));
  /*
  Serial.print("   Left Knee: ");
   Serial.print(Lkc);
   Serial.print("   Right Knee: ");
   Serial.print(Rkc);
   Serial.print("   Left Hip: ");
   Serial.print(Lhc);
   Serial.print("   Right Hip: ");
   Serial.println(Rhc);
   */
}






