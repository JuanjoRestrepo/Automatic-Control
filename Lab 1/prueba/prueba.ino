// include the QUBE Servo 2 library
#include "QUBEServo2.h"

// include the SPI library and the math library
#include <SPI.h>
#include <math.h>

bool startup = true;  // true the first time the sketch is run after the Arduino power is cycled or the reset pushbutton is pressed

unsigned long previousMicros = 0;  // used to store the last time the SPI data was written
const long sampleTime = 9300; //2470;  // set the sample time (the interval between SPI transactions) to 1000us = 1ms (90000 - 45000)
unsigned long microsOld = 0;

// set pin 10 as the slave select for the Quanser QUBE
// (Note that if a different pin is used for the slave select, pin 10 should be set as
// an output to prevent accidentally putting the Arduino UNO into slave mode.)
const int slaveSelectPin = 10;

// initialize the SPI data to be written
byte mode = 1;                      // normal mode = 1
byte writeMask = B00011111;         // Bxxxxxx11 to enable the motor, Bxxx111xx to enable the LEDs, Bx11xxxxx to enable writes to the encoders
byte LEDRedMSB = 0;                 // red LED command MSB
byte LEDRedLSB = 0;                 // red LED command LSB
byte LEDGreenMSB = 0;               // green LED command MSB
byte LEDGreenLSB = 0;               // green LED command LSB
byte LEDBlueMSB = 0;                // blue LED command MSB
byte LEDBlueLSB = 0;                // blue LED command LSB
byte encoder0ByteSet[3] = {0, 0, 0}; // encoder0 is set to this value only when writes are enabled with writeMask
byte encoder1ByteSet[3] = {0, 0, 0}; // encoder1 is set to this value only when writes are enabled with writeMask
byte motorMSB = 0x80;               // motor command MSB must be B1xxxxxxx to enable the amplifier
byte motorLSB = 0;                  // motor command LSB

// initialize the SPI data to be read
byte moduleIDMSB = 0;               // module ID MSB (module ID for the QUBE Servo is 777 decimal)
byte moduleIDLSB = 0;               // module ID LSB
byte encoder0Byte[3] = {0, 0, 0};   // arm encoder counts
byte encoder1Byte[3] = {0, 0, 0};   // pendulum encoder counts
byte tach0Byte[3] = {0, 0, 0};      // arm tachometer
byte moduleStatus = 0;              // module status (the QUBE Servo sends status = 0 when there are no errors)
byte currentSenseMSB = 0;           // motor current sense MSB
byte currentSenseLSB = 0;           // motor current sense LSB

// global variables for LED intensity (999 is maximum intensity, 0 is off)
int LEDRed = 0;
int LEDGreen = 0;
int LEDBlue = 0;

//Setup serial builder
Display displayData;

float mVold = 0;
float Thetaold = 0;
float T = 0.0093; //0.00247;//Periodo de muestreo (0.09 - 0.045)

void setup() {
  // set the slaveSelectPin as an output
  pinMode (slaveSelectPin, OUTPUT);

  // initialize SPI
  SPI.begin();

  // initialize serial communication at 115200 baud
  // (Note that 115200 baud must be selected from the drop-down list on the Arduino
  // Serial Monitor for the data to be displayed properly.)
  Serial.begin(9600);

}


long tachCounts = 0;
long motorVelocity = 0;
float motorVoltage = 2; //Voltaje del motor
float theta = 0; //Posición del motor
float R = 0;
float R1 = M_PI / 6;
float Kp = 0;
float Error = 0;
float ErrorOld = 0;
float UprimOld = 0;
float Uprim = 0;
float ErrorSecOld = 0;
float ErrorSec = 0;
float Up = 0;
float Ui = 0;
float Ud = 0;
float UiOld = 0;
float UdOld = 0;

void loop() {
  // put your main code here, to run repeatedly:

  // if the difference between the current time and the last time an SPI transaction
  // occurred is greater than the sample time, start a new SPI transaction
  unsigned long currentMicros = micros();
  unsigned long CambioRef = 10000000;

  // initialize the SPI bus using the defined speed, data order and data mode
  SPI.beginTransaction(SPISettings(1000000, MSBFIRST, SPI_MODE2));
  // take the slave select pin low to select the device
  digitalWrite(slaveSelectPin, LOW);

  // send and receive the data via SPI (except for the motor command, which is sent after the custom code)
  moduleIDMSB = SPI.transfer(mode);                    // read the module ID MSB, send the mode
  moduleIDLSB = SPI.transfer(0);                       // read the module ID LSB
  encoder0Byte[2] = SPI.transfer(writeMask);           // read encoder0 byte 2, send the write mask
  encoder0Byte[1] = SPI.transfer(LEDRedMSB);           // read encoder0 byte 1, send the red LED MSB
  encoder0Byte[0] = SPI.transfer(LEDRedLSB);           // read encoder0 byte 0, send the red LED LSB
  encoder1Byte[2] = SPI.transfer(LEDGreenMSB);         // read encoder1 byte 2, send the green LED MSB
  encoder1Byte[1] = SPI.transfer(LEDGreenLSB);         // read encoder1 byte 1, send the green LED LSB
  encoder1Byte[0] = SPI.transfer(LEDBlueMSB);          // read encoder1 byte 0, send the blue LED MSB
  tach0Byte[2] = SPI.transfer(LEDBlueLSB);             // read tachometer0 byte 2, send the blue LED LSB
  tach0Byte[1] = SPI.transfer(encoder0ByteSet[2]);     // read tachometer0 byte 1, send encoder0 byte 2
  tach0Byte[0] = SPI.transfer(encoder0ByteSet[1]);     // read tachometer0 byte 0, send encoder0 byte 1
  moduleStatus = SPI.transfer(encoder0ByteSet[0]);     // read the status, send encoder0 byte 0
  currentSenseMSB = SPI.transfer(encoder1ByteSet[2]);  // read the current sense MSB, send encoder1 byte 2
  currentSenseLSB = SPI.transfer(encoder1ByteSet[1]);  // read the current sense LSB, send encoder1 byte 1
  SPI.transfer(encoder1ByteSet[0]);                    // send encoder1 byte 0

  // combine the received bytes to assemble the sensor values

  /*Module ID*/
  int moduleID = (moduleIDMSB << 8) | moduleIDLSB;

  /*Motor Encoder Counts*/
  long encoder0 = ((long)encoder0Byte[2] << 16) | ((long)encoder0Byte[1] << 8) | encoder0Byte[0];
  if (encoder0 & 0x00800000) {
    encoder0 = encoder0 | 0xFF000000;
  }
  // convert the arm encoder counts to angle theta in radians
  float theta = (float)encoder0 * (-2.0 * M_PI / 2048); //Posición del motor

  /*Pendulum Encoder Counts*/
  long encoder1 = ((long)encoder1Byte[2] << 16) | ((long)encoder1Byte[1] << 8) | encoder1Byte[0];
  if (encoder1 & 0x00800000) {
    encoder1 = encoder1 | 0xFF000000;
  }
  // wrap the pendulum encoder counts when the pendulum is rotated more than 360 degrees
  encoder1 = encoder1 % 2048;
  if (encoder1 < 0) {
    encoder1 = 2048 + encoder1;
  }
  // convert the pendulum encoder counts to angle alpha in radians
  float alpha = (float)encoder1 * (2.0 * M_PI / 2048) - M_PI; //Angulo

  /*Current Sense Value*/
  float currentSense = (currentSenseMSB << 8) | currentSenseLSB;

  // Medición de velocidad
  long tach = ((long)tach0Byte[2] << 16) | ((long)tach0Byte[1] << 8) | tach0Byte[0];
  //most significant bit represents the direction of rotation with a value of uno indicating clockwise rotation
  if (tach & 0x00800000) {
    tach = tach & 0x7FFFFF;
    tachCounts = 4 / (tach * 0.000000025);
  }
  else {
    tachCounts =  -4 / (tach * 0.000000025);
  }

  motorVelocity = -2 * M_PI * tachCounts / 2048;

  /*Start of Custom Code*/

  /*Turn on motor*/

  /*    int incomingByte = 0; // for incoming serial data

      // send data only when you receive data:
      if (Serial.available() > 0) {
      // read the incoming byte:
        R = Serial.read();
      }

      // say what you got:
    //   Serial.print("I received: ");
      Serial.println(incomingByte, DEC);

  */
  float Kp = 1.5;
  float Ki = 0.0;
  float Kd = 0.0; //ok

  Error = R - theta; // motorVelocity;

  // Implementación del controlador

  //motorVoltage = Up + Ui + Ud; //Ejemplo


  if (motorVoltage > 10) {
    motorVoltage = 10;
  }
  if (motorVoltage < -10) {
    motorVoltage = -10;
  }

  Serial.print("Tiempo: ");
  Serial.print((currentMicros) / 1000);
  Serial.print(",");
  Serial.print("R: ");
  Serial.print(R);
  Serial.print(",");
  /*  Serial.print((currentMicros-microsOld)/1000);
      Serial.print(0.98*R);
      Serial.print(",");
      Serial.print(1.02*R);
      Serial.print(",");*/
  Serial.print("Posicion: ");
  Serial.print(theta);
  Serial.print(",");
  Serial.print("Velocidad: ");
  Serial.print(motorVelocity);
  Serial.print(",");
  Serial.print("Voltaje: ");
  Serial.println(motorVoltage);

  microsOld = currentMicros;
  /*Set the LED intensities (999 is maximum intensity, 0 is off)*/
  //LEDRed = 999;
  //LEDGreen = 999;
  //LEDBlue = 999;

  /*End of Custom Code*/

  // convert the LED intensities to MSB and LSB
  LEDRedMSB = (byte)(LEDRed >> 8);
  LEDRedLSB = (byte)(LEDRed & 0x00FF);
  LEDGreenMSB = (byte)(LEDGreen >> 8);
  LEDGreenLSB = (byte)(LEDGreen & 0x00FF);
  LEDBlueMSB = (byte)(LEDBlue >> 8);
  LEDBlueLSB = (byte)(LEDBlue & 0x00FF);

  // convert the analog value to the PWM duty cycle that will produce the same average voltage
  float motorPWM = -motorVoltage * (625.0 / 15.0);

  int motor = (int)motorPWM;  // convert float to int (2 bytes)
  motor = motor | 0x8000;  // motor command MSB must be B1xxxxxxx to enable the amplifier
  motorMSB = (byte)(motor >> 8);
  motorLSB = (byte)(motor & 0x00FF);

  // send the motor data via SPI
  SPI.transfer(motorMSB);
  SPI.transfer(motorLSB);

  // take the slave select pin high to de-select the device
  digitalWrite(slaveSelectPin, HIGH);
  SPI.endTransaction();

  displayData.buildString(theta, alpha, currentSense, moduleID, moduleStatus);
}
