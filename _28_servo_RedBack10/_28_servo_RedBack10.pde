//#include <LiquidCrystal.h>
//#include <EEPROM.h>
#include <Servo.h>
#include "constants.h"
#include "IO_pins.h"


// define global variables

int lp=5;                  // left  pan  value (scanning)
int rp=5;                  // right pan  value (scanning)
int lt=-1;                 // left  tilt value (scanning)
int rt=+1;                 // right tilt value (scanning)

int Ldistance;             // average reading for left  eye
int Rdistance;             // average reading for right eye

int LLIRvalue;             // left  eye - left  IR reflected value
int LRIRvalue;             // left  eye - right IR reflected value
int LUIRvalue;             // left  eye - up    IR reflected value
int LDIRvalue;             // left  eye - down  IR reflected value

int RLIRvalue;             // right eye - left  IR reflected value
int RRIRvalue;             // right eye - right IR reflected value
int RUIRvalue;             // right eye - up    IR reflected value
int RDIRvalue;             // right eye - down  IR reflected value
 
int drumbeat;              // position in drum sequence
int stride=25;             // position in walking sequence 
int pos=0;                 // 0 = Sitting    28 = Standing    56 = Curled Up

int Lspeed;                // determines left  legs stride and direction (-4 to +4)
int Rspeed;                // determines right legs stride and direction (-4 to +4)
int Cspeed;                // determines crab walk  stride and direction (-4 to +4) 
int Aspeed;                // average speed used to adjust walkspeed

int OLspeed;               // Old left  speed value 
int ORspeed;               // Old right speed value 
int OCspeed;               // Old crab  speed value (straffing speed)
int lift;                  // amount to lift legs by when walking, drumming etc.

int patience=3000;         // The level of patience will depend on emotional factors: 1000 = aproximately 10sec.
int track=-500;            // track is a counter that determines how much stimulus the robot gets from tracking objects.

int walkspeed=25;          // number of milliseconds between walk sequence steps
int drumspeed=100;         // set the tempo of the drum sequence
unsigned long drumtime;    // timer used to control drum tempo
unsigned long walktime;    // timer used to control walking speed
unsigned long modetime;    // used to prevent the robot changing between walkmodes too quickly


// define servo center positions (Spider at rest)
int svc[84]={
  1000,1000,1000,1000,     // D26 thigh4, D27 thigh3, D28 thigh2, D29 thigh1
  1080,1100,1040,1000,     // D30 knee 4, D31 knee 3, D32 knee 2, D33 knee 1
  1650,1700,1430,1220,     // D34 hip  4, D35 hip  3, D36 hip  2, D37 hip  1
  1800,1460,1400,1250,     // D38 hip  8, D39 hip  7, D40 hip  6, D41 hip  5
  1770,1800,1870,1770,     // D42 knee 8, D43 knee 7, D44 knee 6, D45 knee 5
  2000,2000,2000,2000,     // D46 thigh8, D47 thigh7, D48 thigh6, D49 thigh5 
  0,   0,   0,   0,        // D50 Lpan  , D51 Ltilt , D52 Rpan  , D53 Rtilt

  // define servo center positions (Spider standing)
  1500,1480,1500,1520,     // D26 thigh4, D27 thigh3, D28 thigh2, D29 thigh1
  1050,1050,1050,1050,     // D30 knee 4, D31 knee 3, D32 knee 2, D33 knee 1
  1650,1700,1430,1220,     // D34 hip  4, D35 hip  3, D36 hip  2, D37 hip  1
  1800,1460,1400,1250,     // D38 hip  8, D39 hip  7, D40 hip  6, D41 hip  5
  1900,1900,1900,1750,     // D42 knee 8, D43 knee 7, D44 knee 6, D45 knee 5
  1500,1500,1500,1450,     // D46 thigh8, D47 thigh7, D48 thigh6, D49 thigh5
  0,   0,   0,   0,        // D50 Lpan  , D51 Ltilt , D52 Rpan  , D53 Rtilt

  // define servo center positions (Spider curled up)
  650, 650, 650, 650,      // D26 thigh4, D27 thigh3, D28 thigh2, D29 thigh1
  730, 730, 690, 650,      // D30 knee 4, D31 knee 3, D32 knee 2, D33 knee 1
  1650,1700,1430,1220,     // D34 hip  4, D35 hip  3, D36 hip  2, D37 hip  1
  1800,1460,1400,1250,     // D38 hip  8, D39 hip  7, D40 hip  6, D41 hip  5
  2300,2270,2330,2270,     // D42 knee 8, D43 knee 7, D44 knee 6, D45 knee 5
  2500,2450,2400,2400,     // D46 thigh8, D47 thigh7, D48 thigh6, D49 thigh5 
  2100,2000,2100,2000      // D50 Lpan  , D51 Ltilt , D52 Rpan  , D53 Rtilt
};

int svt[28];               // storage of temporary servo calculations used to control speed and direction of servos

int svp[28];               // actual servo positions

//----------------------------------------------------------- define servos ---------------------------------------------------------

Servo sv[28];                                              // Yes! servos can be an array

void setup()
{
  for(int i=0;i<28;i++)                                    // copy center positions into servo position array
  {
    svp[i]=svc[i];
    if (svp[i]==0) svp[i]=1500;     
  }

  delay(1000);
  pinMode(12,OUTPUT);                                      // pin 12 used to turn on/off servo power
  digitalWrite(12,1);                                      // power up servos - servos remain dead until they are initialized and receive a signal

  //--------------------------------------------------------- Servos initialized in a sequence to prevent the legs becoming tangled ---

  sv[24].attach(50,Lpanmin,Lpanmax);                       // initialize left eye pan servo
  sv[24].writeMicroseconds(Lpanc);
  sv[25].attach(51,Ltiltmin,Ltiltmax);                     // initialize left eye tilt servo
  sv[25].writeMicroseconds(Ltiltc);
  sv[26].attach(52,Rpanmin,Rpanmax);                       // initialize right eye pan servo
  sv[26].writeMicroseconds(Rpanc);
  sv[27].attach(53,Rtiltmin,Rtiltmax);                     // initialize right eye tilt servo
  sv[27].writeMicroseconds(Rtiltc);


  for(int i=0;i<4;i++)                                     // initialize left thighs
  {
    sv[i].attach(26+i,700,2300); 
    sv[i].writeMicroseconds(svc[i]);
    delay(50);
  }

  for(int i=20;i<24;i++)                                   // initialize right thighs
  {
    sv[i].attach(26+i,700,2300); 
    sv[i].writeMicroseconds(svc[i]);
    delay(50);
  }

  for(int i=8;i<16;i++)                                    // initialize all hips
  {
    sv[i].attach(26+i,700,2300); 
    sv[i].writeMicroseconds(svc[i]);
    delay(50);
  }

  for(int i=4;i<8;i++)                                     // initialize left knees
  {
    sv[i].attach(26+i,600,2500); 
    sv[i].writeMicroseconds(svc[i]);
    delay(50);
  }

  for(int i=16;i<20;i++)                                   // initialize right knees
  {
    sv[i].attach(26+i,600,2500); 
    sv[i].writeMicroseconds(svc[i]);
    delay(50);
  }

  delay(1000);
  if (pos>0) SitStand();                                   // once initialized, the spider is in a sitting position

  //Serial.begin(57600);
  walktime=millis();
  delay(1000);
}



void loop()
{
  IReyes();                                                // read information from eyes
  IRfollow();                                              // pan/tilt eyes to track objects
  
  if (Ldistance>tooclose && Rdistance>tooclose)            // object too close, hide!
  {
    walkspeed=25;
    HideEyes();
    delay(1000);
    Peek();                                                // look to see if it is safe
    track=patience;                                        // not bored - reset counter
  }

  track-=1;
  if(track>patience) track=patience;
  if(track<-patience/2) track=-patience/2;
  if(track<0)//---------------------------------------------- the robot is bored -----------------------------------------------------------------
  {
    if(pos==28)                                            // if the robot is standing then sit down slowly
    {
      pos=0;
      walkspeed=50;
      lp=1;                                                // set left eye scan to lazy
      rp=1;                                                // set right eye scan to lazy
      SitStand();
    }
    if ((millis()-drumtime)>drumspeed)                     // control the tempo of the drumbeat
    {
      drumtime=millis();
      Drum();                                              // drumbeat sequence
    }
  }

  if (track>100)//------------------------------------------- robot is not bored ------------------------------------------------------------------
  {
    if (pos!=28)                                           // get back on feet if required
    {
      pos=28;
      walkspeed=25;
      lp=5;                                                // reset left eye scan to active
      rp=5;                                                // reset right eye scan to active
      SitStand();
    }
    FollowObject();
  }
}

void Drum()//=============================================== Drum feet on floor when bored =====================================================
{
  int lift=200;
  int thump=200;
  drumbeat++;
  if(drumbeat>31) drumbeat=0;
  switch(drumbeat)
  {
    case(0):                                              // raise knee1
    svp[7]=svc[7]+lift;
    break;

    case(1):                                              // lower knee1 hard
    svp[7]=svc[7]-thump;
    break;

    case(2):
    svp[7]=svc[7];                                        // reset knee1 
    svp[6]=svc[6]+lift;                                   // raise knee2
    break;

    case(3):
    svp[6]=svc[6]-thump;                                  // lower knee2 hard
    break;

    case(4):
    svp[6]=svc[6];                                        // reset knee2
    svp[5]=svc[5]+lift;                                   // raise knee3
    break;

    case(5):
    svp[5]=svc[5]-thump;                                  // lower knee3 hard
    break;

    case(6):
    svp[5]=svc[5];                                        // reset knee3
    break;

    case(8):
    svp[16]=svc[16]-lift;                                 // raise knee8
    break;

    case(9):
    svp[16]=svc[16]+thump;                                // lower knee8 hard
    break;

    case(10):
    svp[16]=svc[16];                                      // reset knee8
    svp[17]=svc[17]-lift;                                 // raise knee7
    break;

    case(11):
    svp[17]=svc[17]+thump;                                // lower knee7 hard
    break;

    case(12):
    svp[17]=svc[17];                                      // reset knee7
    svp[18]=svc[18]-lift;                                 // raise knee6
    break;

    case(13):
    svp[18]=svc[18]+thump;                                // lower knee6 hard
    break;

    case(14):
    svp[18]=svc[18];                                      // reset knee6

    case(16):                                             // raise knee1
    svp[7]=svc[7]+lift;
    break;

    case(17):                                             // lower knee1 hard
    svp[7]=svc[7]-thump;
    break;

    case(18):
    svp[7]=svc[7];                                        // reset knee1 
    svp[6]=svc[6]+lift;                                   // raise knee2
    break;

    case(19):
    svp[6]=svc[6]-thump;                                  // lower knee2 hard
    break;

    case(20):
    svp[6]=svc[6];                                        // reset knee2
    svp[5]=svc[5]+lift;                                   // raise knee3
    break;

    case(21):
    svp[5]=svc[5]-thump;                                  // lower knee3 hard
    break;

    case(22):
    svp[5]=svc[5];                                        // reset knee3
    break;

    case(24):
    svp[16]=svc[16]-lift;                                 // raise knee8
    svp[18]=svc[18]-lift;                                 // raise knee6
    break;

    case(25):
    svp[16]=svc[16]+thump;                                // lower knee8 hard
    svp[18]=svc[18]+thump;                                // lower knee6 hard
    break;

    case(26):
    svp[16]=svc[16];                                      // reset knee8
    svp[18]=svc[18];                                      // reset knee6
    break;

    case(28):
    svp[17]=svc[17]-lift;                                 // raise knee7
    svp[19]=svc[19]-lift;                                 // raise knee5
    break;

    case(29):
    svp[17]=svc[17]+thump;                                // lower knee7 hard
    svp[19]=svc[19]+thump;                                // lower knee5 hard
    break;

    case(30):
    svp[17]=svc[17];                                      // reset knee7
    svp[19]=svc[19];                                      // reset knee5
    break;
  }
  ServoUpdate();
}


void FollowObject()//======================================== Simple object following function ======================================================  
{
  Lspeed=(bestdistance-Ldistance)/20;
  if (Lspeed>4) Lspeed=4;
  if (Lspeed<-4) Lspeed=-4;

  Rspeed=(bestdistance-Rdistance)/20;
  if (Rspeed>4) Rspeed=4;
  if (Rspeed<-4) Rspeed=-4;

  Cspeed=0;
  if (svp[24]<1300 && svp[26]<1300 && Ldistance>maxdistance && Rdistance>maxdistance)
  {
    Lspeed=0;
    Rspeed=0;
    Cspeed=(Rdistance-Ldistance)/10;
    if (Cspeed>4) Cspeed=4;
    if (Cspeed<-4) Cspeed=-4;
  }

  if ((millis()-walktime)>walkspeed)
  {
    walktime=millis();
    if (Lspeed!=0 || Rspeed!=0 || Cspeed!=0) Walk1();
  }
}

void IReyes()//============================================== Read IR compound eyes ===============================================
{
  digitalWrite(LIRleds,HIGH);                              // turn on IR LEDs to read TOTAL IR LIGHT (ambient + reflected)
  delayMicroseconds(500);                                  // Allow time for phototransistors to respond.
  LLIRvalue=analogRead(LIRleft);                           // TOTAL IR = AMBIENT IR + LED IR REFLECTED FROM OBJECT
  LRIRvalue=analogRead(LIRright);                          // TOTAL IR = AMBIENT IR + LED IR REFLECTED FROM OBJECT
  LUIRvalue=analogRead(LIRup);                             // TOTAL IR = AMBIENT IR + LED IR REFLECTED FROM OBJECT
  LDIRvalue=analogRead(LIRdown);                           // TOTAL IR = AMBIENT IR + LED IR REFLECTED FROM OBJECT

  digitalWrite(LIRleds,LOW);                               // turn off IR LEDs to read AMBIENT IR LIGHT (IR from indoor lighting and sunlight)
  delayMicroseconds(500);                                  // Allow time for phototransistors to respond.

  LLIRvalue=LLIRvalue-analogRead(LIRleft);                 // REFLECTED IR = TOTAL IR - AMBIENT IR
  LRIRvalue=LRIRvalue-analogRead(LIRright);                // REFLECTED IR = TOTAL IR - AMBIENT IR
  LUIRvalue=LUIRvalue-analogRead(LIRup);                   // REFLECTED IR = TOTAL IR - AMBIENT IR
  LDIRvalue=LDIRvalue-analogRead(LIRdown);                 // REFLECTED IR = TOTAL IR - AMBIENT IR
  Ldistance=(LLIRvalue+LRIRvalue+LUIRvalue+LDIRvalue)/4;   // distance of object is average of reflected IR

  digitalWrite(RIRleds,HIGH);                              // turn on IR LEDs to read TOTAL IR LIGHT (ambient + reflected)
  delayMicroseconds(500);                                  // Allow time for phototransistors to respond.
  RLIRvalue=analogRead(RIRleft);                           // TOTAL IR = AMBIENT IR + LED IR REFLECTED FROM OBJECT
  RRIRvalue=analogRead(RIRright);                          // TOTAL IR = AMBIENT IR + LED IR REFLECTED FROM OBJECT
  RUIRvalue=analogRead(RIRup);                             // TOTAL IR = AMBIENT IR + LED IR REFLECTED FROM OBJECT
  RDIRvalue=analogRead(RIRdown);                           // TOTAL IR = AMBIENT IR + LED IR REFLECTED FROM OBJECT

  digitalWrite(RIRleds,LOW);                               // turn off IR LEDs to read AMBIENT IR LIGHT (IR from indoor lighting and sunlight)
  delayMicroseconds(500);                                  // Allow time for phototransistors to respond.
  RLIRvalue=RLIRvalue-analogRead(RIRleft);                 // REFLECTED IR = TOTAL IR - AMBIENT IR
  RRIRvalue=RRIRvalue-analogRead(RIRright);                // REFLECTED IR = TOTAL IR - AMBIENT IR
  RUIRvalue=RUIRvalue-analogRead(RIRup);                   // REFLECTED IR = TOTAL IR - AMBIENT IR
  RDIRvalue=RDIRvalue-analogRead(RIRdown);                 // REFLECTED IR = TOTAL IR - AMBIENT IR
  Rdistance=(RLIRvalue+RRIRvalue+RUIRvalue+RDIRvalue)/4;   // distance of object is average of reflected IR

  /*
  Serial.print("  LLIRvalue: "); Serial.print(LLIRvalue);
   Serial.print("  LRIRvalue: "); Serial.print(LRIRvalue);
   Serial.print("  LUIRvalue: "); Serial.print(LUIRvalue);
   Serial.print("  LDIRvalue: "); Serial.print(LDIRvalue);
   
   Serial.print("  RLIRvalue: "); Serial.print(RLIRvalue);
   Serial.print("  RRIRvalue: "); Serial.print(RRIRvalue);
   Serial.print("  RUIRvalue: "); Serial.print(RUIRvalue);
   Serial.print("  RDIRvalue: "); Serial.println(RDIRvalue);
   */
  //Serial.print("Left distance: "); Serial.print(Ldistance);
  //Serial.print("  --  Right distance: "); Serial.println(Rdistance);
}


void LeyeScan()
{
  svp[24]+=lp;                                             // adjust left eye pan position
  if (svp[24]<Lpanmin || svp[24]>Lpanmax) lp*=-1;          // if servo tries to exceed limits then reverse direction
  svp[25]+=lt;                                             // adjust left eye pan position
  if (svp[25]<Ltiltmin || svp[25]>Ltiltmax) lt*=-1;        // if servo tries to exceed limits then reverse direction

  sv[24].writeMicroseconds(svp[24]);                       // update the servos position
  sv[25].writeMicroseconds(svp[25]);                       // update the servos position
}


void ReyeScan()
{
  svp[26]+=rp;                                             // adjust right eye pan psition
  if (svp[26]<Rpanmin || svp[26]>Rpanmax) rp*=-1;          // if servo tries to exceed limits then reverse direction
  svp[27]+=rt;                                             // adjust right eye pan psition
  if (svp[27]<Rtiltmin || svp[27]>Rtiltmax) rt*=-1;        // if servo tries to exceed limits then reverse direction

  sv[26].writeMicroseconds(svp[26]);                       // update the servos position
  sv[27].writeMicroseconds(svp[27]);                       // update the servos position
}

void IRfollow()
{
  //========================================================= track object with left eye ============================================
  int panscale;           
  int tiltscale;
  int panadjust;
  int tiltadjust;

  if (Ldistance<maxdistance)                               // if no object in range of left eye
  {
    if(Rdistance<maxdistance)                              // if no object in range then scan left eye
    {
      LeyeScan();
    }
    else                                                   // if object in range of right eye then turn right
    {                          
      if (svp[24]>Lpanc+500)svp[24]-=5;                    // pan left eye to the right
      if (svp[24]<Lpanc+500)svp[24]+=5;                    // pan left eye to the right
      if (svp[25]>svp[27])svp[25]-=5;                      // match left tilt with right tilt
      if (svp[25]<svp[27])svp[25]+=5;                      // match left tilt with right tilt
    }
  }
  else
  {
    //------------------------------------------------------- Track object ------------------------------------------------
    panscale=(LLIRvalue+LRIRvalue)/panscalefactor;         // calculate panscale according to distance
    panadjust=(LLIRvalue-LRIRvalue)*5/panscale;            // calculate amount to adjust pan servo by
    svp[24]-=panadjust;

    if (panadjust>5) track+=panadjust;

    tiltscale=(LUIRvalue+LDIRvalue)/tiltscalefactor;       // calculate tiltscale according to distance  
    tiltadjust=(LUIRvalue-LDIRvalue)*5/tiltscale;          // calculate amount to adjust tilt servo by
    svp[25]-=tiltadjust;

    if (tiltadjust>5) track+=tiltadjust;

    if(svp[24]<Lpanmin) svp[24]=Lpanmin;                   // prevent servos exceeding limit
    if(svp[24]>Lpanmax) svp[24]=Lpanmax;
    if(svp[25]<Ltiltmin) svp[25]=Ltiltmin;
    if(svp[25]>Ltiltmax) svp[25]=Ltiltmax;
  }
  sv[24].writeMicroseconds(svp[24]);                       // update left eye pan/tilt servos
  sv[25].writeMicroseconds(svp[25]);

  //========================================================= track object with right eye ============================================

  if (Rdistance<maxdistance)                               // if no object in range of right eye
  {
    if (Ldistance<maxdistance)                             // if no object in range then scan right eye
    {
      ReyeScan();
    }
    else                                                   // if object in range of Left eye then turn left
    {
      if (svp[26]>Rpanc+500)svp[26]-=5;
      if (svp[26]<Rpanc+500)svp[26]+=5;
      if (svp[27]>svp[25])svp[27]-=5;
      if (svp[27]<svp[25])svp[27]+=5;
    }
  }
  else
  {
    //------------------------------------------------------- Track object ------------------------------------------------
    panscale=(RLIRvalue+RRIRvalue)/panscalefactor;      
    panadjust=(RLIRvalue-RRIRvalue)*5/panscale;
    svp[26]-=panadjust;

    if (panadjust>5) track+=panadjust;

    tiltscale=(RUIRvalue+RDIRvalue)/tiltscalefactor;      
    tiltadjust=(RUIRvalue-RDIRvalue)*5/tiltscale;
    svp[27]-=tiltadjust;

    if (tiltadjust>5) track+=tiltadjust;

    if(svp[26]<Rpanmin) svp[26]=Rpanmin;
    if(svp[26]>Rpanmax) svp[26]=Rpanmax;
    if(svp[27]<Ltiltmin) svp[27]=Rtiltmin;
    if(svp[27]>Ltiltmax) svp[27]=Rtiltmax;
  } 
  sv[26].writeMicroseconds(svp[26]);
  sv[27].writeMicroseconds(svp[27]);
}


//=========================================================== Brings the robot to a predefined position =============================

void SitStand()                                               
{
  for(int i=0;i<28;i++)                                    // scan through servo positions
  {
    svt[i]=(svc[i+pos]-svp[i])/20;                         // calculate speed and direction required to move the servo to sitting/standing position in 20 steps
    if(svc[i+pos]==0) svt[i]=0;                            // a 0 indicates do not change servo position

  }
  for(int j=0;j<20;j++)                                    // move servos over a period of 20 steps to generate a smooth motion
  {
    for(int i=0;i<28;i++)
    {
      svp[i]+=svt[i];                                      // adjust the servos position
      sv[i].writeMicroseconds(svp[i]);                     // update the servos position
    }
    delay(walkspeed);                                      // controls speed of motion
  }
}


//=========================================================== Hide eyes when scared =================================================

void HideEyes()
{
  if(pos!=56)                                              // Move into curled up position
  {
    pos=56;
    SitStand();
  }

  for(int i=0;i<20;i++)
  {
    svp[11]-=23;                                           // adjust hip1
    svp[12]+=27;                                           // adjust hip8
    svp[3]+=12;                                            // adjust thigh1
    svp[20]-=11;                                           // adjust thigh8
    svp[7]+=68;                                            // adjust knee 1
    svp[16]-=67;                                           // adjust knee 8

    sv[11].writeMicroseconds(svp[11]);                     // update the servos position
    sv[12].writeMicroseconds(svp[12]);                     // update the servos position
    sv[3].writeMicroseconds(svp[3]);                       // update the servos position
    sv[20].writeMicroseconds(svp[20]);                     // update the servos position
    sv[7].writeMicroseconds(svp[7]);                       // update the servos position
    sv[16].writeMicroseconds(svp[16]);                     // update the servos position
    delay(15);
  }
}


//=========================================================== Peek to see if it is safe =============================================

void Peek()
{
  do
  {
    for(int i=0;i<20;i++)                                  // look up to see if it is safe
    {
      svp[11]+=30;                                         // swivel hip1 to uncover left eye
      svp[12]-=30;                                         // swivel hip8 to uncover right eye
      svp[3]+=10;                                          // adjust thigh1
      svp[20]-=10;                                         // adjust thigh8
      svp[25]-=30;                                         // raise left eye
      svp[27]-=30;                                         // raise right eye
      sv[11].writeMicroseconds(svp[11]);                   // update the servos position
      sv[12].writeMicroseconds(svp[12]);                   // update the servos position
      sv[3].writeMicroseconds(svp[3]);                     // update the servos position
      sv[20].writeMicroseconds(svp[20]);                   // update the servos position
      sv[25].writeMicroseconds(svp[25]);                   // update the servos position
      sv[27].writeMicroseconds(svp[27]);                   // update the servos position
      delay(30);
    }

    IReyes();                                              // Look!!
    if (Ldistance<bestdistance && Rdistance<bestdistance)  // seems clear, look around
    {
      randomSeed(analogRead(0));
      lp=(random(25)-12)*2;                                // random pan speed and direction for left eye
      randomSeed(analogRead(1));
      rp=(random(25)-12)*2;                                // random pan speed and direction for right eye
      randomSeed(analogRead(0));
      lt=(random(25)-12)*2;                                // random tilt speed and direction for left eye
      randomSeed(analogRead(1));
      rt=(random(25)-12)*2;                                // random tilt speed and direction for right eye

      for (int j=0;j<150;j++)                              // scan about looking for trouble
      {
        LeyeScan();
        ReyeScan();
        delay(20);
        IReyes();
        if (Ldistance>bestdistance || Rdistance>bestdistance)// something there!!
        {
          svp[24]=2100;                                    // return left  eye pan  directly to center
          svp[26]=2100;                                    // return right eye pan  directly to center
          svp[25]=2000;                                    // return left  eye tilt directly to center
          svp[27]=2000;                                    // return right eye tilt directly to center

          sv[24].writeMicroseconds(svp[24]);               // update the servos position
          sv[26].writeMicroseconds(svp[26]);               // update the servos position
          sv[25].writeMicroseconds(svp[25]);               // update the servos position
          sv[27].writeMicroseconds(svp[27]);               // update the servos position
          delay(40);
          break;                                           // break out of loop
        } 
      }
    }
    if (Ldistance<bestdistance && Rdistance<bestdistance) 
    {
      lp=lp/(abs(lp))*5;
      rp=rp/(abs(rp))*5;
      lt=lt/(abs(lt))*1;
      rt=rt/(abs(rt))*1;
      break; 
    }

    for(int i=0;i<20;i++)                                  // hide eyes until left alone
    {
      svp[11]-=30;                                         // swivel hip1 to hide left eye
      svp[12]+=30;                                         // swivel hip8 to hide right eye
      svp[3]-=10;                                          // adjust thigh1
      svp[20]+=10;                                         // adjust thigh8
      svp[25]+=30;                                         // lower left eye
      svp[27]+=30;                                         // lower right eye
      sv[11].writeMicroseconds(svp[11]);                   // update the servos position
      sv[12].writeMicroseconds(svp[12]);                   // update the servos position
      sv[3].writeMicroseconds(svp[3]);                     // update the servos position
      sv[20].writeMicroseconds(svp[20]);                   // update the servos position
      sv[25].writeMicroseconds(svp[25]);                   // update the servos position
      sv[27].writeMicroseconds(svp[27]);                   // update the servos position
      delay(15);
    }
    delay(2500);                                           // wait longer if someone still there
  }
  while(1==1);
}


//=========================================================== Update leg servo positions ============================================

void ServoUpdate()
{
  for(int i=0;i<24;i++)                                    // update leg servo positions
  {
    sv[i].writeMicroseconds(svp[i]);
  }
}

//=========================================================== Cycle through 4 legged walk sequence ==================================
void Walk1()
{
  lift=-500;
  stride++;                                                // cycle through gait sequence
  if (stride>23)
  {
    stride=0;                                              // restart stride sequence
    if (OLspeed>Lspeed) OLspeed--;                         // limit rate of Lspeed change to prevent leg tanglement 
    if (OLspeed<Lspeed) OLspeed++;
    if (ORspeed>Rspeed) ORspeed--;                         // limit rate of Rspeed change to prevent leg tanglement 
    if (ORspeed<Rspeed) ORspeed++;
    if (OCspeed>Cspeed) OCspeed--;                         // limit rate of Cspeed change to prevent leg tanglement 
    if (OCspeed<Cspeed) OCspeed++;
  }

  for(int i=0;i<4;i++)                                     // keep knees and hips moving
  {
    svp[i+4]-=OCspeed*4;                                   // move left  knees allowing for speed and direction
    svp[i+16]-=OCspeed*4;                                  // move right knees allowing for speed and direction
    svp[i+8]+=OLspeed*4;                                   // move left  hips allowing for speed and direction
    svp[i+12]-=ORspeed*4;                                  // move right hips allowing for speed and direction
  }

  switch(stride)
  {
  case 0:
    svp[3]=svc[3+pos]+lift;                                // lift leg1
    svp[1]=svc[1+pos]+lift;                                // lift leg3
    svp[23]=svc[23+pos]-lift;                              // lift leg5
    svp[21]=svc[21+pos]-lift;                              // lift leg7
    break;

  case 1:
    svp[11]=svc[11+pos]-(OLspeed*48);                      // move leg1 forward
    svp[9]=svc[9+pos]-(OLspeed*48);                        // move leg3 forward
    svp[15]=svc[15+pos]+(ORspeed*48);                      // move leg5 forward
    svp[13]=svc[13+pos]+(ORspeed*48);                      // move leg7 forward

    svp[7]=svc[7+pos]+(OCspeed*48);                        // extend/retract knee1
    svp[5]=svc[5+pos]+(OCspeed*48);                        // extend/retract knee3
    svp[19]=svc[19+pos]+(OCspeed*48);                      // extend/retract knee5
    svp[17]=svc[17+pos]+(OCspeed*48);                      // extend/retract knee7
    break;

  case 6:
    svp[3]=svc[3+pos];                                     // lower leg1
    svp[1]=svc[1+pos];                                     // lower leg3
    svp[23]=svc[23+pos];                                   // lower leg5
    svp[21]=svc[21+pos];                                   // lower leg7
    break;

  case 12:
    svp[2]=svc[2+pos]+lift;                                // lift leg2
    svp[0]=svc[0+pos]+lift;                                // lift leg4
    svp[22]=svc[22+pos]-lift;                              // lift leg6
    svp[20]=svc[20+pos]-lift;                              // lift leg8
    break;

  case 13:
    if (OLspeed>Lspeed) OLspeed--;                         // limit rate of Lspeed change to prevent leg tanglement 
    if (OLspeed<Lspeed) OLspeed++;
    if (ORspeed>Rspeed) ORspeed--;                         // limit rate of Rspeed change to prevent leg tanglement 
    if (ORspeed<Rspeed) ORspeed++;
    if (OCspeed>Cspeed) OCspeed--;                         // limit rate of Cspeed change to prevent leg tanglement 
    if (OCspeed<Cspeed) OCspeed++;

    svp[10]=svc[10+pos]-(OLspeed*48);                      // move leg2 forward
    svp[8]=svc[8+pos]-(OLspeed*48);                        // move leg4 forward
    svp[14]=svc[14+pos]+(ORspeed*48);                      // move leg6 forward
    svp[12]=svc[12+pos]+(ORspeed*48);                      // move leg8 forward

    svp[6]=svc[6+pos]+(OCspeed*48);                        // extend/retract knee2
    svp[4]=svc[4+pos]+(OCspeed*48);                        // extend/retract knee4
    svp[18]=svc[18+pos]+(OCspeed*48);                      // extend/retract knee6
    svp[16]=svc[16+pos]+(OCspeed*48);                      // extend/retract knee8
    break;

  case 18:
    svp[2]=svc[2+pos];                                     // lower leg2
    svp[0]=svc[0+pos];                                     // lower leg4
    svp[22]=svc[22+pos];                                   // lower leg6
    svp[20]=svc[20+pos];                                   // lower leg8
    break;
  }
  ServoUpdate();
}























