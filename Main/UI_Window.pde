class Window {
  String name;
  String description;
  int x;
  int y;
  int sizeX;
  int sizeY;

  boolean hasBackdrop = true;
  color backdropColor = color(150);
  boolean hasOutline = false;
  color outlineColor = color(255);
  int outlineWeight = 2;

  ArrayList<UIElement> elements = new ArrayList<UIElement>();
  ArrayList<UIElement> removeList = new ArrayList<UIElement>();

  Window(int getX, int getY, int getSizeX, int getSizeY, String getName) {
    x = getX;
    y = getY;
    sizeX = getSizeX;
    sizeY = getSizeY;
    name = getName;
  }

  UIElement getElement(String elementName) {
    for (UIElement element : elements) {
      if (element.name.equals(elementName)) {
        return element;
      }
    }
    return null;
  }

  void stepWindow() {
    if (keyTapped(9)){
      for (int i = 0; i < elements.size(); i ++) {
        UIElement e = elements.get(i);
        if (e.isActive) {
          e.isActive = false;
          int nI = i+1;
          if(nI == elements.size()) {
            nI = 0;
          }
          UIElement n = elements.get(nI);
          n.isActive = true;
          break;
        }
      }
    }


    for (UIElement element : elements) {
      element.step();
    }
    for (UIElement element : removeList) {
      elements.remove(element);
    }
  }
  void drawWindow() {
    if (hasBackdrop) {
      fill(backdropColor);
      if (hasOutline) {
        stroke(outlineColor);
        strokeWeight(outlineWeight);
      } else {
        noStroke();
      }

      rect(x, y, sizeX, sizeY);
    }
    for (UIElement element : elements) {
      element.drawElement();
    }
  }
}

class TimedWindow extends Window {
  boolean show = false;
  int time = 0;
  int timeShown;
  TimedWindow(int getX, int getY, int getSizeX, int getSizeY, String getName, int getTimeShown) {
    super(getX, getY, getSizeX, getSizeY, getName);
    timeShown = getTimeShown;
  }

  void show() {
    time = millis();
    show = true;
  }
  
  void stepWindow() {
    if (show) {  
      if (millis() > time + timeShown) {
        show = false;
      } else {
        super.stepWindow();
      }
    }
  }

  void drawWindow() {
    if(show){
      super.drawWindow();
    }
  }
}
