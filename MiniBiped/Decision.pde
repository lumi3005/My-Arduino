void Drive(){
  IRdistance=Read_Sharp_Eye();
  //Serial.print("IRdistance ");
  //Serial.println(IRdistance);
  if (IRdistance<treshold){
    Stop();
    delay(stopTime);
    Avoid();
    Forward();
  }
  Walk();
}


void Avoid(){
  int prev=0;
  dir=2;
  for (byte i=0; i<5; i++){
    Pan.write(i*45); //turn 45 degrees at a time, from 0 to 180 degrees
    delay(300);
    IRdistance=Read_Sharp_Eye();
    if (IRdistance>prev){
      dir=i;
      prev=IRdistance;
    }
  }
  Pan.write(center);
  delay(300);
  //Serial.print("dir= ");
  //Serial.println(dir, DEC);
  switch (dir){
    case 0:
      Right();
      for(byte k=0;k<turn90;k++)
      {
         Walk();
      }   
      Stop();
      delay(stopTime);
      break;
    case 1:
      Right();
      for(byte k=0;k<turn45;k++)
      {
         Walk();
      }   
      Stop();
      delay(stopTime);
      break;
    case 2:
      //Forward();
      break;
    case 3:
      Left();
      for(byte k=0;k<turn45;k++)
      {
         Walk();
      }   
      Stop();
      delay(stopTime);
      break;
    case 4:
      Left();
      for(byte k=0;k<turn90;k++)
      {
         Walk();
      }   
      Stop();
      delay(stopTime);
      break;
  }
}  

void square()
{
  //1
      Right();
   for(byte k=0;k<3;k++)
   {
      Walk();
   }  
      Stop();
      delay(stopTime);
      Forward();
   for(byte k=0;k<3;k++)
   {
      Walk();
   }   
      Stop();
      delay(stopTime);
  //2
      Right();
   for(byte k=0;k<3;k++)
   {
      Walk();
   }  
      Stop();
      delay(stopTime);
      Forward();
   for(byte k=0;k<3;k++)
   {
      Walk();
   }  
      Stop();
      delay(stopTime);
  //3
      Right();
   for(byte k=0;k<3;k++)
   {
      Walk();
   }   
      Stop();
      delay(stopTime);
      Forward();
   for(byte k=0;k<3;k++)
   {
      Walk();
   } 
      Stop();
      delay(stopTime);
  //4
      Right();
   for(byte k=0;k<3;k++)
   {
      Walk();
   } 
      Stop();
      delay(stopTime);
      Forward();
   for(byte k=0;k<3;k++)
   {
      Walk();
   } 
      Stop();
      delay(stopTime);
}

void Kick()
{
  int LK=0;
  int RK=1;
  Lkp=Lkc-200*LK;
  Rkp=Rkc+200*RK;
  Servopos();
  delay(100);
  Lkp=Lkc+(400*LK)-(500*RK);
  Lhp=Lhc+(500*LK)-(500*RK);
  Rkp=Rkc+(500*LK)-(400*RK);
  Rhp=Rhc+(500*LK)-(500*RK);
  Servopos();
  delay(500);
  Lkp=Lkc;
  Rkp=Rkc;
  Lhp=Lhc;
  Rhp=Rhc;
  Servopos();
}

