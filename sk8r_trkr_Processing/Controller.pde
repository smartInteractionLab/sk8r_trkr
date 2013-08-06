class Controller {
  Button[] buttons;
  DataLine[] dataLines;
  float channelCount, xPos, yPos, cWidth, cHeight, dWidth;
  //displayLine variablexs
  float dXpos, dYpos, dWidth, dHeight, dRawMax;
  //button variables
  float bXpos, bYpos, bWidth, bHeight;

  long millisNow;
  long totalPoints;
  Table dataTable;

  Controller(float _x, float _y, float _w, float _h) {
    channelCount = 9; // per 9dof sensor
    dataLines = new DataLine[channelCount];
    buttons = new Button[channelCount];
    xPos = _x;
    yPos = _y;
    cWidth = _w;
    cHeight = _h;
    dWidth = cWidth-50+xPos;    
    for (int i=0; i<channelCount; i++) {
      dataLines[i] = new DataLine(50, 40000);
      buttons[i] = new Button();
    }
  }

  void parseData(String _dataFile) {
    dataTable = loadTable(_dataFile);
    totalPoints = dataTable.getRowCount();
    println("data points: " + totalPoints);
  }
  
  void drawFrame(){
    pushStyle();
    noFill();
    stroke(0);
    strokeWeight(1);
    rect(xPos, yPos, dWidth, cHeight); //draw a rectangle around the display line area
    float midPoint = (dWidth/2)+xPos;
    line(midPoint, yPos, midPoint, cHeight-yPos);
    popStyle();
  }
}

