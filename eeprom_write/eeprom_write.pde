/*
 * EEPROM Write
 *
 * Stores values read from analog input 0 into the EEPROM.
 * These values will stay in the EEPROM when the board is
 * turned off and may be retrieved later by another sketch.
 */

#include <EEPROM.h>

// the current address in the EEPROM (i.e. which byte
// we're going to write to next)
int addr = 0;
int val = 5;
int LED = 7;
void setup()
{
    Serial.begin(9600);
}

void loop()
{
  Serial.println(val);
  // write the value to the appropriate byte of the EEPROM.
  // these values will remain there when the board is
  // turned off.
  if (addr > 2)
  {
    Serial.println("Ende");
    digitalWrite(LED, HIGH);
    delay(5000);
  }    
  else
  {
    val = val + 1;
    EEPROM.write(addr, val);
    digitalWrite(val, HIGH);
    delay(500);
    digitalWrite(val, LOW);
  }
}
