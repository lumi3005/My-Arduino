#define RIGHT_CTRL_1 5
#define RIGHT_CTRL_2 6
#define RIGHT_CTRL_3 7

#define LEFT_CTRL_1 11
#define LEFT_CTRL_2 12
#define LEFT_CTRL_3 13

void setup()
{
 pinMode(RIGHT_CTRL_2, OUTPUT);
 pinMode(RIGHT_CTRL_3, OUTPUT);
 pinMode(LEFT_CTRL_2, OUTPUT);
 pinMode(LEFT_CTRL_3, OUTPUT);
}

void loop()
{
  digitalWrite(RIGHT_CTRL_2, 0);
  digitalWrite(RIGHT_CTRL_3, 1);
  analogWrite(RIGHT_CTRL_1, 128);
  digitalWrite(LEFT_CTRL_2, 0);
  digitalWrite(LEFT_CTRL_3, 1);
  analogWrite(LEFT_CTRL_1, 128);
}

