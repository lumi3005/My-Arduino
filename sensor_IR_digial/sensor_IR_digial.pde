/*
  Analog Input
 Demonstrates analog input by reading an analog sensor on analog pin 0 and
 turning on and off a light emitting diode(LED)  connected to digital pin 13. 
 The amount of time the LED will be on and off depends on
 the value obtained by analogRead(). 
 
 The circuit:
 * Potentiometer attached to analog input 0
 * center pin of the potentiometer to the analog pin
 * one side pin (either one) to ground
 * the other side pin to +5V
 * LED anode (long leg) attached to digital output 13
 * LED cathode (short leg) attached to ground
 
 * Note: because most Arduinos have a built-in LED attached 
 to pin 13 on the board, the LED is optional.
 
 
 Created by David Cuartielles
 Modified 4 Sep 2010
 By Tom Igoe
 
 This example code is in the public domain.
 
 http://arduino.cc/en/Tutorial/AnalogInput
 
 */

int sensorPinLeft = 8;    // select the input pin for the potentiometer
int sensorPinRight = 9;
int left = 0;  // variable to store the value coming from the sensor
int right = 0;

void setup() {
  Serial.begin(9600); 
  // declare the ledPin as an OUTPUT:
  pinMode(sensorPinLeft, INPUT);  
  pinMode(sensorPinRight, INPUT);
}

void loop() {
  // read the value from the sensor:
  left = digitalRead(sensorPinLeft);  
  right = digitalRead(sensorPinRight);
  // turn the ledPin on
    Serial.print("Left Distlance");
    Serial.print(left);
    Serial.print(" - Right Distlance");
    Serial.print(right);
    Serial.println(); 
    delay(10);
  
}
