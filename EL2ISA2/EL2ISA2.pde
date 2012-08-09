/***************************************************/
/////////////////////////////////////////////////////
///    EL2ISA2                                    ///
///                                               ///
///    Brain: ATTiny85                            ///
///                                               ///
///    Code version 1.0.1                         ///
///    -> forward, left turn, right turn,         ///
///    -> stop, reverse                           ///
///    -> Infrared eye, LEDs                      ///
///                                               ///
///    by Lutz Michaelis, März 2012               ///  
///    more about this robot and contact form:    ///
///    http://letsmakerobots.com/node/31848       ///
///    powered by                                 ///
///    http://www.roboter-selbstgebaut.com        ///
///                                               ///
///    This code is in the public domain.         ///
///                                               ///
/////////////////////////////////////////////////////
/***************************************************/
int motorPinRF = 0;
int motorPinRB = 1;
int motorPinLF = 3;
int motorPinLB = 4;
int sensorValue;

void setup() {
  //Serial.begin(9600);
  pinMode(motorPinRF, OUTPUT);
  pinMode(motorPinRB, OUTPUT);
  pinMode(motorPinLF, OUTPUT);
  pinMode(motorPinLB, OUTPUT); 
}

void forward(){  //  both motors forward
  digitalWrite(motorPinRF, HIGH);
  digitalWrite(motorPinLF, HIGH);
  digitalWrite(motorPinRB, LOW);
  digitalWrite(motorPinLB, LOW);
}

void reverse(){  //  both motors reverse
  digitalWrite(motorPinRF, LOW);
  digitalWrite(motorPinLF, LOW);
  digitalWrite(motorPinRB, HIGH);
  digitalWrite(motorPinLB, HIGH);
}

void right_turn(){  //  left motor forward, right motor backward
  digitalWrite(motorPinRF, LOW);
  digitalWrite(motorPinLF, HIGH);
  digitalWrite(motorPinRB, HIGH);
  digitalWrite(motorPinLB, LOW);
}

void left_turn(){  //  right motor forward, left motor backward 
  digitalWrite(motorPinRF, HIGH);
  digitalWrite(motorPinLF, LOW);
  digitalWrite(motorPinRB, LOW);
  digitalWrite(motorPinLB, HIGH);
}

void stand(){  // all stop
  digitalWrite(motorPinRF, LOW);
  digitalWrite(motorPinLF, LOW);
  digitalWrite(motorPinRB, LOW);
  digitalWrite(motorPinLB, LOW);
}

void loop() {
  
  sensorValue = analogRead(1);  // IMPORTANT: on the ATTiny85 the analog input for this input PIN is leg #7                                    
  /*
  Serial.print("sensor = " );                       
  Serial.println(sensorValue);    
  */  
  if (sensorValue < 900)  // check sensor value and do the following when it drops below 900 (app. 3 - 5 cm)
  {
    stand();
    delay (4000);
    reverse();
    delay (500);
    stand();
    delay (1000);
    left_turn();
    delay (500);
    forward();
    delay (500);    
    stand();
    delay (500);
    left_turn();
    delay (300); 
    right_turn();
    delay (300);
  }
  else
  {
    forward();  // if nothing in collision range then just go ahead
  }
}







