int LED2 = 2;
int LED3 = 3;

void setup()
{
  pinMode(LED2, OUTPUT);
  pinMode(LED3, OUTPUT);
  Serial.begin(9600);
}

void loop()

{
   int distance = analogRead(0);
    Serial.println(distance);
   if ( distance > 200 )
   {
      digitalWrite(LED2,LOW);
      digitalWrite(LED3,HIGH);
   }
   else
   {
     digitalWrite(LED2,HIGH);
     digitalWrite(LED3,LOW);
   }
   delay(300);
} 




