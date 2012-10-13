 


// int Max_Dist=185; // Maximum distance to check against. This value was determined from sensor reading averages
// int Best_Dist=400; // Best distance to check against. This value was determined from sensor reading averages
//VAR pin selection
int sensorPin_Top = A1;    // select the Arduino input pin for the CompoundEye PCB IR pin 2
int sensorPin_Right = A4;    // select the Arduino input pin for the CompoundEye PCB IR pin 3
int sensorPin_Bottom = A3;    // select the Arduino input pin for the CompoundEye PCB IR pin 4
int sensorPin_Left = A2;    // select the Arduino input pin for the CompoundEye PCB IR pin 5
int ledPin = 13;      // select the Arduino output pin for turning on the compound eye PCB IR LED
//VAR sensorvalues
int sensorValue_Top = 0;  // variable to store the value coming from the Compound Eye sensor(Top)
int sensorValue_Right = 0;  // variable to store the value coming from the Compound Eye sensor(Right)
int sensorValue_Bottom = 0;  // variable to store the value coming from the Compound Eye sensor(Bottom)
int sensorValue_Left = 0;  // variable to store the value coming from the Compound Eye sensor(Left)
int sensorValue_Average = 0;

void setup() {
  Serial.begin(9600);
  
  pinMode(ledPin, OUTPUT);    // declare the ledPin as an OUTPUT:
  digitalWrite(ledPin, HIGH);   // turn the ledPin on
  
  pinMode(2, OUTPUT);    // declare the Pin 2 as an OUTPUT for enable pin 
  digitalWrite(2, HIGH);   // turn Pin 2 on

}

void loop() {
  // read the value from the sensor and determine if the object is in range if not return the Pan/Tilt servos to the center:
  sensorValue_Top = analogRead(sensorPin_Top);    
  sensorValue_Right = analogRead(sensorPin_Right);    
  sensorValue_Bottom = analogRead(sensorPin_Bottom);    
  sensorValue_Left = analogRead(sensorPin_Left);
  sensorValue_Average = (sensorValue_Top+sensorValue_Right+sensorValue_Bottom+sensorValue_Left)/4;
  Serial.print ("sensorValue_Average="); // debugging code
  Serial.println (sensorValue_Average);  // debugging code
  Serial.println (" ");   

/* below is part of the experimentation code used to get a feel for the bestdist and maxdist values I hope it is self explanatory
of course you need the do the analog read in order to be able to display these values*/
  Serial.print("- Top Value=");
  Serial.println(sensorValue_Top);
  Serial.print("- Right Value=");
  Serial.println(sensorValue_Right);
  Serial.print("- Bottom Value=");
  Serial.println(sensorValue_Bottom);
  Serial.print("- Left Value=");
  Serial.println(sensorValue_Left);
  Serial.print("- Average value=");
  Serial.println (" ");
  Serial.println((sensorValue_Top+sensorValue_Right+sensorValue_Bottom+sensorValue_Left)/4);
  delay(300);   
  /**/
   delay(30);
}
