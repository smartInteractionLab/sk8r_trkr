import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class SK8R_viz extends PApplet {

 
 
Serial myPort;    // The serial port

float[] sensorVals = new float[10];
// for (int i=0; i<sensorVals.length; i++) {
// 	sensorVals[i] = 0;
// }

DataLine[] dataLines = new DataLine[10];
 
public void setup() { 
  size(800, 800);

  // List all the available serial ports: 
  println(Serial.list()); 
  // I know that the first port in the serial list on my mac 
  // is always my  Keyspan adaptor, so I open Serial.list()[0]. 
  // Open whatever port is the one you're using. 
  myPort = new Serial(this, Serial.list()[0], 9600); 

  for (int i=0; i<dataLines.length; i++) {
  	dataLines[i] = new DataLine(50, 40000, 10, 10, height-10, width-10);
  }
} 
 
public void draw() { 
	for (int i=0; i<sensorVals.length; i++) {
		dataLines[i].update(sensorVals[i]);
		dataLines[i].display();
	}

} 
 
public void serialEvent(Serial p) { 
  String inString = p.readStringUntil('\n');
  println (inString);
  sensorVals = PApplet.parseFloat(split(inString, ","));
} 
class Button{
	boolean toggleVal;
	float xPos, yPos;
	ButtonController myController;

	Button(float _xPos, float _yPos) {
		xPos = _xPos;
		yPos = _yPos;
	}
}
class ButtonController{
	;
}
class DataLine{
	float[] readings;
	int displayCol;
	ButtonController myController;
	float yLimit, dispWidth, dispHeight, xPos, yPos;
	float minVal = 0;
	float maxVal = 0;

	DataLine(int _readingsCount, float _yLimit, float _xPos, float _yPos, float _dispWidth, float _dispHeight) {
		readings = new float[_readingsCount];
		yLimit = _yLimit;
		dispWidth = _dispWidth;
		dispHeight = _dispHeight;
		xPos = _xPos;
		yPos = _yPos;
	}

	public void update(float _newVal) {
		for (int i=0; i<readings.length-1; i++) { //shift all array values down one index
			if (readings[i] < minVal) minVal = readings[i];
			if (readings[i] > maxVal) maxVal = readings[i];
			readings[i] = readings[i+1];
		}
		readings[readings.length-1] = _newVal;
	}

	public void display() {
		beginShape(LINES);
		for (int i=0; i<readings.length; i++) {
			float pointX = map(i, 0, readings.length, xPos, xPos+dispWidth);
			float pointY = map(readings[i], yLimit * -1, yLimit, yPos+dispHeight, yPos);
			vertex(pointX, pointY);
		}
		endShape();
	}
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "SK8R_viz" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
