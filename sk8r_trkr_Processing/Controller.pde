class Controller {
  Button[] buttons;
  DataLine[] dataLines;
  FloatList millis;
  float channelCount, xPos, yPos, cWidth, cHeight, dWidth, dHeight;
  //displayLine variables
  float dXpos, dYpos, dWidth, dHeight, dRawMax;
  String[] labels = {
    "ax", "ay", "az", "gx", "gy", "gz", "mx", "my", "mz"
  }; 
  int[][] colors = {
    {
      255, 0, 0
    }
    , {
      255, 80, 80
    }
    , {
      255, 160, 160
    }
    , 
    {
      0, 255, 0
    }
    , {
      80, 255, 80
    }
    , {
      160, 255, 160
    }
    , 
    {
      0, 0, 255
    }
    , {
      80, 80, 255
    }
    , {
      160, 160, 255
    }
  }

  long millisNow;
  long totalPoints;
  Table dataTable;
  
  long millisStart, millisEnd; //values to control start and end of dataset

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
    setDataLines();
    setButtons();
    parseData("log.csv");
  }

  void setDataLines() {
    for (int i=0; i<dataLines.length; i++) {
      dataLines[i].setLabel(labels[i]);
      dataLines[i].setColor(color(colors[i]));
    }
  }

  void setButtons() {
    float _xPos = xPos+dWidth+7.5;
    float _yPos = yPos+7;
    for (int i=0; i<buttons.length; i++) {
      _yPos += i*40;
      buttons[i].setPos(_xPos, _yPos);
      buttons[i].setLabel(labels[i]);
      buttons[i].setColor(color(colors[i]));
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
  
  void drawSlider() {
    pushStyle();
    fill(50);
    rect(xPos, yPos, dWidth, 25);
    

  void drawDataLines() {
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

