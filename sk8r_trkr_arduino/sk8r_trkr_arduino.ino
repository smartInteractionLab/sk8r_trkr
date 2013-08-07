/*
SK8R_TRKR sketch for Teensy 3.0 running on Arduino.
 This firmware to sense 9DOF from the MPU9150 and
 transpose it to an SD card via the SD library.
 
 This project was developed in the Smart Design Interaction Lab
 http://smartinteractionlab.com/
 by Carla Diana, Steve Faletti, and Eli Worden
 
 Created 29 July 2013
 by Steve Faletti
 
 Follow the project at https://github.com/smartInteractionLab/sk8r_trkr
 
 This data should be plotted against video of a skateboarder
 to determine the sensor pattern of various tricks.
 
 MPU9150 code based heavily on example provided by Sparkfun:
 https://github.com/sparkfun/MPU-9150_Breakout/tree/master/firmware
 // I2C device class (I2Cdev) demonstration Arduino sketch for MPU9150
 // 1/4/2013 original by Jeff Rowberg <jeff@rowberg.net> at https://github.com/jrowberg/i2cdevlib
 //          modified by Aaron Weiss <aaron@sparkfun.com>
 //
 // Changelog:
 //     2011-10-07 - initial release
 //     2013-1-4 - added raw magnetometer output
 
/* ============================================
 I2Cdev device library code is placed under the MIT license
 
 --------------------------------------
 
 SD code relies heavily on the "Datalogger" example included with Arduino.
 
 */

// Arduino Wire library is required if I2Cdev I2CDEV_ARDUINO_WIRE implementation
// is used in I2Cdev.h
#include "Wire.h"

// I2Cdev and MPU6050 must be installed as libraries, or else the .cpp/.h files
// for both classes must be in the include path of your project
#include "I2Cdev.h"
#include "MPU6050.h"

//SD library
#include <SD.h>

// debouce library
#include <Bounce.h>

// class default I2C address is 0x68
// specific I2C addresses may be passed as a parameter here
// AD0 low = 0x68 (default for InvenSense evaluation board)
// AD0 high = 0x69
MPU6050 accelgyro;

//int16_t ax, ay, az;
//int16_t gx, gy, gz;
//int16_t mx, my, mz;

//String valNames[9] = {
//  "ax", "ay", "az", "gx", "gy", "gz", "mx", "my", "mz"};

int16_t sensorVals[9];

/*
SD card from PJRC 
 http://pjrc.com/store/sd_adaptor.html
 pins on Teensy 3.0
 MOSI - pin 11
 MISO - pin 12
 CLK - pin 13
 CS - pin 10
 */

const int chipSelect = 10;
const int buttonPin = 4;

boolean logState;

Bounce buttonBouncer = Bounce(buttonPin, 5);

void setup() {
  Serial.begin(38400); //baudrate doesn't matter as serial port is emulated by Teensy
  Wire.begin(); //join I2C bus

  // initialize MPU9150
  Serial.println("Initializing I2C devices...");
  delay(100);
  accelgyro.initialize();


  // verify connection to MPU9150
  Serial.println("Testing device connections...");
  Serial.println(accelgyro.testConnection() ? "MPU9150 connection successful" : "MPU9150 connection failed");

  accelgyro.setFullScaleAccelRange(3);


  // initialize SD card
  Serial.print("Initializing SD card...");
  // make sure that the default chip select pin is set to
  // output, even if you don't use it:
  pinMode(chipSelect, OUTPUT);

  //initialize the button pin
  pinMode(buttonPin, INPUT_PULLUP);  // initialize the button pin using internal pullup resistor.
  attachInterrupt(buttonPin, logButtonPressed, LOW); // attach in interupt to the button pin

  //set the flags
  logState = false; //set the logging flag to false.

  // see if the card is present and can be initialized:
  if (!SD.begin(chipSelect)) {
    Serial.println("SD card failed, or not present");
    // don't do anything more:
  }
  else{
    Serial.println("SD card initialized.");
    File dataFile = SD.open("log.csv", FILE_WRITE);
    if (dataFile) {
      dataFile.println("Board restarted");
      dataFile.close();
    }
  }
}

void loop() {
  //  Serial.print("log: ");
  //  Serial.println(logState);

  // make a string for assembling the data to log:
  String dataString = "";
  unsigned long timeCounter = millis();

  while (millis()-timeCounter < 2000) {

    // read raw accel/gyro measurements from device
    accelgyro.getMotion9(&sensorVals[0], &sensorVals[1], &sensorVals[2], &sensorVals[3], &sensorVals[4], &sensorVals[5], &sensorVals[6], &sensorVals[7], &sensorVals[8]);

    // build the string that will be written to the datalog file.
    for (int i=0; i<9; i++){
      dataString += sensorVals[i];
      dataString += ",";
    }
    dataString += millis();
    dataString += "\n";
    //    Serial.print(dataString);
  }

  if (logState) {
    // open the file. note that only one file can be open at a time,
    // so you have to close this one before opening another.
    File dataFile = SD.open("log.csv", FILE_WRITE);

    // if the file is available, write to it:
    if (dataFile) {
      dataFile.print(dataString);
      dataFile.close();
      // print to the serial port too:
      //      Serial.println(dataString);
    }  
    // if the file isn't open, pop up an error:
    else {
      Serial.println("error opening log file");

    }
  }
}

void logButtonPressed() {
  // read buttonPin and set the log state
  buttonBouncer.update();
  if (buttonBouncer.fallingEdge()) {
    logState = !logState;
  }
}





















