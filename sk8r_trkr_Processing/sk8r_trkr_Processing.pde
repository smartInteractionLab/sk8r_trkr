import processing.serial.*; 

Serial myPort;    // The serial port

float[] sensorVals = new float[10];
DataLine[] dataLines = new DataLine[sensorVals.length-1]; // exclude last sensorVals value as it's millis
Button[] buttons = new Button[dataLines.length]; //make a button for each dataline

void setup() { 
  size(1200, 800);

  // List all the available serial ports: 
  println(Serial.list()); 
  // I know that the first port in the serial list on my mac 
  // is always my  Keyspan adaptor, so I open Serial.list()[0]. 
  // Open whatever port is the one you're using. 
  myPort = new Serial(this, Serial.list()[0], 38400); 

  for (int i=0; i<dataLines.length; i++) {
    dataLines[i] = new DataLine(50, 40000, 10, 10, width-60, height-10);
    buttons[i] = new Button(width-50, i*75+50);
    buttons[i].toggle(); //set buttons to true
    color lineColor = color(0, 0, 0);
    String lineName = "";
    switch(i) {
    case 0:
      lineColor = color(255, 0, 0);
      lineName = "ax";
      break;
    case 1:
      lineColor = color(255, 100, 100);
      lineName = "ay";
      break;
    case 2:
      lineColor = color(255, 200, 200);
      lineName = "az";
      break;
    case 3:
      lineColor = color(0, 255, 0);
      lineName = "gx";
      break;
    case 4:
      lineColor = color(100, 255, 100);
      lineName = "gy";
      break;
    case 5:
      lineColor = color(200, 255, 200);
      lineName = "gz";
      break;
    case 6:
      lineColor = color(0, 0, 255);
      lineName = "mx";
      break;
    case 7:
      lineColor = color(100, 100, 255);
      lineName = "my";
      break;
    case 8:
      lineColor = color(200, 200, 255);
      lineName = "mz";
      break;
    }
    dataLines[i].setColor(lineColor);
    dataLines[i].setName(lineName);
    buttons[i].setLabel(lineName);
    buttons[i].setColor(lineColor);
  }
} 

void draw() { 
  background(255);        
  for (int i=0; i<sensorVals.length-1; i++) { //exclude last sensorVal as it's millis
    dataLines[i].update(sensorVals[i]);
    dataLines[i].display();
    buttons[i].display();
  }
} 

void serialEvent(Serial p) { 
  String inString = p.readStringUntil('\n');
  if (inString != null) {
//    println (inString);
    sensorVals = float(split(inString, ','));
  }
} 

void mouseClicked() {
  for (int i=0; i<dataLines.length; i++) {
    if (buttons[i].isClicked(mouseX, mouseY)) {
      buttons[i].toggle();
      dataLines[i].setVisible(buttons[i].isOn);
      break;
    }
  }
}

