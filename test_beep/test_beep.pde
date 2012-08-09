// Project 3 - Traffic Lights
int beepDelay = 5000; // delay in between changes
int Beeper = 11;

void setup() {
pinMode(Beeper, OUTPUT);
}
void loop() {
digitalWrite(Beeper, HIGH); // turn the red light on
delay(beepDelay); // wait 5 seconds
digitalWrite(Beeper, LOW);
delay(beepDelay); // wait 5 seconds
// now our loop repeats
}
