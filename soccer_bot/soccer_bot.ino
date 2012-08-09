/***************************************************/
/////////////////////////////////////////////////////
///    Soccer Bot                                 ///
///                                               ///
///    Brain: ATTiny85                            ///
///                                               ///
///    Code version 1.0.1                         ///
///    -> forward, left turn, right turn,         ///
///    -> stop, reverse                           ///
///                                               ///
///    www.xinchejian.com                         ///
///                                               ///
///    This code is in the public domain.         ///
///                                               ///
/////////////////////////////////////////////////////
/***************************************************/
int motor_right_forward = 4; //pin 6
int motor_right_reverse = 5; //pin 7
int right_motor_speed = 7; // pin 9
//int rightSpeed = 0; // pin
int motor_left_forward = 2; // pin 4
int motor_left_reverse = 3; // pin 5
int left_motor_speed = 11; // pin 14
//int leftSpeed = 0; // pin
int ledRight = 0;
int ledLeft = 1;


void setup() {
  //Serial.begin(9600);
  pinMode(motor_right_forward, OUTPUT);
  pinMode(motor_right_reverse, OUTPUT);
  pinMode(motor_left_forward, OUTPUT);
  pinMode(motor_left_reverse, OUTPUT); 
  pinMode(ledRight, OUTPUT);
  pinMode(ledLeft, OUTPUT);  
  delay(5000);
}

void forward(){  //  both motors forward
  digitalWrite(motor_right_forward, HIGH);
  digitalWrite(motor_left_forward, HIGH);
  digitalWrite(motor_right_reverse, LOW);
  digitalWrite(motor_left_reverse, LOW);
  digitalWrite(ledRight, HIGH);
  digitalWrite(ledLeft, HIGH);
}

void reverse(){  //  both motors reverse
  digitalWrite(motor_right_forward, LOW);
  digitalWrite(motor_left_forward, LOW);
  digitalWrite(motor_right_reverse, HIGH);
  digitalWrite(motor_left_reverse, HIGH);
  digitalWrite(ledRight, LOW);
  digitalWrite(ledLeft, LOW);
}

void right_turn(){  //  left motor forward, right motor backward
  digitalWrite(motor_right_forward, LOW);
  digitalWrite(motor_left_forward, HIGH);
  digitalWrite(motor_right_reverse, HIGH);
  digitalWrite(motor_left_reverse, LOW);
  digitalWrite(ledRight, HIGH);
  digitalWrite(ledLeft, LOW);
}

void left_turn(){  //  right motor forward, left motor backward 
  digitalWrite(motor_right_forward, HIGH);
  digitalWrite(motor_left_forward, LOW);
  digitalWrite(motor_right_reverse, LOW);
  digitalWrite(motor_left_reverse, HIGH);
  digitalWrite(ledRight, LOW);
  digitalWrite(ledLeft, HIGH);
}

void stand(){  // all stop
  digitalWrite(motor_right_forward, LOW);
  digitalWrite(motor_left_forward, LOW);
  digitalWrite(motor_right_reverse, LOW);
  digitalWrite(motor_left_reverse, LOW);  
}

void loop() {
  
    forward();
    delay (2000);
    stand();
    delay (1000);
    reverse();
    delay (2000);
    stand();
    delay (1000);
    left_turn();
    delay (2000);
    stand();
    delay (1000);    
    right_turn();
    delay (2000); 
    stand();
    delay (1000);
    
    for(int blinky = 0 ; blinky <= 5; blinky ++) { 
      digitalWrite(ledLeft, HIGH);
      digitalWrite(ledRight, HIGH);
      //left_turn();    
      delay(500);
      //stand();  
      digitalWrite(ledLeft, LOW);
      digitalWrite(ledRight, LOW);
      //right_turn();
      delay(500);
      //stand();
    }  
}







