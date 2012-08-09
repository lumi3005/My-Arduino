#include <SPI.h>

byte mac[] = {  0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };     // your desired mac address!
byte ip[] = { 192,168,178,5 };                            // the ip address of your arduino in you intranet!
byte gateway[] = { 192, 168, 178, 1 };                    // the gateway address of your dsl router!
byte subnet[]  = { 255, 255, 255, 0 };                    // corresponding subnet mask
byte server[] = { aaa,bbb,ccc,ddd };                         // ip of remote host
Client client(server, 80);
char host[] = "www.yourcooldomain.org";	                  // domain name of remote host, neccessary cause of shared hosting
char c;
String readString;
boolean eot = false;

void setup()
{
  Serial.begin(9600);			
  Serial.println();
  Serial.println("# Arduino web client");
  Serial.println("# Remote server IP: aaa,bbb,ccc,ddd");
  Serial.println("# Remote host adress: www.yourcooldomain.org");
  Ethernet.begin(mac, ip, gateway, subnet);  
  delay(5000);				                  // wait, until LAN shield ist up
}

void loop()
{
  //arduino reads string to be transmitted to remote host 
  Serial.println("# input for example 'GET /index.php?0=255&1=30  HTTP/1.1'");  
  Serial.println("# >");
  readString=""; 
  
  eot = false;
  while (eot == false) {
      while (Serial.available()) {
        char c = Serial.read();  //gets one byte from serial buffer
        Serial.print(c);
        if (c == 0x0d){
          eot = true;
          break;
        }
        readString += c;
      }  
  }
  Serial.println();    


  //arduino transmits data to remote host
  if (client.connect())  // make connection to host
  {
    Serial.println("# connected...uploading...");
    client.println(readString);
    client.print("Host: ");
    client.println(host);
    client.println();
    Serial.println("# done");
  }
  else
  {
    Serial.println("# no connection");
  } 
  delay(900);


  // arduino reading answer from remoto host and sends it out on serial interface
  Serial.println();
  Serial.println("# remote server says:");
  while (client.connected()){
    if (client.available()) {
      char c = client.read();
      Serial.print(c);
    }    
  }
  //answer of remote host finished
  client.stop();  
  client.flush();  
  delay(1000);
  Serial.println();
  Serial.println("# disconnecting.");  
}
