/*
 *  NV DRD v1.0 by Jason Adams <darkbytes@gmail.com>
 */

char version[] = "NV DRD v1.0 beta";

#include <AFMotor.h>
#include <Servo.h>

// create the motor objects
AF_DCMotor motor1(1, MOTOR12_64KHZ); // create motor #1, 64KHz pwm
AF_DCMotor motor2(2, MOTOR12_64KHZ); // create motor #2, 64KHz pwm
Servo headTurner;                    // create servo object for turning the Ping))) sensor

// the calibrated servo motor positions for forward, left, and right.
#define forward  99
#define left     180
#define right    20

// pin assignments
#define servoPin          9     // servo motor on pin 9
#define pingSensorPin     19    // Ping))) sensor on A5 (analog pins 0-5 can be used as digital pins 14-19)
#define leftAntennaeLED   6
#define rightAntennaeLED  5

// constantly changing variables
long pingSensorReading, forwardReading, leftReading, rightReading;
int directionToGo = 0;       // 0 = forward, 1 = left, 2 = right
boolean switchTurn = false;  // false = right, true = left - this bool is for alternating the direction 
                             // the bot decides to turn when the right and left readings are the same


void setup() {
  pinMode(leftAntennaeLED, OUTPUT);
  pinMode(rightAntennaeLED, OUTPUT);
  
  Serial.begin(9600);           // set up Serial library at 9600 bps
  Serial.println(version);
  
  motor1.setSpeed(255);     // set the speed to 200/255
  motor2.setSpeed(255);     // set the speed to 200/255

  // attach the servo object to the pin the servo motor is on
  headTurner.attach(servoPin);
  delay(100);
  
  /* blink
  for (int i = 0; i < 2; i++) {
    digitalWrite(leftAntennaeLED, HIGH);
    digitalWrite(rightAntennaeLED, HIGH);
    delay(100);
    digitalWrite(leftAntennaeLED, LOW);
    digitalWrite(rightAntennaeLED, LOW);
    delay(100);
  } */
  
  // turn antennae lights on for good
  //for(int fadeValue = 0 ; fadeValue <= 255; fadeValue +=5) {
  analogWrite(leftAntennaeLED, 50);
  analogWrite(rightAntennaeLED, 50);
  
  chooseDirection();
    
  // travel forward
  Serial.println("driving forward");
  motor1.run(FORWARD);
  motor2.run(FORWARD);  
}


void loop() {
  // see if we're nearing an object  
  forwardReading = readPingSensor();
  Serial.print("forward reading: ");
  Serial.println(forwardReading);

  // if we are nearing an object, stop moving...
  if (forwardReading < 1000) {  // 1000 appears to be a good "too close" threshold for forward obstacles 
    Serial.println("something is close, ALL STOP!");
    motor1.run(RELEASE);
    motor2.run(RELEASE);
    delay(100);
    
    // back up a bit
    Serial.println("back up a little bit");
    motor1.run(BACKWARD);
    motor2.run(BACKWARD);
    delay(400);
    motor1.run(RELEASE);
    motor2.run(RELEASE);
    delay(500);
    
    /* blink
    for (int i = 0; i < 2; i++) {
      digitalWrite(leftAntennaeLED, HIGH);
      digitalWrite(rightAntennaeLED, HIGH);
      delay(100);
      digitalWrite(leftAntennaeLED, LOW);
      digitalWrite(rightAntennaeLED, LOW);
      delay(100);
    } */
    
    
    chooseDirection();
        
    // travel forward
    Serial.println("driving forward");
    motor1.run(FORWARD);
    motor2.run(FORWARD);    
  }

  // wait 3/10 of a second so the Ping))) sensor gets polled 3x/sec when driving forward
  delay(333);
}


void chooseDirection() {
  // turn Ping))) sensor to look forward and then take a reading
  headTurner.write(forward);
  delay(500);
  forwardReading = readPingSensor();
  Serial.print("forward reading: ");
  Serial.println(forwardReading);
  delay(250);
  
  // turn Ping))) sensor to look left and then take a reading
  headTurner.write(left);
  delay(500);
  leftReading = readPingSensor();
  Serial.print("left reading: ");
  Serial.println(leftReading);
  delay(250);
  
  // compare the 'forward' and 'left' readings to see which direction offers more distance to travel
  if (forwardReading >= leftReading) {
    directionToGo = 0;
    Serial.println("determining i should go forward");
  } else {
    directionToGo = 1;
    Serial.println("determining i should go left");
  }
  
  // turn Ping))) sensor to look right and then take a reading
  headTurner.write(right);
  delay(650);
  rightReading = readPingSensor();
  Serial.print("right reading: ");
  Serial.println(rightReading);
  delay(250);

  // compare the 'right' reading to the winner of the previous comparison to see which direction we should go
  if (directionToGo == 0 && rightReading > forwardReading) {
    directionToGo = 2;
    Serial.println("determining i should go right instead of forward");
  } else if (directionToGo == 1 && rightReading > leftReading) {
    directionToGo = 2;
    Serial.println("determining i should go right instead of left");
  } else if (directionToGo == 1 && rightReading == leftReading) {
    if (switchTurn == false) {
      directionToGo = 2;
      Serial.println("right and left readings are the same; going right this time");
    } else {
      directionToGo = 1;
      Serial.println("right and left readings are the same; going left this time");
    }
    switchTurn = !switchTurn;
  }
  
  // if we're travelling left...
  if (directionToGo == 1) {
    // look left
    headTurner.write(left);
    delay(300);
    Serial.println("turning left");
    // turn left
    motor1.run(BACKWARD);
    motor2.run(FORWARD);
    delay(700);
    motor1.run(RELEASE);
    motor2.run(RELEASE);
    delay(300);
    // if we're travelling right...
  } else if (directionToGo == 2) {
    Serial.println("turn to the right");
    // we're already looking right, so turn right
    motor1.run(FORWARD);
    motor2.run(BACKWARD);
    delay(700);
    motor1.run(RELEASE);
    motor2.run(RELEASE);
    delay(300);
  }
  
  // look forward again in preparation for moving forward again
  headTurner.write(forward);
  delay(300);
}
  
  
long readPingSensor() {
  // The PING))) is triggered by a HIGH pulse of 2 or more microseconds.
  // Give a short LOW pulse beforehand to ensure a clean HIGH pulse:
  pinMode(pingSensorPin, OUTPUT);
  digitalWrite(pingSensorPin, LOW);
  delayMicroseconds(2);
  digitalWrite(pingSensorPin, HIGH);
  delayMicroseconds(5);
  digitalWrite(pingSensorPin, LOW);

  // The same pin is used to read the signal from the PING))): a HIGH
  // pulse whose duration is the time (in microseconds) from the sending
  // of the ping to the reception of its echo off of an object.
  pinMode(pingSensorPin, INPUT);
  pingSensorReading = pulseIn(pingSensorPin, HIGH);
  
  return pingSensorReading;
}

