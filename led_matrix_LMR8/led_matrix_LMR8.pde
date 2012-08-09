//We always have to include the library
#include "LedControl.h"

LedControl lc=LedControl(0,1,2,1);
 
/* we always wait a bit between updates of the display */
unsigned long delaytime=250;
unsigned long delaytime2=20000;

void setup() {
  /*
   The MAX72XX is in power-saving mode on startup,
   we have to do a wakeup call
   */
  lc.shutdown(0,false);
  /* Set the brightness to a medium values */
  lc.setIntensity(0,1);
  /* and clear the display */
  lc.clearDisplay(0);
}
 
/*
 This method will display the characters for the
 word "Arduino" one after the other on the matrix. 
 (you need at least 5x7 leds to see the whole chars)
 */
void writeArduinoOnMatrix() {
  /* here is the data for the characters */

  byte x[8]={
    B00100100,B00100100,B00100100,B00000000,B10000001,B10000001,B01000010,B00111100  };
    
  lc.clearDisplay(0);
for (iint i=0;i<8;i++) {
   lc.setRow(0,i,x[i]);
}
  delay(delaytime);


}
void loop() { 
  lc.setIntensity(0,8);
  writeArduinoOnMatrix();
  delay(200);

  lc.clearDisplay(0);
}
 
 
 

 

 

 
 
 
 


 
