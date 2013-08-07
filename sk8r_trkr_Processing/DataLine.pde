class DataLine {
  FloatList readings;
  color displayCol = color(0, 0, 0);
  float yLimit, dispWidth, dispHeight, xPos, yPos;
  float minVal = 0;
  float maxVal = 0;
  float pointX = 0;
  float pointY = 0;
  String name = "";
  boolean isVisible;

  DataLine(){
    isVisible = true;
  }

  void setColor(color _color) {
    displayCol = _color;
  }

  void setVisible(boolean _isVisible) {
    isVisible = _isVisible;
  }

  void setName(String _name) {
    name = _name;
  }
  
  void setData(float _data){
    readings.append(_data);
  }
    
    
    

  void update(float _newVal) {
    for (int i=0; i<readings.length-1; i++) { // shift all array values down one index
      if (readings[i] < minVal) minVal = readings[i];
      if (readings[i] > maxVal) maxVal = readings[i];
      readings[i] = readings[i+1];
    }
    readings[readings.length-1] = _newVal; // push new value at end of array
  }

  void display(float _xPos, float _yPos, float _dispWidth, float _dispHeight) {
    if (isVisible) {
      noFill();
      stroke(displayCol);
      strokeWeight(2);
      beginShape();
      for (int i=0; i<readings.length; i++) {
        pointX = map(i, 0, readings.length-1, _xPos, _xPos+_dispWidth);
        pointY = map(readings[i], yLimit * -1, yLimit, _yPos+_dispHeight, _yPos);
        if (i == 0) drawLabel(name, pointX, pointY);
        vertex(pointX, pointY);
      }
      endShape();
    }
  }

  void drawLabel(String _name, float _xLoc, float _yLoc) {
    pushStyle();
    fill(displayCol);
    textSize(30);
    text(_name, _xLoc, _yLoc);
    popStyle();
  }
}

