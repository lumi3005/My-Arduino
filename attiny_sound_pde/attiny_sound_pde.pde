
/*
 * AtTiny tutorial: sound
 *
 * Use a AtTiny to produce simple musical notes
 * For a chart of the frequencies of different notes see:
 * http://www.phy.mtu.edu/~suits/notefreqs.html
 */
 
int ledPin = 0;	// LED is connected to digital pin 0
int speakerPin = 1;	// speaker connected to digital pin 1
 	 
void setup()	 
{	 
         pinMode(ledPin, OUTPUT);	// sets the ledPin to be an output
         pinMode(speakerPin, OUTPUT);	// sets the speakerPin to be an output
}	 
 	 
void loop()	// run over and over again
{	 
          scale();	// call the scale() function
          delay(1000);	// delay for 1 second          
}	 
 	 
void beep (unsigned char speakerPin, int frequencyInHertz, long timeInMilliseconds)     // the sound producing function
{	 
          int x;	 
          long delayAmount = (long)(1000000/frequencyInHertz);
          long loopTime = (long)((timeInMilliseconds*1000)/(delayAmount*2));
          for (x=0;x<loopTime;x++)	 
          {	 
              digitalWrite(speakerPin,HIGH);
              delayMicroseconds(delayAmount);
              digitalWrite(speakerPin,LOW);
              delayMicroseconds(delayAmount);
          }	 
}	 
 	 
void scale ()
{	 
          digitalWrite(ledPin,HIGH);	//turn on the LED
          beep(speakerPin,4978,50);	//C: play the note C (C7 from the chart linked to above) for 500ms
          beep(speakerPin,4978*2,50);	//D
          beep(speakerPin,4978*3,50);	//C: play the note C (C7 from the chart linked to above) for 500ms
          beep(speakerPin,4978*4,50);	//D
          beep(speakerPin,4978*5,50);	//C: play the note C (C7 from the chart linked to above) for 500ms
          beep(speakerPin,4978*6,50);	//D
          beep(speakerPin,4978*7,50);	//C: play the note C (C7 from the chart linked to above) for 500ms
          beep(speakerPin,4978*8,50);	//D
          
          digitalWrite(ledPin,LOW);	//turn off the LED
}	 
