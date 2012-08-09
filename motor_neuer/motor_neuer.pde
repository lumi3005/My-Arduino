/*
 *  nv:drd v2.0 alpha 2 by Jason Adams <darkbytes@gmail.com>
 *
 *  DONE:
 *  + complete rewrite of the code for efficiency and reworkability
 *  + the bot now, every so often, spins around like a puppy for a few seconds and goes to sleep
 *  + made the bot stop and do a dance every so often
 *  + created a function that alternately fades and flashes the LEDs
 *  + put blinking and backing-up in their own functions and added the ability to pass 
 *    parameters to them to change the number of blinks and the duration of backing-up each time
 *  + created functions for turning left and right, with the ability to pass params (as ints)
 *    to determine how long to turn
 *  + implemented a way to detect that the bot is no longer moving forward and is therefore 
 *    likely stuck on something outside its field of view
 *  + the bot takes a forward reading after turning but before moving again, to make sure there
 *    is a fair amount of distance to travel. It then continues to look around and turn
 *    until it detects enough room to move
 *  + found the bug that causes the bot to see a nonexistent obsticle as soon as loop() starts
 *  + the function in which the bot decides which direction to next travel can now be called 
 *    in two ways:
 *        1) 'forward' is considered a viable direction to choose
 *        2) 'forward' is ignored and the bot will turn either left or right
 *
 *  TODO:
 *  - tweak the bot's dance, to make it do a better dance and to make the code a bit more efficient 
 *    and less monotonous
 *  - correct for the max distance the sensor can return so it doesn't interpret a large,
 *    open room in which it can see to it's farthest ability for a length of time as being stuck
 *  - the bot could determine that it's "still" stuck after making an attempt to back up to free itself,
 *    and therefore make another, different attempt to free itself, say by alternatly backing up each
 *    wheel individually a couple times, and then together. if repeated attempts fail, it can stop and
 *    signal that it knows it's very stuck
 *  - could add a cheap gyroscope chip to determine when the bot has tipped over onto its side, then stop
 *    the wheels and play some kind of LED animation or something
 *
 *  NEEDS TESTING:
 *  x make the trigger mechanism for the bot determining it's stuck less precise than one centimeter.
 *    Maybe make it three cm; one less and one more than the reading taken - ALTHOUGH IT SEEMS TO WORK
 *    VERY WELL, I NEED TO VERIFY THAT THIS CODE WORKS BY WATCHING THE SERIAL OUTPUT
 *
 */

char version[] = "nv:drd v2.0 alpha 2";

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


// unchanging variables that act as defaults
int noForward           = 0;      // do not consider going forward when choosing the next direction to travel
int yesForward          = 1;      // consider forward as valid a direction as left and right when choosing the next direction
int defaultBrightness   = 50;     // default LED brightness using analogWrite(). the scale is 0-255
int minDistance         = 1500;   // the minimum distance to an object before the bot refuses to go forward anymore
int defaultTurn         = 550;    // the length of time, in milliseconds, to turn left or right after encountering an obsticle
int sleepTurn           = 5000;   // length of time, in milliseconds, to spin around like a puppy before falling asleep
int flinchDuration      = 300;    // the length of time, in milliseconds, that the bot jumps back after detecting an obsticle
                                  // in front of it
int stuckBackup         = 2000;   // the length of time, in milliseconds, that the bot backs up after deciding it's stuck


// changing variables
boolean switchTurn      = false;  // false = right, true = left - this bool is for alternating the direction 
                                  // the bot decides to turn when the right and left readings are the same.
                                  // One time it'll go right, the next time left, etc.
boolean allowStuckCheck = false;  // this gets flipped to true after the Ping))) sensor has recorded 
                                  // distances (converted to cm) in all four of the ints below. it then
                                  // gets flipped false again after running the block of code that gets run
                                  // when the bot attempts to get unstuck. this will prevent it from immediately
                                  // thinking it's stuck again
int directionToGo       = 0;      // 0 = forward, 1 = left, 2 = right
int sleepTimer          = 0;      // a counter to increment until the next time the bot stops and "sleeps"
int danceTimer          = 0;      // a counter to increment until the next time the bot dances
int logTimer            = 0;      // a counter to regulate the logging of forward Ping))) sensor readings
int counterToConfusion  = 0;      // a counter to trigger he "confused" LED animation after multiple failed 
                                  // attempts to turn to a direction that offers enough room to move forward
int storeFRead1         = 0;      // <- these four are for storing the forward distance readings to aid the bot 
int storeFRead2         = 0;      // <- in determining whether it is stuck on something outside its detection
int storeFRead3         = 0;      // <- range
int storeFRead4         = 0;      // <-
long pingSensorReading, forwardReading, leftReading, rightReading; // these store the ping sensor readings


// setup() (gets run once)
void setup() {
  // initiate the LEDs
  pinMode(leftAntennaeLED, OUTPUT);
  pinMode(rightAntennaeLED, OUTPUT);
  
  // set up Serial library at 9600 bps
  Serial.begin(9600);
  Serial.println(version);
  
  // set the speeds to 200/255
  motor1.setSpeed(255);
  motor2.setSpeed(255);

  // attach the servo object to the pin the servo motor is on
  headTurner.attach(servoPin);
  delay(100);

  // turn Ping))) sensor forward, just to orient it for show immediately upon starting  
  headTurner.write(forward);
  
  // turn antennae lights on
  analogWrite(leftAntennaeLED, defaultBrightness);
  analogWrite(rightAntennaeLED, defaultBrightness);
  
  // choose which direction to go
  chooseDirection(yesForward);

  // travel forward
  goForward();
  
  // travel forward for at least one second. this helps squash the fantom-obsticle bug that appears between setup() and loop()
  delay(1000);
}


// loop() (gets run repeatedly)
void loop() {
  // see if we're nearing an object while moving forward
  forwardReading = readPingSensor();
  Serial.print("forward reading: ");
  Serial.println(forwardReading);
  delay(100);

  // increment the timer that helps decide when to next stop and go to sleep
  sleepTimer++;
  
  // increment the timer that helps decide when it's time to DANCE!
  danceTimer++;
  
  // increment the timer that triggers storing of forwardReading values, to help determine we might be stuck
  logTimer++;
  
  // log every fifth forward reading to see if we're making any forward progress or possibly stuck on an object outside the sensor's view
  if (logTimer == 5) {
    storeFRead4 = storeFRead3;
    storeFRead3 = storeFRead2;
    storeFRead2 = storeFRead1;
    storeFRead1 = (forwardReading * 0.03434);

    // announce the readings to serial
    Serial.println("");
    Serial.print("storeFRead1: ");
    Serial.println(storeFRead1);
    Serial.print("storeFRead2: ");
    Serial.println(storeFRead2);
    Serial.print("storeFRead3: ");
    Serial.println(storeFRead3);
    Serial.print("storeFRead4: ");
    Serial.println(storeFRead4);
    Serial.println("");
    
    /* THIS HAS NOT BEEN TESTED */ /* IT SEEMS TO WORK IN PRACTICE, BUT NEEDS TO BE VERIFIED BY WATCHING SERIAL */
    // this will allow for the log entries to be considered the same if they're one cm more or less than the newer reading, creating
    // a slightly "fuzzier" log in hopes of better determining when the bot is stuck
    Serial.println("");
    Serial.println("altering the log to fuzzy the readings a little");
    if (storeFRead2 == storeFRead1 + 1 || storeFRead2 == storeFRead1 - 1) { storeFRead2 = storeFRead1; }
    if (storeFRead3 == storeFRead2 + 1 || storeFRead3 == storeFRead2 - 1) { storeFRead3 = storeFRead2; }
    if (storeFRead4 == storeFRead3 + 1 || storeFRead4 == storeFRead3 - 1) { storeFRead4 = storeFRead3; }

    // announce the new readings to serial so we can see the difference
    Serial.println("");
    Serial.print("new storeFRead1: ");
    Serial.println(storeFRead1);
    Serial.print("new storeFRead2: ");
    Serial.println(storeFRead2);
    Serial.print("new storeFRead3: ");
    Serial.println(storeFRead3);
    Serial.print("new storeFRead4: ");
    Serial.println(storeFRead4);
    Serial.println("");
    /* END CODE THAT HASN'T BEEN TESTED */
    
    // reset the log timer so this logging only happens every 5 readings
    logTimer = 0;
    
    // now that we have an updated set of  readings, we'll allow the code below to analyz them. otherwise it will be skipped
    allowStuckCheck = true;
  }
 
  // see if it looks like we're no longer making forward progress, indicating we may be stuck
  if (allowStuckCheck == true && storeFRead1 == storeFRead2 && storeFRead2 == storeFRead3 && storeFRead3 == storeFRead4) {
    // see if it looks like we're in a very large open area, rather than stuck
    //if (test one of the variables above to see if it is at the highest end of the Ping))) sensor's range) {
      //Serial.println("it appears i'm in a very large room or outside);
    //} else {
      Serial.println("oops! i think i'm stuck!");

      allStop(); // stop moving
      blinkLEDs(2); // blink
      goReverse(stuckBackup); // back up
    
      // choose between turning left or right, whichever offers the farthest distance to move
      chooseDirection(noForward);
    
      // travel forward
      goForward();
      
      // I THINK RESETTING THESE VARS IS NOT NECESSARY BECAUSE THE dontAllowStuck BOOL BELOW SERVES THE SAME PURPOSE,
      // BUT ACTUALLY EFFECTIVELY. HOWEVER, I COULD BE WRONG ATM
      // reset the logging variables so a full examination is required again to determine if we're stuck
      storeFRead4 = 0;
      storeFRead3 = 0;
      storeFRead2 = 0;
      
      allowStuckCheck = false;
    //}
    
    // if we are nearing an object, stop moving...
  } else if (forwardReading <= minDistance) {
    Serial.println("i see something getting close!");

    allStop(); // stop moving
    blinkLEDs(2); // blink
    goReverse(flinchDuration); // back up

    chooseDirection(noForward); // choose a new direction; left or right only
    
    goForward(); // travel forward

    // see if it's time to sleep yet
  } else if (sleepTimer >= 900) {
    // go to sleep roughly every five minutes (900 seconds)
    /* (I put this inside an 'else if' in order to avoid the bot sleeping immediately after detecting that it's stuck or 
       too close to an object. It will catch the next time around, considering neither of the other two conditions are met) */
    stopAndSleep(); // stop and sleep

    sleepTimer = 0; // reset the sleep timer variable

    chooseDirection(yesForward); // choose a new direction; left, right, or forward
    
    goForward(); // travel forward    
    // see if it's time to sleep yet
  } else if (danceTimer >= 500) {
    // dance every 1000 times through the loop
    /* (I put this inside an 'else if' in order to avoid the bot danceing immediately after detecting that it's stuck or 
       too close to an object. It will catch the next time around, considering neither of the other two conditions are met) */
    allStop();
    
    Serial.println("i think it's time to DANCE!");
    
    dance(); // dance

    danceTimer = 0; // reset the dance timer variable

    chooseDirection(yesForward); // choose a new direction; left, right, or forward
    
    goForward(); // travel forward    
  }
  
  // wait 3/10 of a second so the Ping))) sensor gets polled 3x/sec when driving forward.
  // (this delay combined with the 100 millisecond delay taken immediately after the forward reading
  // combine to make 333 milliseconds)
  delay(233);
}


/*
  FUNCTIONS:
    chooseDirection(int)           // Tested
    stopAndSleep()                 // Tested
    dance()                        // Tested
    readPingSensor()               // Tested
    alternatingLEDs(int)           // Tested
    snoreLEDs(int)                 // Tested
    blinkLEDs(int)                 // Tested
    goForward()                    // Tested
    goReverse(int)                 // Tested
    turnLeft(int)                  // Tested
    turnRight(int)                 // Tested
    allStop()                      // Tested
*/
  

void chooseDirection(int considerForwardDirection) {
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
  
  // turn Ping))) sensor to look right and then take a reading
  headTurner.write(right);
  delay(650);
  rightReading = readPingSensor();
  Serial.print("right reading: ");
  Serial.println(rightReading);
  delay(250);

  if (forwardReading <= minDistance && leftReading <= minDistance && rightReading <= minDistance) {

    if (leftReading > rightReading) {
      turnLeft(defaultTurn);
    } else if (leftReading < rightReading) {
      turnRight(defaultTurn);
    } else if (leftReading == rightReading) {
      if (switchTurn == false) {
        Serial.println("  right and left readings are the same; going right this time");
        turnRight(defaultTurn);
      } else {
        Serial.println("  right and left readings are the same; going left this time");
        turnLeft(defaultTurn);
      }
      switchTurn = !switchTurn;
    }

    while (forwardReading <= minDistance && leftReading <= minDistance && rightReading <= minDistance ){
      
      // keep track of when to, and then play, the 'confusion' LED animation after multiple unsuccessful attempts
      // to turn in a direction that offers enough space to start moving
      counterToConfusion++;
      if (counterToConfusion == 3) {
        headTurner.write(forward);
        delay(500);
        alternatingLEDs(5);
        counterToConfusion = 0;
      }
      
      // turn Ping))) sensor to look forward and then take a reading
      headTurner.write(forward);
      delay(500);
      forwardReading = readPingSensor();
      Serial.print("*forward reading: ");
      Serial.println(forwardReading);
      delay(250);
      
      // turn Ping))) sensor to look left and then take a reading
      headTurner.write(left);
      delay(500);
      leftReading = readPingSensor();
      Serial.print("*left reading: ");
      Serial.println(leftReading);
      delay(250);
        
      // turn Ping))) sensor to look right and then take a reading
      headTurner.write(right);
      delay(650);
      rightReading = readPingSensor();
      Serial.print("*right reading: ");
      Serial.println(rightReading);
      delay(250);
  
      // compare the 'forward' and 'left' readings to see which direction offers more distance to travel
      if (forwardReading >= leftReading) {
        directionToGo = 0;
        Serial.println("* determining i'd rather go forward than left");
      } else {
        directionToGo = 1;
        Serial.println("* determining i'd rather go left than forward");
      }
  
      // compare the 'right' reading to the winner of the previous comparison to see which direction we should go
      if (directionToGo == 0 && rightReading > forwardReading) {
        Serial.println("* determining i should go right instead of forward");
        turnRight(defaultTurn);
        if (rightReading > minDistance) { break; }
      } else if (directionToGo == 1 && rightReading > leftReading) {
        Serial.println("* determining i should go right instead of left");
        turnRight(defaultTurn);
        if (rightReading > minDistance) { break; }
      } else if (directionToGo == 1 && rightReading < leftReading) {
        Serial.println("* determining i should go left instead of right");
        turnLeft(defaultTurn);
        if (leftReading > minDistance) { break; }
      } else if (directionToGo == 1 && rightReading == leftReading) {
        if (switchTurn == false) {
          Serial.println("* right and left readings are the same; going right this time");
          turnRight(defaultTurn);
        } else {
          Serial.println("* right and left readings are the same; going left this time");
          turnLeft(defaultTurn);
        }
        switchTurn = !switchTurn;
        if (leftReading > minDistance) { break; }
      } else if (directionToGo == 0 && rightReading <= forwardReading && leftReading <= forwardReading) {
        if (forwardReading > minDistance) {
          break;
        } else {
          if (switchTurn == false) {
            Serial.println("* forward reading was the largest, but i have to turn; going right this time");
            turnRight(defaultTurn);
          } else {
            Serial.println("* forward reading was the largest, but i have to turn; going left this time");
            turnLeft(defaultTurn);
          }
          switchTurn = !switchTurn;
        }
      }
    }
  } else {

    // if the function was called with 'noForward' (aka 0), choose between left and right, ignoring forward
    if (considerForwardDirection == 0) {
      // compare the 'left' and 'right' readings to see which direction offers more distance to travel.
      // we ignore 'forward' here because it's very unsatisfying seeing the bot choose to go forward after
      // having just stopped because it detected an obsticle
      if (leftReading > rightReading) {
        Serial.println("  determining i'd rather go left than right");
        turnLeft(defaultTurn);
      } else if (leftReading < rightReading) {
        Serial.println("  determining i'd rather go right than left");
        turnRight(defaultTurn);
      } else if (leftReading == rightReading) {
        if (switchTurn == false) {
          Serial.println("  right and left readings are the same; going right this time");
          turnRight(defaultTurn);
        } else {
          Serial.println("  right and left readings are the same; going left this time");
          turnLeft(defaultTurn);
        }
        switchTurn = !switchTurn;
      }
      // if the function was called with 'yesForward' (aka 1), consider forward when choosing which direction to next travel
    } else if (considerForwardDirection == 1) {
      // compare the 'forward' and 'left' readings to see which direction offers more distance to travel
      if (forwardReading >= leftReading) {
        directionToGo = 0;
        Serial.println("  determining i'd rather go forward than left");
      } else {
        directionToGo = 1;
        Serial.println("  determining i'd rather go left than forward");
      }
    
      // compare the 'right' reading to the winner of the previous comparison to see which direction we should go
      if (directionToGo == 0 && rightReading > forwardReading) {
        Serial.println("  determining i should go right instead of forward");
        turnRight(defaultTurn);
      } else if (directionToGo == 1 && rightReading > leftReading) {
        Serial.println("  determining i should go right instead of left");
        turnRight(defaultTurn);
      } else if (directionToGo == 1 && rightReading == leftReading) {
        if (switchTurn == false) {
          Serial.println("  right and left readings are the same; going right this time");
          turnRight(defaultTurn);
        } else {
          Serial.println("  right and left readings are the same; going left this time");
          turnLeft(defaultTurn);
        }
        switchTurn = !switchTurn;
      }
    }
  }
 
  // look forward again in preparation for moving forward again
  headTurner.write(forward);
  delay(250);
}
          

void stopAndSleep() {
  // announce over serial that it's time to sleep
  Serial.println("getting sleepy. think i'll take a nap right here");
  
  // stop moving forward
  allStop();
  delay(750);
  
  // fade the antennae LEDs to indicate sleepiness
  for(int fadeValue = defaultBrightness; fadeValue >= 0; fadeValue -= 1) {
    analogWrite(leftAntennaeLED, fadeValue);
    analogWrite(rightAntennaeLED, fadeValue);
    delay(75);
  }
  delay(1000);

  // choose a direction, left or right, and spin in place like a puppy about to lay down
  if (switchTurn == false){
    turnRight(sleepTurn);
  } else {
    turnLeft(sleepTurn);
  }
  
  // set this bool so the next time the bot will turn the other direction
  switchTurn = !switchTurn;
  
  // orient the head forward
  headTurner.write(forward);
  delay(1000);

  snoreLEDs(10);
  
  // fade the LEDs back on quickly, like the bot is waking up
  for(int fadeValue = 0 ; fadeValue <= defaultBrightness; fadeValue +=2) {
    analogWrite(leftAntennaeLED, fadeValue);
    analogWrite(rightAntennaeLED, fadeValue);
    delay(20);
  }
  delay(1000);

  blinkLEDs(2);
  
  delay(500);
}


void dance() {
  // look left twice, then right twice, each time turning off the opposite LED
  for (int n = 0; n < 2; n++) {
    headTurner.write(left);
    analogWrite(rightAntennaeLED, 0);
    delay(400);
    headTurner.write(forward);
    analogWrite(rightAntennaeLED, defaultBrightness);
    delay(400);
  }
  for (int n = 0; n < 2; n++) {
    headTurner.write(right);
    analogWrite(leftAntennaeLED, 0);
    delay(400);
    headTurner.write(forward);
    analogWrite(leftAntennaeLED, defaultBrightness);
    delay(400);
  }

  // do the same as above, but also turn the bot's body along with the head movements
  for (int n = 0; n < 2; n++) {
    headTurner.write(left);
    analogWrite(rightAntennaeLED, 0);
    motor1.run(BACKWARD);
    motor2.run(FORWARD);
    delay(400);
    motor1.run(RELEASE);
    motor2.run(RELEASE);
    headTurner.write(forward);
    analogWrite(rightAntennaeLED, defaultBrightness);
    motor1.run(FORWARD);
    motor2.run(BACKWARD);
    delay(400);
    motor1.run(RELEASE);
    motor2.run(RELEASE);
  }
  for (int n = 0; n < 2; n++) {
    headTurner.write(right);
    analogWrite(leftAntennaeLED, 0);
    motor1.run(FORWARD);
    motor2.run(BACKWARD);
    delay(400);
    motor1.run(RELEASE);
    motor2.run(RELEASE);
    headTurner.write(forward);
    analogWrite(leftAntennaeLED, defaultBrightness);
    motor1.run(BACKWARD);
    motor2.run(FORWARD);
    delay(400);
    motor1.run(RELEASE);
    motor2.run(RELEASE);
  }

  delay(400);
  
  // spin around
  headTurner.write(left);
  analogWrite(rightAntennaeLED, 0);
  motor1.run(BACKWARD);
  motor2.run(FORWARD);
  delay(1500);
  motor1.run(RELEASE);
  motor2.run(RELEASE);
  headTurner.write(forward);
  analogWrite(rightAntennaeLED, defaultBrightness);

  // repeat the second loop (head and body turns)
  // do the same as above, but also turn the bot's body along with the head movements
  for (int n = 0; n < 2; n++) {
    headTurner.write(left);
    analogWrite(rightAntennaeLED, 0);
    motor1.run(BACKWARD);
    motor2.run(FORWARD);
    delay(400);
    motor1.run(RELEASE);
    motor2.run(RELEASE);
    headTurner.write(forward);
    analogWrite(rightAntennaeLED, defaultBrightness);
    motor1.run(FORWARD);
    motor2.run(BACKWARD);
    delay(400);
    motor1.run(RELEASE);
    motor2.run(RELEASE);
  }
  for (int n = 0; n < 2; n++) {
    headTurner.write(right);
    analogWrite(leftAntennaeLED, 0);
    motor1.run(FORWARD);
    motor2.run(BACKWARD);
    delay(400);
    motor1.run(RELEASE);
    motor2.run(RELEASE);
    headTurner.write(forward);
    analogWrite(leftAntennaeLED, defaultBrightness);
    motor1.run(BACKWARD);
    motor2.run(FORWARD);
    delay(400);
    motor1.run(RELEASE);
    motor2.run(RELEASE);
  }
  
  // spin back around the other direction
  headTurner.write(right);
  analogWrite(leftAntennaeLED, 0);
  motor1.run(FORWARD);
  motor2.run(BACKWARD);
  delay(1500);
  motor1.run(RELEASE);
  motor2.run(RELEASE);
  headTurner.write(forward);
  analogWrite(leftAntennaeLED, defaultBrightness);
  
  // pause, then blink, then pause slightly before function ends
  delay(1000);
  blinkLEDs(2);
  delay(500);
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


void alternatingLEDs(int numFlashes) {
  Serial.println("flashing my antennae lights");
  for (int i = 0; i < numFlashes; i++) {
    for(int fadeValue = 5; fadeValue <= 255; fadeValue +=5) {  // left brightening, right dimming
      analogWrite(leftAntennaeLED, fadeValue);
      analogWrite(rightAntennaeLED, 260 - fadeValue);
      delay(10);
    }
    for(int fadeValue = 5; fadeValue <= 255; fadeValue +=5) {  // left dimming, right brightening
      analogWrite(leftAntennaeLED, 260 - fadeValue);
      analogWrite(rightAntennaeLED, fadeValue);
      delay(10);
    }
  }
  digitalWrite(leftAntennaeLED, LOW);
  digitalWrite(rightAntennaeLED, LOW);
  delay(200);
  analogWrite(leftAntennaeLED, defaultBrightness);
  analogWrite(rightAntennaeLED, defaultBrightness);
}


void snoreLEDs(int numSnores) {  // "sleep-breathe" the LEDs like a mac
  for (int i = 0; i < numSnores; i++) {
    for(int fadeValue = 0 ; fadeValue <= 15; fadeValue +=1) {  // on
      analogWrite(leftAntennaeLED, fadeValue);
      analogWrite(rightAntennaeLED, fadeValue);
      delay(75);
    }
    for(int fadeValue = 15 ; fadeValue >= 0; fadeValue -=1) {  // off
      analogWrite(leftAntennaeLED, fadeValue);
      analogWrite(rightAntennaeLED, fadeValue);
      delay(75);
    }
    delay(1500);
  }
}


void blinkLEDs(int numBlinks) {
  Serial.println("blinking");
  for (int i = 0; i < numBlinks; i++) {
    analogWrite(leftAntennaeLED, 0);
    analogWrite(rightAntennaeLED, 0);
    delay(100);
    analogWrite(leftAntennaeLED, defaultBrightness);
    analogWrite(rightAntennaeLED, defaultBrightness);
    delay(100);
  }
}


void goForward() {
  Serial.println("driving forward");
  motor1.run(FORWARD);
  motor2.run(FORWARD);
}


void goReverse(int backUpDuration) {
  Serial.println("backing up a little bit");
  motor1.run(BACKWARD);
  motor2.run(BACKWARD);
  delay(backUpDuration);
  motor1.run(RELEASE);
  motor2.run(RELEASE);
  delay(500);
}


void turnLeft(int turnDuration) {
  headTurner.write(left);   // look left
  delay(300);               // give servo (head) time to turn before beginning turning the bot's body
  Serial.println("turning left");
  // turn left
  motor1.run(BACKWARD);
  motor2.run(FORWARD);
  delay(turnDuration);
  motor1.run(RELEASE);
  motor2.run(RELEASE);
  delay(100);
}


void turnRight(int turnDuration) {
  headTurner.write(right);   // look right
  delay(300);                // give servo (head) time to turn before beginning turning the bot's body
  Serial.println("turning right");
  // turn right
  motor1.run(FORWARD);
  motor2.run(BACKWARD);
  delay(turnDuration);
  motor1.run(RELEASE);
  motor2.run(RELEASE);
  delay(100);
}


void allStop() {
  Serial.println("ALL STOP!");  
  motor1.run(RELEASE);
  motor2.run(RELEASE);
  delay(200);
}

