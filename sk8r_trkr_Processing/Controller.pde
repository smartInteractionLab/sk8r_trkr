class Controller {
  Button[] buttons;
  DataLine[] dataLines;
  FloatList millis;
  float channelCount, xPos, yPos, cWidth, cHeight, dWidth, dHeight;
  //displayLine variables
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
    dWidth = cWidth-50;    
    dHeight = cHeight-15;
    for (int i=0; i<channelCount; i++) {
      dataLines[i] = new DataLine();
      buttons[i] = new Button();
    }
  }

  void parseData(String _dataFile) {
    dataTable = loadTable(_dataFile);
    totalPoints = dataTable.getRowCount();
    println("data points: " + totalPoints);
    for (TableRow row : dataTable.rows()) {
      for (int dataLine : dataLines) {
        dataLine.setData(row.getFloat(i));
      }
      millis.append(row.getFloat(10));
    }
  }

  void drawFrame() {
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

