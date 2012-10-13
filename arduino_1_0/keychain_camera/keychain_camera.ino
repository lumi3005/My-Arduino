// 808 keychain camera control: motion detector wakes up arduino, it switches on camera takes a picture, switches off, sleeps
#include <avr/sleep.h>

int wakePin = 2;                 // pin used for waking up
int onPin = 13;                 // pin used to switch cam on
int snapPin = 12;                 // pin used to take a pic

int sleepStatus = 0;             // variable to store a request for sleep
int count = 0;                   // counter

void wakeUpNow()        // here the interrupt is handled after wakeup
{
}

void setup()
{

  pinMode(wakePin, INPUT);
  pinMode(onPin, OUTPUT);
  pinMode(snapPin, OUTPUT);
  Serial.begin(9600);
  delay(5000);
  attachInterrupt(0, wakeUpNow, LOW); // use interrupt 0 (pin 2) and run function
                                      // wakeUpNow when pin 2 gets LOW
}

void sleepNow()         // here we put the arduino to sleep
{
DDRB = B00000000;  // sets Arduino pins  as inputs
DDRD = B00000000;  // sets Arduino pins  as inputs
    set_sleep_mode(SLEEP_MODE_PWR_DOWN);   // sleep mode is set here

    sleep_enable();          // enables the sleep bit in the mcucr register
                             // so sleep is possible. just a safety pin

    attachInterrupt(0,wakeUpNow, LOW); // use interrupt 0 (pin 2) and run function
                                       // wakeUpNow when pin 2 gets LOW

    sleep_mode();            // here the device is actually put to sleep!!
                             // THE PROGRAM CONTINUES FROM HERE AFTER WAKING UP

    sleep_disable();         // first thing after waking from sleep:
                             // disable sleep...
    detachInterrupt(0);      // disables interrupt 0 on pin 2 so the
                             // wakeUpNow code will not be executed
                             // during normal running time.
  pinMode(onPin, OUTPUT);
  pinMode(snapPin, OUTPUT);

}

void loop()
{
  // display information about the counter
  Serial.println("Awake");
// if (pir == 1)
  Serial.println("Switch On");
  digitalWrite(onPin, 1);
  delay(2000);
  digitalWrite(onPin, 0);
  delay(1000);

  Serial.println("Take pic");
  digitalWrite(snapPin, 1);
  delay(500);
  digitalWrite(snapPin, 0);
  delay(2000);

  Serial.println("Switch off");
  digitalWrite(onPin, 1);
  delay(3000);
  digitalWrite(onPin, 0);
  delay(8000);

  Serial.println("Entering Sleep mode");
  delay(100);     // this delay is needed, the sleep
                      //function will provoke a Serial error otherwise!!
 sleepNow();
}


