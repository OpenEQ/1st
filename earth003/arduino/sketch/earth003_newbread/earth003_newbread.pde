// sketch for new breadboard
// corresponding Android apli is earth003
//
// by kurimoto
//

//#define DEBUG-MODE
//#define ANDROID_OUT
//#define BOARD9600

#include <Wire.h>
#include <ctype.h>

#include <Max3421e.h>
#include <Usb.h>
#include <AndroidAccessory.h>

int RTCDATA[16];
#define RTCaddress 0x64 >> 1
#define inPin 8
#define BMA180add 0x40

AndroidAccessory acc("k2-garage",
                     "earth003",
                     "DemoKit Arduino Board",
                     "1.0",
                     "http://www.android.com",
                     "0000000012345678");

void setup();
void loop();


int i=0;
int j;
int k=0;
byte msg[17];
unsigned long times;

char seconds[2];
char minutes[2];
char hours[2];
char days[2];
char weekdays[2];
char moncent[2];  // month/century for akizuki RTC
char month[2]; // month for R8803 RTC
char years[2];

byte b_seconds;
byte b_minutes;
byte b_hours;
byte b_days;
byte b_weekdays;
byte b_moncent;  // month/century for akizuki RTC
byte b_month;    // month for R8803 RTC
byte b_years;

int accel_x, accel_y, accel_z;
void readAccel()
{
  int temp, temp2, result;

  temp = 0;

/*
  while(temp != 1)
  {
    Wire.beginTransmission(BMA180add);
    Wire.send(0x03);
    Wire.requestFrom(BMA180add, 1);
    while(Wire.available())
    {
        temp = Wire.receive() & 0x01;
    }
  }
  Wire.beginTransmission(BMA180add);
  Wire.send(0x02);
  Wire.requestFrom(BMA180add, 1);
  while(Wire.available())
  {
    temp |= Wire.receive();
//    temp = temp >> 2;
  }
//  Serial.print("X = ");
  Serial.print(temp,BIN);
  Serial.print(":");
  result = Wire.endTransmission();
*/


//-------------------------
// change by kurimoto
//-------------------------
  temp=0;
  temp2=0;
  while(temp != 1)
  {
#ifdef DEBUG-MODE
    Serial.println(" ");
    Serial.println("Loop1 check LSB bit (data change)");
#endif
    Wire.beginTransmission(BMA180add);
    Wire.send(0x02);
    Wire.endTransmission();
    Wire.requestFrom(BMA180add, 1);
    while(Wire.available())
    {
      temp = Wire.receive() & 0x01;
#ifdef DEBUG-MODE
      Serial.print("Loop1.1  Data(Address=0x02)=  ");
      Serial.println(temp,BIN);
#endif
    }
  }
  
  Wire.beginTransmission(BMA180add);
  Wire.send(0x03);
  Wire.endTransmission();
  Wire.requestFrom(BMA180add, 1);
  while(Wire.available()){
    temp = Wire.receive();
#ifdef DEBUG-MODE
    Serial.print("Loop2  Data(Address=0x03)= ");
    Serial.println(temp,BIN);
#endif
  }
  Wire.beginTransmission(BMA180add);
  Wire.send(0x02);
  Wire.endTransmission();
  Wire.requestFrom(BMA180add, 1);  
  while(Wire.available()){
    temp2 = Wire.receive();
#ifdef DEBUG-MODE
    Serial.print("Loop3  Data(Address=0x02)=");
    Serial.println(temp2,BIN);
#endif
  }
  temp = temp << 8;
  accel_x = (temp | (temp2 & 0b0000000011111100))>>2;  
#ifndef ANDROID_OUT
  Serial.print(accel_x);
  Serial.print(", ");
#endif

//  result = Wire.endTransmission();
  msg[0]= (byte)accel_x;

  temp = 0;
  temp2=0;
  while(temp != 1)
  {
    Wire.beginTransmission(BMA180add);
    Wire.send(0x04);
    Wire.endTransmission();
    Wire.requestFrom(BMA180add, 1);
    while(Wire.available())
    {
        temp = Wire.receive() & 0x01;
    }
  }
  
  Wire.beginTransmission(BMA180add);
  Wire.send(0x05);
  Wire.endTransmission();
  Wire.requestFrom(BMA180add, 1);

  while(Wire.available()){
    temp = Wire.receive();
  }
  Wire.beginTransmission(BMA180add);
  Wire.send(0x04);
  Wire.endTransmission();
  Wire.requestFrom(BMA180add, 1);  
  while(Wire.available()){
    temp2 = Wire.receive();
  }
  temp = temp << 8;
  accel_y = (temp | ( temp2 & 0b0000000011111100))>>2;  
#ifndef ANDROID_OUT
  Serial.print(accel_y);
  Serial.print(", ");
#endif
//  result = Wire.endTransmission();
  msg[1]= (byte) accel_y;

  temp = 0;
  temp2=0;
  while(temp != 1)
  {
    Wire.beginTransmission(BMA180add);
    Wire.send(0x06);
    Wire.endTransmission();
    Wire.requestFrom(BMA180add, 1);
    while(Wire.available())
    {
        temp = Wire.receive() & 0x01;
    }
  }
  
  Wire.beginTransmission(BMA180add);
  Wire.send(0x07);
  Wire.endTransmission();
  Wire.requestFrom(BMA180add, 1);

  while(Wire.available()){
    temp = Wire.receive();
  }
  Wire.beginTransmission(BMA180add);
  Wire.send(0x06);
  Wire.endTransmission();
  Wire.requestFrom(BMA180add, 1);  
  while(Wire.available()){
    temp2 = Wire.receive();
  }
  temp = temp << 8;
  accel_z = (temp |  (temp2  & 0b0000000011111100))>>2;  
#ifndef ANDROID_OUT
  Serial.print(accel_z);
  Serial.print(", ");
#endif
//  result = Wire.endTransmission();
msg[3]= accel_z;
}

void initBMA180()
{
  int temp, result, error;

  Wire.beginTransmission(BMA180add);
  Wire.send(0x00);
  Wire.endTransmission();
  Wire.requestFrom(BMA180add, 1);
  while(Wire.available())
  {
    temp = Wire.receive();
  }
  Serial.print("Id = ");
  Serial.println(temp);
/*  result = Wire.endTransmission();
  checkResult(result);
  if(result > 0)
  {
    error = 1;
  }
*/
  delay(10);
  if(temp == 3)
  {
    // Connect to the ctrl_reg1 register and set the ee_w bit to enable writing.
    // temporary avoid EEPROM writing as limited re-write
Wire.beginTransmission(BMA180add);
    Wire.send(0x0D);
    Wire.send(B0001);
    result = Wire.endTransmission();
    checkResult(result);
    if(result > 0)
    {
        error = 1;
    }
    delay(10);
    // Connect to the bw_tcs register and set the filtering level to 10hz.
    Wire.beginTransmission(BMA180add);
    Wire.send(0x20);
    Wire.send(B00001000);
    result = Wire.endTransmission();
    checkResult(result);
    if(result > 0)
    {
        error = 1;
    }
    delay(10);
    // Connect to the offset_lsb1 register and set the range to +- 2.
    Wire.beginTransmission(BMA180add);
    Wire.send(0x35);
    Wire.send(B0100);
    result = Wire.endTransmission();
    checkResult(result);
    if(result > 0)
    {
        error = 1;
    }
    delay(10);
  }

  if(error == 0)
  {
    Serial.print("BMA180 Init Successful");
  }
}

void checkResult(int result)
{
  if(result >= 1)
  {
    Serial.print("PROBLEM..... Result code is ");
    Serial.println(result);
  }
  else
  {
    Serial.println("Read/Write success");
  }
}

byte tran_c2b(char data)
{
  byte ret=B0;
  
  Serial.print(".");
  Serial.println(data);
  
  switch (data){
    case '0':
      ret = B00000000;
      break;
    case '1':
      ret = B00000001;
      break;
    case '2':
      ret = B00000010;
      break;
    case '3':
      ret = B00000011;
      break;
    case '4':
      ret = B00000100;
      break;
    case '5':
      ret = B00000101;
      break;
    case '6':
      ret = B00000110;
      break;
    case '7':
//    Serial.println("return B7");
      ret = B00000111;
      break;
    case '8':
      ret = B00001000;
      break;
    case '9':
      ret = B00001001;
//      Serial.println("ret 9");
      break;
//    default :
//      Serial.println("none numeric");
  }
  return(ret);   
}

void get_gps_value()
{
  int j;
  j=0;
  Serial1.flush();
  while(j<5){
    while(Serial1.available()<=5);
    if(Serial1.read()=='$' && Serial1.read()=='G' && Serial1.read()=='P'
        && Serial1.read()=='R' && Serial1.read()=='M' && Serial1.read()=='C')break;
    Serial1.flush();
    delay(100);
//    Serial.println('.');
  j++;
  }
  Serial.print("# of looping =");
  Serial.print(j); 
  while(Serial1.available() < 64) delay(1);
  Serial1.read();


/*for(i=0;i<63;i++){
    Serial.print((char)Serial1.read());
}*/

  hours[0]=(char)Serial1.read();
  hours[1]=(char)Serial1.read();
  minutes[0]=(char)Serial1.read();
  minutes[1]=(char)Serial1.read();
  seconds[0]=(char)Serial1.read();
  seconds[1]=(char)Serial1.read();
#ifdef BOARD9600
  for(i=0;i<44;i++)Serial1.read();
#else
  for(i=0;i<21;i++)Serial1.read();
#endif
  days[0]=(char)Serial1.read();
  days[1]=(char)Serial1.read();
  moncent[0] = (char)Serial1.read();
  moncent[1] = (char)Serial1.read();
  years[0] = (char)Serial1.read();
  years[1] = (char)Serial1.read();
  weekdays[0]=0;
  weekdays[1]=0;

Serial.print(hours[0]);
Serial.print(hours[1]);
Serial.print(minutes[0]);
Serial.print(minutes[1]);
Serial.print(seconds[0]);
Serial.print(seconds[1]);
Serial.print(days[0]);
Serial.print(days[1]);

/*  String stringone = String(hours[0]);
  stringone.concat(hours[1]);
  stringone.concat(minutes[0]);
  stringone.concat(minutes[1]);
  stringone.concat(seconds[0]);
  stringone.concat(seconds[1]);
  Serial.println(stringone);*/
  
  b_hours = tran_c2b(hours[0])<<4 | tran_c2b(hours[1]);
  b_minutes = tran_c2b(minutes[0])<<4 | tran_c2b(minutes[1]);
  b_seconds = tran_c2b(seconds[0])<<4 | tran_c2b(seconds[1]);
  b_days = tran_c2b(days[0])<<4 | tran_c2b(days[1]);
  b_moncent = tran_c2b(moncent[0])<<4 | tran_c2b(moncent[1]);
  b_years = tran_c2b(years[0])<<4 | tran_c2b(years[1]);
  b_weekdays = B0;
}

void set_rtc()
{
  Wire.beginTransmission(RTCaddress);
  
  // 最初の設定時のリセットビット操作
  // 2回めはいらない？
  
  Wire.send(0x0f);
  Wire.send(0x41);
  Wire.endTransmission();
  
  // 時刻設定
  Wire.beginTransmission(RTCaddress);
  Serial.println(b_seconds, BIN);
  // send address
  Wire.send(0x00);
  // set time data
  Wire.send(b_seconds);
  Serial.println(b_minutes, BIN);
  Wire.send(b_minutes);
  Wire.send(b_hours);
  Wire.send(b_weekdays);
  Wire.send(b_days);
  Wire.send(b_moncent);
  Wire.send(b_years);
  Wire.send(0x00);
  Wire.send(0x00);
  Wire.send(0x00);
  Wire.send(0x00);
  Wire.send(0x00);
  Wire.send(0x00);
  Wire.send(0x00);
  Wire.send(0x00);
  Wire.send(0x41);
  Wire.endTransmission();  
}
void setup()
{
  Serial.begin(115200);
#ifdef BOARD9600
  Serial1.begin(9600);
#else
  Serial1.begin(57600);
#endif
  delay(2000);
  
// Setup GPS module    
  Serial.println("Initializing GPS module");
  send_pmtk_packet("PMTK220,1000");
  send_pmtk_packet("PMTK314,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0");
//  send_pmtk_packet("PMTK251,57600");
  

  
// Setup Real Time Clock
  Serial.println("getting time data from GPS");
  delay(2000);
  get_gps_value();  
  Serial.println("initializeing RTC");
  Wire.begin();  // join the TWI as bus-master
  set_rtc();
  
  Serial.println("initializing BMA180");
// Setup BMA180
  initBMA180();
  delay(2000);

  Serial.println("initializing ADK");
// Setup ADK
acc.powerOn();
}

void loop()
{
  int i,k;

  Wire.beginTransmission(RTCaddress);
  Wire.send(0x10);
  Wire.endTransmission();

  Wire.requestFrom(RTCaddress,8);
              //request 16byte data from RTC
  //reading loop
  for(i=0; i<8; i++){
    while (Wire.available() == 0 ){
    }
    RTCDATA[i] = Wire.receive();
  }

    //read data from RTC unit
    
  readAccel();  

#ifndef ANDROID_OUT
  Serial.print("'");
  Serial.print(RTCDATA[7],HEX);
  Serial.print("   ");
  Serial.print(RTCDATA[6],HEX);
  Serial.print("/");
  Serial.print(RTCDATA[5],HEX);
  Serial.print("     ");

//  Serial.print(RTCDATA[4],HEX);
//  Serial.print(":");
  Serial.print(RTCDATA[3],HEX);
  Serial.print(":");
  Serial.print(RTCDATA[2],HEX);
  Serial.print("   ");
  Serial.print(RTCDATA[1],HEX);
  Serial.print(" ");
  Serial.println(RTCDATA[0],HEX);
#endif
  
/*  if (digitalRead(inPin)  == LOW){
    Wire.beginTransmission(RTCaddress);
         //send to RTC address (write mode)
    Wire.send(0x01);
         //set internal register address of RTC as 1
    Wire.send(0x03);
         //clear control2 as 0x03
    Wire.endTransmission();    
  }*/

//  delay(10);

#ifdef ANDROID_OUT

    if (acc.isConnected()) {
      msg[0] = (byte)0xAA;
      msg[1] = (byte)0x01;
      msg[2] = (byte)0xAA;
      msg[3] = (byte)(accel_x >> 8);
      msg[4] = (byte)(accel_x);
      msg[5] = (byte)(accel_y >> 8);
      msg[6] = (byte)(accel_y);
      msg[7] = (byte)(accel_z >> 8);
      msg[8] = (byte)(accel_z);
      msg[9] = (byte) RTCDATA[7]; //year
      msg[10] = (byte) RTCDATA[6]; //month
      msg[11] = (byte) RTCDATA[5]; // day
      msg[12] = (byte) RTCDATA[3]; //hour
      msg[13] = (byte) RTCDATA[2]; // min
      msg[14] = (byte) RTCDATA[1]; // sec
      msg[15] = (byte) RTCDATA[0]; // 1/100 sec
      msg[16] = (byte) 0;
//      msg[17] = (byte)0;
        acc.write(msg,17);
    }
/*        for(j=0;j<12;j++){
            Serial.print(msg[j],DEC);
        }
        Serial.print("\n");*/
        
#endif

    delay(10);

}

void send_pmtk_packet(char *p)
{
  uint8_t checksum = 0;
  Serial1.print('$');
  do {
    char c = *p++;
    if(c){
      checksum ^= (uint8_t)c;
      Serial1.print(c);
    }
    else{
      break;
    }
  }
  while(1);
  Serial1.print('*');
  Serial1.println(checksum,HEX);
}
