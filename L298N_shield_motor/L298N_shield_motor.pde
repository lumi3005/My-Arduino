
int motorPinRF = 13;
int motorPinRB = 12;

int motorPinLF = 11;
int motorPinLB = 8;

int speedPinA = 10;
int speedPinB = 9;

int speed;

int i;


void setup() {
  pinMode(motorPinRF, OUTPUT);
  pinMode(motorPinRB, OUTPUT);
  pinMode(motorPinLF, OUTPUT);
  pinMode(motorPinLB, OUTPUT);  
  pinMode(speedPinA, OUTPUT);
  pinMode(speedPinB, OUTPUT);
  speed = 255;
  Serial.begin(9600);
}

void loop()
{

  Serial.print("Zähler hoch = ");
  Serial.println(i);
  delay(50);
  analogWrite(speedPinA, speed);
  analogWrite(speedPinB, speed);
  digitalWrite(motorPinRF, LOW);
  digitalWrite(motorPinRB, HIGH);
  digitalWrite(motorPinLF, LOW);
  digitalWrite(motorPinLB, HIGH);

  /*while (i < 1){
  i--;
  speed = i;
  Serial.print("Zähler runter = ");
  Serial.println(i);
  delay(50);
  analogWrite(speedPinA, speed);
  analogWrite(speedPinB, speed);
  digitalWrite(motorPinRF, LOW);
  digitalWrite(motorPinRB, HIGH);
  digitalWrite(motorPinLF, LOW);
  digitalWrite(motorPinLB, HIGH);
  }
  i = 0;*/
}
