// Project 1 - LED Flasher
byte forward = 3;
byte backward = 4;
byte right = 5;
byte left = 6;

byte test = 7;
byte light_right = 8;
byte light_left = 9;
byte light_all = 10;

byte speaker = 11;

byte ledPin = 13;

void setup() {
pinMode(forward, OUTPUT);
pinMode(backward, OUTPUT);
pinMode(right, OUTPUT);
pinMode(left, OUTPUT);

pinMode(test, OUTPUT);
pinMode(light_right, OUTPUT);
pinMode(light_left, OUTPUT);
pinMode(light_all, OUTPUT);

pinMode(speaker, OUTPUT);
}
void loop() {
digitalWrite(forward, HIGH);
delay(1000);
digitalWrite(forward, LOW);
digitalWrite(ledPin, HIGH);
delay(2000);
digitalWrite(ledPin, LOW);

digitalWrite(backward, HIGH);
delay(1000);
digitalWrite(backward, LOW);
digitalWrite(ledPin, HIGH);
delay(2000);
digitalWrite(ledPin, LOW);

digitalWrite(left, HIGH);
delay(1000);
digitalWrite(left, LOW);
digitalWrite(ledPin, HIGH);
delay(2000);
digitalWrite(ledPin, LOW);

digitalWrite(right, HIGH);
delay(1000);
digitalWrite(right, LOW);
digitalWrite(ledPin, HIGH);
delay(2000);
digitalWrite(ledPin, LOW);

digitalWrite(test, HIGH);
delay(1000);
digitalWrite(test, LOW);
digitalWrite(ledPin, HIGH);
delay(2000);
digitalWrite(ledPin, LOW);

digitalWrite(light_right, HIGH);
delay(1000);
digitalWrite(light_right, LOW);
digitalWrite(ledPin, HIGH);
delay(2000);
digitalWrite(ledPin, LOW);

digitalWrite(light_left, HIGH);
delay(1000);
digitalWrite(light_left, LOW);
digitalWrite(ledPin, HIGH);
delay(2000);
digitalWrite(ledPin, LOW);

digitalWrite(light_all, HIGH);
delay(1000);
digitalWrite(light_all, LOW);
digitalWrite(ledPin, HIGH);
delay(2000);
digitalWrite(ledPin, LOW);

digitalWrite(speaker, HIGH);
delay(1000);
digitalWrite(speaker, LOW);
digitalWrite(ledPin, HIGH);
delay(2000);
digitalWrite(ledPin, LOW);
}
