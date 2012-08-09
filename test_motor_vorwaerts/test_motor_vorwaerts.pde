
int motorPinRF = 13;
int motorPinRB = 12;

int motorPinLF = 11;
int motorPinLB = 8;

int speedPinA = 10;
int speedPinB = 9;

int speed;


void setup() {
  pinMode(motorPinRF, OUTPUT);
  pinMode(motorPinRB, OUTPUT);
  pinMode(motorPinLF, OUTPUT);
  pinMode(motorPinLB, OUTPUT);  
  pinMode(speedPinA, OUTPUT);
  pinMode(speedPinB, OUTPUT);
  speed = 150;
}

void loop()
{
  analogWrite(speedPinA, speed);
  analogWrite(speedPinB, speed);
  
  digitalWrite(motorPinRF, HIGH);
  digitalWrite(motorPinRB, LOW);
  digitalWrite(motorPinLF, HIGH);
  digitalWrite(motorPinLB, LOW);
}
