class Button {
  boolean isOn;
  float xPos, yPos, btnWidth, btnHeight;
  String label = "";
  color fillColor = color(255, 255, 255);

  Button(float _xPos, float _yPos) {
    xPos = _xPos;
    yPos = _yPos;
    btnHeight = 35;
    btnWidth = 35;
    isOn = false;
  }

  void setLabel(String _label) {
    label = _label;
  }
  
  void setColor(color _color){
    fillColor = _color;
  }

  void toggle() {
    isOn = !isOn;
  }

  boolean isClicked(float _x, float _y) {
    if ((_x >= xPos && _x <= xPos+btnWidth) && (_y >= yPos && _y <= yPos+btnHeight)) {
      return true;
    }
    else return false;
  } 

  void display() {
    pushStyle();
    if (isOn) fill(fillColor);
    else fill(180);
    stroke(0);
    rect(xPos, yPos, btnWidth, btnHeight);
    textAlign(LEFT, TOP);
    fill(10);
    text(label, xPos, yPos+btnHeight);
    popStyle();
  }
}

