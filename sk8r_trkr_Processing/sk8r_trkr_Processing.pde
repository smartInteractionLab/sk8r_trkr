import processing.video.*;

Movie logMovie;
float movieTime;

//import processing.serial.*; 

//Serial myPort;    // The serial port

BufferedReader logReader; //there is a lot of data so we'll read it in line by line.
String line; //String to store each line from the text file created by the datalogger

float[] sensorVals = new float[10]; //9 axes plus timestamp in millis
DataLine[] dataLines = new DataLine[sensorVals.length-1]; // exclude last sensorVals value as it's millis
Button[] buttons = new Button[dataLines.length]; //make a button for each dataline
Controller[] controllers = new Controller[dataLines.length]; //create controller objects for each button/line set

//convenience variables to define the dataLines
float graphTop, graphBot, graphLeft, graphRight, midPoint;

boolean canDraw;

void setup() { 
  size(1200, 800);
  canDraw = true;
  
//  selectInput("Choose a text file to parse", "logSelected");

  logMovie = new Movie(this, "IMG_1081.m4v");
  logMovie.speed(12.0);
  logMovie.loop();

  graphTop = 30;
  graphBot = 400;
  graphLeft = 30;
  graphRight = width-100;
  midPoint = graphRight/2+graphLeft;

  //  // List all the available serial ports: 
  //  println(Serial.list()); 
  //  // I know that the first port in the serial list on my mac 
  //  myPort = new Serial(this, Serial.list()[0], 38400); 

  for (int i=0; i<dataLines.length; i++) {
    dataLines[i] = new DataLine(50, 50000, graphLeft, graphTop, graphRight, graphBot);
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
  if (canDraw) {
    drawBoundaries();
    for (int i=0; i<sensorVals.length-1; i++) { //exclude last sensorVal as it's millis
      controllers[i].setData(sensorVals[i]);
      controllers[i].update();
      controllers[i].display();
    }
    float movieHeight = height-graphBot-75;
    float movieWidth = movieHeight*1920/1080;
    image(logMovie, midPoint-(movieWidth/2), graphBot+50, movieWidth, movieHeight);
  }
} 

void drawBoundaries() {
  pushStyle();
  noFill();
  stroke(0);
  strokeWeight(1);
  rect(graphLeft, graphTop, graphRight, graphBot);
  line(midPoint, graphTop, midPoint, graphBot+graphTop);
  popStyle();
}


void mouseClicked() {
  for (int i=0; i<dataLines.length; i++) {
    controllers[i].checkButton(mouseX, mouseY); //check each controller to see its button was clicked
  }
}

void movieEvent(Movie m) {
  m.read();
}

//void serialEvent(Serial p) { 
//  String inString = p.readStringUntil('\n');
//  if (inString != null) {
////    println (inString);
//    sensorVals = float(split(inString, ','));
//  }
//} 


//void logSelected(File _selection) {
//  if (_selection == null) {
//    println("A text '.txt'  file must be selected to parse!");
//    selectInput("Choose a text file to parse", "logSelected");
//  }
//  else {
//    String fileName = _selection.getName();
//    String fileType = fileName.substring(fileName.length()-3, fileName.length());
//    if (fileType.equals("TXT") || fileType.equals("txt")) { 
//      logReader = createReader(_selection.getPath());
//      println(_selection.getAbsolutePath());
//      selectInput("Choose a Quicktime movie to sync", "movieSelected");
//    }
//    else {
//      println("A text '.txt' file must be selected to parse!");
//      selectInput("Choose a text file to parse", "logSelected");
//    }
//  }
//}
//
//void movieSelected(File _selection) {
//  if (_selection == null) {
//    println("A Quicktime '.mov' file must be selected to sync!");
//    selectInput("Choose a Quicktime '.mov' to sync", "movieSelected");
//  }
//  else {
//    String fileName = _selection.getName();
//    String fileType = fileName.substring(fileName.length()-3, fileName.length());
//    if (fileType.equals("MOV") || fileType.equals("mov")) { 
//      canDraw = true;
//      println(_selection.getAbsolutePath());
//      logMovie = new Movie(this, _selection.getPath());    
//      logMovie.loop();
//    }
//    else {
//      println("A Quicktime '.mov' file must be selected to sync!");
//      selectInput("Choose a Quicktime to sync", "movieSelected");
//    }
//  }
//}

