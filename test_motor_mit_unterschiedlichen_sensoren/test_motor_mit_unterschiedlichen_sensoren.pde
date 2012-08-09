/* 
  ------------------------------------
  Test with IR sensor Sharp
  Author: Lutz Michaelis
  http://www.roboter-selbstgebaut.com
  More details about this working in a bot: 
  http://letsmakerobots.com/user/14721 -> Check "Steven X"
  ------------------------------------
*/

/*
    Set variables for motor control and distance value
*/
int motorPinRF = 10;
int motorPinRB = 11;
int motorPinLF = 12;
int motorPinLB = 13;
int distance;

/*
    Motor functions for forward (go), stop, backward and left, turn right and turn left
*/
void motorGo() {
// motor Go function
  digitalWrite(motorPinRF, HIGH);
  digitalWrite(motorPinLF, HIGH);
  digitalWrite(motorPinRB, LOW);
  digitalWrite(motorPinLB, LOW);
}

void motorStop() {
// motor stop function
  digitalWrite(motorPinRF, LOW);
  digitalWrite(motorPinLF, LOW);
  digitalWrite(motorPinRB, LOW);
  digitalWrite(motorPinLB, LOW);
  delay(1000);
}

void motorBackLeft() {
// motor back function
    digitalWrite(motorPinRF, LOW);
    digitalWrite(motorPinLF, LOW);
    digitalWrite(motorPinRB, HIGH);
    digitalWrite(motorPinLB, HIGH);
    delay(1000);
    digitalWrite(motorPinRF, HIGH);
    digitalWrite(motorPinLF, LOW);
    digitalWrite(motorPinRB, LOW);
    digitalWrite(motorPinLB, HIGH);
    delay(300);
}

void turnRight() {
// vehicle right turn function
  digitalWrite(motorPinRF, LOW);
  digitalWrite(motorPinLF, HIGH);
  digitalWrite(motorPinRB, LOW);
  digitalWrite(motorPinLB, HIGH);
}

void turnLeft() {
// vehicle left turn function
  digitalWrite(motorPinRF, HIGH);
  digitalWrite(motorPinLF, LOW);
  digitalWrite(motorPinRB, LOW);
  digitalWrite(motorPinLB, HIGH);
}

/*
    Setup the outputs and the serial communication for debugging and adjusting the distance sensor value
*/
void setup() {
  Serial.begin(9600);
  pinMode(motorPinRF, OUTPUT);
  pinMode(motorPinRB, OUTPUT);
  pinMode(motorPinLF, OUTPUT);
  pinMode(motorPinLB, OUTPUT);
}

/*
    Start acting :-)
*/
void loop()
{
   distance = analogRead(0);      // Read the value of the IR sensor to the variable distance
   Serial.println(distance);      // Serial output of the distance value
   if ( distance > 500 )          // check if the distance is less than 10cm (a value of 500 is around 10cm)
   {
      motorBackLeft();            // rund both motors backwards and then do for 300ms a turn
   }
   else
   {
     motorGo();                   // Run both motors forward
   }
}
