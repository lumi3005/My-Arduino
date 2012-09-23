#include "Arduino.h"

/**Analog Comparator Register**/
#define REG_DIDR _SFR_IO8(0x01)
#define BIT_DIDR_ANOD 0
#define BIT_DIDR_AN1D 1

//These pins are connected to the L293D motor controller
#define M_LF 2               // Motor Left Front
#define M_LB 3               // Motor Left Back
#define M_RF 5               // Motor Right Front
#define M_RB 4               // Motor Right Back
#define M_REn 7              // Motor Right ENABLE
#define M_LEn 11             // Motor Left ENABLE

// LED's for debugging
#define RxPin 0
#define TxPin 1
//////////////////////
void setup()
{
    /*disable digital input in order to reduce power consumption */
    bitWrite(REG_DIDR, BIT_DIDR_ANOD, 1);
    bitWrite(REG_DIDR, BIT_DIDR_AN1D, 1);
    
    // set pin for LED's
    pinMode(RxPin, OUTPUT);
    pinMode(TxPin, OUTPUT);
    digitalWrite(TxPin, LOW);
    digitalWrite(RxPin, LOW);
    // motor pin setup
    pinMode(M_LF, OUTPUT);
    pinMode(M_LB, OUTPUT);
    pinMode(M_RF, OUTPUT);
    pinMode(M_RB, OUTPUT);
    
    #ifndef PWM
    // just testing no PWM, L293 always enabled!
    pinMode(M_REn, OUTPUT);
    pinMode(M_LEn, OUTPUT);
    digitalWrite(M_REn, HIGH);    // Low is disabled
    digitalWrite(M_LEn, HIGH);    // Low is disabled  
    #endif
    
    /*
      Starte pattern after switching the robot on. 
      Each step it 500ms to check if the motors and functions are working
      Turn left, wait turn right, backward, forward, stop
    */
    turnLeft();
    wait();
    turnRight();
    wait();
    backward();
    wait();
    forward();
    wait();
    stopNow();

}

#define DETECT_NUM 5

void loop()
{
    bool ComparatorOut;
    unsigned char i, Cnt;

    Cnt = 0;
    for ( i = 0; i < DETECT_NUM; ++i )
    {
        ComparatorOut = bitRead( ACSR, ACO );
        Cnt += ComparatorOut;
        //if the solution don't work out,  we should let the robot swing with a small angle.  The code is added here.
        delay(20);
    }

    if ( 0 == Cnt )
    {
        turnLeft();
        digitalWrite(TxPin, LOW);
        digitalWrite(RxPin, HIGH);
    }
    else if ( DETECT_NUM == Cnt )
    {
        turnRight();
        digitalWrite(TxPin, HIGH);
        digitalWrite(RxPin, LOW);
    }
    else
    {
        forward();
        digitalWrite(TxPin, HIGH);
        digitalWrite(RxPin, HIGH);
    }
}

// just a function for delay if we need it :)
void wait(){
delay(200);
}

// *** Below here are all the motor control functions ***
void stopNow(){
  digitalWrite(M_LB, LOW);
  digitalWrite(M_LF, LOW);
  digitalWrite(M_RB, LOW);
  digitalWrite(M_RF, LOW);
}

void forward(){
  digitalWrite(M_LB, LOW);
  digitalWrite(M_LF, HIGH);
  digitalWrite(M_RB, LOW);
  digitalWrite(M_RF, HIGH);
}

void backward(){
  digitalWrite(M_LF, LOW);
  digitalWrite(M_LB, HIGH);
  digitalWrite(M_RF, LOW);
  digitalWrite(M_RB, HIGH);
}

void turnLeft(){
  // Right wheel forwards
  digitalWrite(M_RB, LOW);
  digitalWrite(M_RF, HIGH);
  digitalWrite(M_LB, LOW);
  digitalWrite(M_LF, LOW);
}

void turnRight(){
  // Left wheel forwards
  digitalWrite(M_LB, LOW);
  digitalWrite(M_LF, HIGH); 
  digitalWrite(M_RB, LOW);
  digitalWrite(M_RF, LOW); 
}

