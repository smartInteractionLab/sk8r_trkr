class Controller {
  Button button;
  DataLine dataLine;
  boolean isOn;
  String name;
  color myColor;
  float dataPoint;

  Controller(Button _button, DataLine _dataLine) {
    button = _button;
    dataLine = _dataLine;
    isOn = false;
    name = "Controller";
    myColor = color(0, 0, 0);
    dataPoint = 0;
  }

  void setState(boolean _state) {
    isOn = _state;
    button.isOn = isOn;
    dataLine.isVisible = isOn;
  }

  void update() {
    button.isOn = isOn; //set the controller to the same state as the button
    dataLine.isVisible = isOn; //set the dataLine to the same state as the controller
    dataLine.update(dataPoint);
  }

  void display() {
    button.display();
    dataLine.display();
  }

  void setName(String _name) {
    name = _name;
    button.setLabel(name);
    dataLine.setName(name);
  }

  void setColor(color _color) {
    myColor = _color;
    button.setColor(myColor);
    dataLine.setColor(myColor);
  }

  void checkButton(float _x, float _y) {
    if (button.isClicked(_x, _y)) {
      isOn = !isOn; //toggle state
    }
  }

  void setData(float _val) {
    dataPoint = _val;
  }
}

