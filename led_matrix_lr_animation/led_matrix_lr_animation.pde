//We always have to include the library
#include "LedControl.h"

LedControl lc=LedControl(0,1,2,1);
 
/* we always wait a bit between updates of the display */
unsigned long delaytime=100;
unsigned long delaytime2=10000;

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

/* smiley face */
  byte a[8]={
    B00100100,B00100100,B00100100,B00000000,B10000001,B10000001,B01000010,B00111100  };
/* smiley face animation left turn */    
  byte b[8]={
    B01001000,B01001000,B01001000,B00000000,B00000010,B00000010,B10000100,B01111000  };  
  byte c[8]={
    B10010000,B10010000,B10010000,B00000000,B00000100,B00000100,B00001000,B11110000  };  
  byte d[8]={
    B00100000,B00100000,B00100000,B00000000,B00001000,B00001000,B00010000,B11100000  };  
  byte e[8]={
    B01000000,B01000000,B01000000,B00000000,B00010000,B00010000,B00100000,B11000000  };  
/* smiley face animation right turn */      
  byte f[8]={
    B00010010,B00010010,B00010010,B00000000,B01000000,B01000000,B00100001,B00011110  };  
  byte g[8]={
    B00001001,B00001001,B00001001,B00000000,B00100000,B00100000,B00010000,B00001111  };  
  byte h[8]={
    B00000100,B00000100,B00000100,B00000000,B00010000,B00010000,B00001000,B00000111  };  
  byte i[8]={
    B00000010,B00000010,B00000010,B00000000,B00001000,B00001000,B00000100,B00000011  };  
    
    
  lc.setRow(0,0,a[0]);
  lc.setRow(0,1,a[1]);
  lc.setRow(0,2,a[2]);
  lc.setRow(0,3,a[3]);
  lc.setRow(0,4,a[4]);
  lc.setRow(0,5,a[5]);
  lc.setRow(0,6,a[6]);  
  lc.setRow(0,7,a[7]);  
  delay(delaytime2);
  lc.setRow(0,0,b[0]);
  lc.setRow(0,1,b[1]);
  lc.setRow(0,2,b[2]);
  lc.setRow(0,3,b[3]);
  lc.setRow(0,4,b[4]);
  lc.setRow(0,5,b[5]);
  lc.setRow(0,6,b[6]); 
  lc.setRow(0,7,b[7]); 
  delay(delaytime);
  lc.setRow(0,0,c[0]);
  lc.setRow(0,1,c[1]);
  lc.setRow(0,2,c[2]);
  lc.setRow(0,3,c[3]);
  lc.setRow(0,4,c[4]);
  lc.setRow(0,5,c[5]);
  lc.setRow(0,6,c[6]);  
  lc.setRow(0,7,c[7]); 
  delay(delaytime);
  lc.setRow(0,0,d[0]);
  lc.setRow(0,1,d[1]);
  lc.setRow(0,2,d[2]);
  lc.setRow(0,3,d[3]);
  lc.setRow(0,4,d[4]);
  lc.setRow(0,5,d[5]);
  lc.setRow(0,6,d[6]);  
  lc.setRow(0,7,d[7]); 
  delay(delaytime);
  lc.setRow(0,0,e[0]);
  lc.setRow(0,1,e[1]);
  lc.setRow(0,2,e[2]);
  lc.setRow(0,3,e[3]);
  lc.setRow(0,4,e[4]);
  lc.setRow(0,5,e[5]);
  lc.setRow(0,6,e[6]);  
  lc.setRow(0,7,e[7]); 
  delay(delaytime);
  lc.setRow(0,0,d[0]);
  lc.setRow(0,1,d[1]);
  lc.setRow(0,2,d[2]);
  lc.setRow(0,3,d[3]);
  lc.setRow(0,4,d[4]);
  lc.setRow(0,5,d[5]);
  lc.setRow(0,6,d[6]);  
  lc.setRow(0,7,d[7]); 
  delay(delaytime);
  lc.setRow(0,0,c[0]);
  lc.setRow(0,1,c[1]);
  lc.setRow(0,2,c[2]);
  lc.setRow(0,3,c[3]);
  lc.setRow(0,4,c[4]);
  lc.setRow(0,5,c[5]);
  lc.setRow(0,6,c[6]);  
  lc.setRow(0,7,c[7]); 
  delay(delaytime);
  lc.setRow(0,0,b[0]);
  lc.setRow(0,1,b[1]);
  lc.setRow(0,2,b[2]);
  lc.setRow(0,3,b[3]);
  lc.setRow(0,4,b[4]);
  lc.setRow(0,5,b[5]);
  lc.setRow(0,6,b[6]); 
  lc.setRow(0,7,b[7]); 
  delay(delaytime);
  lc.setRow(0,0,a[0]);
  lc.setRow(0,1,a[1]);
  lc.setRow(0,2,a[2]);
  lc.setRow(0,3,a[3]);
  lc.setRow(0,4,a[4]);
  lc.setRow(0,5,a[5]);
  lc.setRow(0,6,a[6]);  
  lc.setRow(0,7,a[7]);  
  delay(delaytime2);
  lc.setRow(0,0,a[0]);
  lc.setRow(0,1,a[1]);
  lc.setRow(0,2,a[2]);
  lc.setRow(0,3,a[3]);
  lc.setRow(0,4,a[4]);
  lc.setRow(0,5,a[5]);
  lc.setRow(0,6,a[6]);  
  lc.setRow(0,7,a[7]);  
  delay(delaytime2);
  lc.setRow(0,0,f[0]);
  lc.setRow(0,1,f[1]);
  lc.setRow(0,2,f[2]);
  lc.setRow(0,3,f[3]);
  lc.setRow(0,4,f[4]);
  lc.setRow(0,5,f[5]);
  lc.setRow(0,6,f[6]);  
  lc.setRow(0,7,f[7]); 
  delay(delaytime);
  lc.setRow(0,0,g[0]);
  lc.setRow(0,1,g[1]);
  lc.setRow(0,2,g[2]);
  lc.setRow(0,3,g[3]);
  lc.setRow(0,4,g[4]);
  lc.setRow(0,5,g[5]);
  lc.setRow(0,6,g[6]);  
  lc.setRow(0,7,g[7]); 
  delay(delaytime);
  lc.setRow(0,0,h[0]);
  lc.setRow(0,1,h[1]);
  lc.setRow(0,2,h[2]);
  lc.setRow(0,3,h[3]);
  lc.setRow(0,4,h[4]);
  lc.setRow(0,5,h[5]);
  lc.setRow(0,6,h[6]);  
  lc.setRow(0,7,h[7]); 
  delay(delaytime);
  lc.setRow(0,0,i[0]);
  lc.setRow(0,1,i[1]);
  lc.setRow(0,2,i[2]);
  lc.setRow(0,3,i[3]);
  lc.setRow(0,4,i[4]);
  lc.setRow(0,5,i[5]);
  lc.setRow(0,6,i[6]);  
  lc.setRow(0,7,i[7]); 
  delay(delaytime);
  lc.setRow(0,0,h[0]);
  lc.setRow(0,1,h[1]);
  lc.setRow(0,2,h[2]);
  lc.setRow(0,3,h[3]);
  lc.setRow(0,4,h[4]);
  lc.setRow(0,5,h[5]);
  lc.setRow(0,6,h[6]);  
  lc.setRow(0,7,h[7]); 
  delay(delaytime);
  lc.setRow(0,0,g[0]);
  lc.setRow(0,1,g[1]);
  lc.setRow(0,2,g[2]);
  lc.setRow(0,3,g[3]);
  lc.setRow(0,4,g[4]);
  lc.setRow(0,5,g[5]);
  lc.setRow(0,6,g[6]);  
  lc.setRow(0,7,g[7]); 
  delay(delaytime);
  lc.setRow(0,0,f[0]);
  lc.setRow(0,1,f[1]);
  lc.setRow(0,2,f[2]);
  lc.setRow(0,3,f[3]);
  lc.setRow(0,4,f[4]);
  lc.setRow(0,5,f[5]);
  lc.setRow(0,6,f[6]); 
  lc.setRow(0,7,f[7]); 
  delay(delaytime);
  lc.setRow(0,0,a[0]);
  lc.setRow(0,1,a[1]);
  lc.setRow(0,2,a[2]);
  lc.setRow(0,3,a[3]);
  lc.setRow(0,4,a[4]);
  lc.setRow(0,5,a[5]);
  lc.setRow(0,6,a[6]);  
  lc.setRow(0,7,a[7]);  

}
void loop() { 
  lc.setIntensity(0,8);
  writeArduinoOnMatrix();
  delay(200);

//  lc.clearDisplay(0);
}
 
 
 

 

 

 
 
 
 


 
