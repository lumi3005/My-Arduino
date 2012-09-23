/*
  Light seeker
 
 */

#define sensorR 9       // select the input pin for the right LDR (A0 on Arduino is 9 on Attiny2313)
#define sensorL 10      // select the input pin for the left LDR (A1 on Arduino is 10 on Attiny2313)
#define ledPin 13       // select the pin for the LED

unsigned int sensorValueR = 0;  // variable to store the value coming from the sensor
unsigned int sensorValueL = 0;  // variable to store the value coming from the sensor

int outputValueL = 0;  
int outputValueR = 0;

//These pins are connected to the L293D motor controller
#define M_LF 2               // Motor Left Front
#define M_LB 3               // Motor Left Back
#define M_RF 5               // Motor Right Front
#define M_RB 4               // Motor Right Back
#define M_REn 7              // Motor Right ENABLE
#define M_LEn 11             // Motor Left ENABLE
#define RxPin 0
#define TxPin 1


void setup() {
  // declare the ledPin as an OUTPUT:
  pinMode(ledPin, OUTPUT); 
  
  pinMode(M_LF, OUTPUT);
  pinMode(M_LB, OUTPUT);
  pinMode(M_RF, OUTPUT);
  pinMode(M_RB, OUTPUT);
  
  pinMode(RxPin, OUTPUT);
  pinMode(TxPin, OUTPUT);
  pinMode(sensorR, INPUT);
  pinMode(sensorL, INPUT); 
  
  #ifndef PWM
  // just testing no PWM, L293 always enabled!
  pinMode(M_REn, OUTPUT);
  pinMode(M_LEn, OUTPUT);
  digitalWrite(M_REn, HIGH);    // Low is disabled
  digitalWrite(M_LEn, HIGH);    // Low is disabled  
  #endif
  
  digitalWrite(TxPin, HIGH);
  digitalWrite(RxPin, HIGH);
  wait();
  digitalWrite(TxPin, LOW);
  digitalWrite(RxPin, LOW);
  wait();
  digitalWrite(TxPin, HIGH);
  digitalWrite(RxPin, HIGH);
  wait();
  digitalWrite(TxPin, LOW);
  digitalWrite(RxPin, LOW);
  wait();
  digitalWrite(TxPin, HIGH);
  digitalWrite(RxPin, HIGH);
  wait();
  digitalWrite(TxPin, LOW);
  digitalWrite(RxPin, LOW);
  wait();
//  Serial.begin(9600); 
}

void loop() {
  // read the value from the sensor:
  sensorValueL = digitalRead(sensorL);
  sensorValueR = digitalRead(sensorR); 
/*  
  outputValueL = map(sensorValueL, 0, 1023, 0, 100);  
  outputValueR = map(sensorValueR, 0, 1023, 0, 100); 

  // print the results to the serial monitor:
  Serial.print("sensor left = " );                       
  Serial.print(sensorValueL);      
  Serial.print("\t output left= ");      
  Serial.print(outputValueL/20);
  Serial.print(" Volt\t*****\t");
  
  // print the results to the serial monitor:
  Serial.print("sensor diright = " );                       
  Serial.print(sensorValueR);      
  Serial.print("\t output right= ");      
  Serial.print(outputValueR/20);
  Serial.println(" Volt");
  
  delay(500);*/
  
  if(sensorValueR == sensorValueL){
  //forward();
  digitalWrite(TxPin, HIGH);
  digitalWrite(RxPin, HIGH);
  wait();
  }
  else if(sensorValueR > sensorValueL){
  //turnRight();
  digitalWrite(TxPin, HIGH);
  digitalWrite(RxPin, LOW);
  wait();
  } 
  else if(sensorValueR < sensorValueL){
  //turnLeft();
  digitalWrite(TxPin, LOW);
  digitalWrite(RxPin, HIGH);
  wait();
  }
  /*if(sensorValueR > 1000  && sensorValueL > 1000){
  digitalWrite(TxPin, LOW);
  digitalWrite(RxPin, LOW);
  }*/
}

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
