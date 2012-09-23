 // Library inclusions
 #include <Servo.h>

 
//VAR Declaration

//the time we give the sensor to calibrate (10-60 secs according to the datasheet)
int calibrationTime = 2; 
int Pos_P = 0;  // Variable to store Pan servo position
int Pos_T = 0;  // Variable to store Tilt servo position
int Servo_Pan_Centre = 90; // lumi 70
int Servo_Tilt_Centre = 90; // lumi 70
int Servo_Min_Pos = 10;
int Servo_Max_Pos = 170;
int Pan_Scale = 0;
int Tilt_Scale = 0;
int Max_Dist=185; // Maximum distance to check against. This value was determined from sensor reading averages
int Best_Dist=400; // Best distance to check against. This value was determined from sensor reading averages
//VAR pin selection
int sensorPin_Top = 0;    // select the Arduino input pin for the CompoundEye PCB IR pin 2
int sensorPin_Right = 3;    // select the Arduino input pin for the CompoundEye PCB IR pin 3
int sensorPin_Bottom = 2;    // select the Arduino input pin for the CompoundEye PCB IR pin 4
int sensorPin_Left = 1;    // select the Arduino input pin for the CompoundEye PCB IR pin 5
int ledPin = 13;      // select the Arduino output pin for turning on the compound eye PCB IR LED
//VAR sensorvalues
int sensorValue_Top = 0;  // variable to store the value coming from the Compound Eye sensor(Top)
int sensorValue_Right = 0;  // variable to store the value coming from the Compound Eye sensor(Right)
int sensorValue_Bottom = 0;  // variable to store the value coming from the Compound Eye sensor(Bottom)
int sensorValue_Left = 0;  // variable to store the value coming from the Compound Eye sensor(Left)
int sensorValue_Average = 0;
//VAR servo object creation
Servo Servo_Pan;
Servo Servo_Tilt;

void setup() {
//  Serial.begin(9600);
  Servo_Pan.attach(5);  // assign pin for the Pan Servo
  Servo_Tilt.attach(6);  // assign pin for the Tilt Servo
  pinMode(ledPin, OUTPUT);    // declare the ledPin as an OUTPUT:
  digitalWrite(ledPin, HIGH);   // turn the ledPin on

// Center the servos
  Pos_T=Servo_Tilt_Centre;
  Pos_P=Servo_Pan_Centre;
  Servo_Pan.write(Pos_P);
  Servo_Tilt.write(Pos_T);
//  Serial.print("calibrating sensor ");
//  for(int i = 0; i < calibrationTime; i++){
//      Serial.print(".");
//      delay(1000);
      }
//    Serial.println(" done");
//    Serial.println("SENSOR ACTIVE");
//    delay(50);

 
//}

void loop() {
  // read the value from the sensor and determine if the object is in range if not return the Pan/Tilt servos to the center:
  sensorValue_Top = analogRead(sensorPin_Top);    
  sensorValue_Right = analogRead(sensorPin_Right);    
  sensorValue_Bottom = analogRead(sensorPin_Bottom);    
  sensorValue_Left = analogRead(sensorPin_Left);
  sensorValue_Average = (sensorValue_Top+sensorValue_Right+sensorValue_Bottom+sensorValue_Left)/4;
//  Serial.print ("sensorValue_Average="); // debugging code
//  Serial.println (sensorValue_Average);  // debugging code
  if (sensorValue_Average < Max_Dist) {
    if (Pos_T > Servo_Tilt_Centre) {
      Pos_T = Pos_T - 1;
      Servo_Tilt.write(Pos_T);
    }
    if (Pos_T < Servo_Tilt_Centre) {
      Pos_T = Pos_T + 1;
      Servo_Tilt.write(Pos_T);
    }
    if (Pos_P > Servo_Pan_Centre) {
      Pos_P = Pos_P - 1;
      Servo_Pan.write(Pos_P);
    }
    if (Pos_P < Servo_Pan_Centre) {
      Pos_P = Pos_P + 1;
      Servo_Pan.write(Pos_P);
    }
  }
// if the object is in range we need to start tracking it
   if (sensorValue_Average > Max_Dist) {
     Pan_Scale = (sensorValue_Left + sensorValue_Right) / 10;
     Tilt_Scale = (sensorValue_Top + sensorValue_Bottom) / 10;
     if (sensorValue_Left > sensorValue_Right) {
       Pos_P = Pos_P -((sensorValue_Left - sensorValue_Right) / Pan_Scale);
       if (Pos_P < Servo_Min_Pos) {
         Pos_P = Servo_Min_Pos;
       }
//     Serial.println ("Going Left"); // debugging code
     Servo_Pan.write(Pos_P);
     }
     if (sensorValue_Left < sensorValue_Right) {
       Pos_P = Pos_P +((sensorValue_Right - sensorValue_Left) / Pan_Scale);
       if (Pos_P > Servo_Max_Pos) {
         Pos_P = Servo_Max_Pos;
       }
//     Serial.println ("Going Right"); // debugging code
     Servo_Pan.write(Pos_P);
     }
     if (sensorValue_Top > sensorValue_Bottom) {
       Pos_T = Pos_T -((sensorValue_Top - sensorValue_Bottom) / Tilt_Scale);
       if (Pos_T < Servo_Min_Pos) {
         Pos_T = Servo_Min_Pos;
       }
//     Serial.println ("Going Up"); // debugging code
     Servo_Tilt.write(Pos_T);
     }
     if (sensorValue_Top < sensorValue_Bottom) {
       Pos_T = Pos_T +((sensorValue_Bottom - sensorValue_Top) / Tilt_Scale);
       if (Pos_T > Servo_Max_Pos) {
         Pos_T = Servo_Max_Pos;
       }
//     Serial.println ("Going Down"); // debugging code
     Servo_Tilt.write(Pos_T);
     }
   }



/* below is part of the experimentation code used to get a feel for the bestdist and maxdist values I hope it is self explanatory
of course you need the do the analog read in order to be able to display these values
  Serial.println("Top Value=");
  Serial.println(sensorValue_Top);
  Serial.println("- Right Value=");
  Serial.println(sensorValue_Right);
  Serial.println("- Bottom Value=");
  Serial.println(sensorValue_Bottom);
  Serial.println("- Left Value=");
  Serial.println(sensorValue_Left);
  Serial.println("- Average value=");
  Serial.println((sensorValue_Top+sensorValue_Right+sensorValue_Bottom+sensorValue_Left)/4);
  delay(500);   
  */
   delay(30);
}
