#define IRsensorPin 9
#define IRledPin 10
#define D13ledPin 13

void IR38Write() {
  //for(int i = 0; i <= 384; i++) {
    digitalWrite(IRledPin, HIGH);
    delayMicroseconds(13);
    digitalWrite(IRledPin, LOW);
    delayMicroseconds(13);
  //}
}

void setup(){
  pinMode(IRledPin, OUTPUT);
  digitalWrite(IRledPin, LOW);
  pinMode(D13ledPin, OUTPUT);
  digitalWrite(D13ledPin, LOW);
}

void loop(){
  IR38Write();
  if (digitalRead(IRsensorPin)==LOW){
    digitalWrite(D13ledPin, HIGH);
  } else {
    digitalWrite(D13ledPin, LOW);
  }
  delay(100);
}
