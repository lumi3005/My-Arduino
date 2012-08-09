// Project 1 - LED Flasher
int ledPinR = 5;
int ledPinG = 6;
int ledPinA = 7;
void setup() {
pinMode(ledPinR, OUTPUT);
pinMode(ledPinG, OUTPUT);
pinMode(ledPinA, OUTPUT);
}
void loop() {
digitalWrite(ledPinR, HIGH);
delay(500);
digitalWrite(ledPinR, LOW);
delay(500);
digitalWrite(ledPinG, HIGH);
delay(500);
digitalWrite(ledPinG, LOW);
delay(500);
digitalWrite(ledPinA, HIGH);
delay(500);
digitalWrite(ledPinA, LOW);
delay(1000);
digitalWrite(ledPinR, HIGH);
digitalWrite(ledPinG, HIGH);
digitalWrite(ledPinA, HIGH);
delay(500);
digitalWrite(ledPinR, LOW);
digitalWrite(ledPinG, HIGH);
digitalWrite(ledPinA, LOW);
delay(500);
digitalWrite(ledPinR, HIGH);
digitalWrite(ledPinG, HIGH);
digitalWrite(ledPinA, HIGH);
delay(500);
digitalWrite(ledPinR, HIGH);
digitalWrite(ledPinG, LOW);
digitalWrite(ledPinA, HIGH);
delay(500);
digitalWrite(ledPinR, LOW);
digitalWrite(ledPinG, HIGH);
digitalWrite(ledPinA, LOW);
delay(1000);
digitalWrite(ledPinR, LOW);
digitalWrite(ledPinG, LOW);
digitalWrite(ledPinA, LOW);
delay(1000);
}
