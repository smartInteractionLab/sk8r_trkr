import processing.serial.*; 

Serial myPort;    // The serial port

float[] sensorVals = new float[10];
DataLine[] dataLines = new DataLine[sensorVals.length-1]; // exclude last sensorVals value as it's millis
Button[] buttons = new Button[dataLines.length]; //make a button for each dataline
Controller[] controllers = new Controller[dataLines.length]; //create controller objects for each button/line set

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
    controllers[i] = new Controller(buttons[i], dataLines[i]);
    controllers[i].setState(true); //turn all the controllers on
    color displayColor = color(0, 0, 0);
    String displayName = "";
    switch(i) {
    case 0:
      displayColor = color(255, 0, 0);
      displayName = "ax";
      break;
    case 1:
      displayColor = color(255, 80, 80);
      displayName = "ay";
      break;
    case 2:
      displayColor = color(255, 160, 160);
      displayName = "az";
      break;
    case 3:
      displayColor = color(0, 255, 0);
      displayName = "gx";
      break;
    case 4:
      displayColor = color(100, 255, 100);
      displayName = "gy";
      break;
    case 5:
      displayColor = color(200, 255, 200);
      displayName = "gz";
      break;
    case 6:
      displayColor = color(0, 0, 255);
      displayName = "mx";
      break;
    case 7:
      displayColor = color(100, 100, 255);
      displayName = "my";
      break;
    case 8:
      displayColor = color(200, 200, 255);
      displayName = "mz";
      break;
    }
    controllers[i].setColor(displayColor);
    controllers[i].setName(displayName);
  }
} 

void draw() { 
  background(150);        
  for (int i=0; i<sensorVals.length-1; i++) { //exclude last sensorVal as it's millis
    controllers[i].setData(sensorVals[i]);
    controllers[i].update();
    controllers[i].display();
  }
} 

void serialEvent(Serial p) { 
  String inString = p.readStringUntil('\n');
  if (inString != null) {
    println (inString);
    sensorVals = float(split(inString, ','));
  }
} 

void mouseClicked() {
  for (int i=0; i<dataLines.length; i++) {
    controllers[i].checkButton(mouseX, mouseY); //check each controller to see its btton was clicked
  }
}

