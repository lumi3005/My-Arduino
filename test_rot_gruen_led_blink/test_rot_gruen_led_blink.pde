// Project 1 - LED Flasher
int ledPinR = 10;
int ledPinG = 11;
void setup() {
pinMode(ledPinR, OUTPUT);
pinMode(ledPinG, OUTPUT);
}
void loop() {
digitalWrite(ledPinR, HIGH);
delay(100);
digitalWrite(ledPinR, LOW);
delay(100);
digitalWrite(ledPinG, HIGH);
delay(100);
digitalWrite(ledPinG, LOW);
delay(100);
digitalWrite(ledPinR, HIGH);
digitalWrite(ledPinG, HIGH);
delay(100);
digitalWrite(ledPinR, LOW);
digitalWrite(ledPinG, LOW);
delay(100);
digitalWrite(ledPinR, HIGH);
digitalWrite(ledPinG, HIGH);
delay(100);
digitalWrite(ledPinR, LOW);
digitalWrite(ledPinG, LOW);
delay(100);
}
