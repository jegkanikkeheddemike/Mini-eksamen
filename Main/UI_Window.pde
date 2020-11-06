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
  
  ArrayList<String> interacterable = new ArrayList<String>();
  int multiChoiceIndex = -1;

  Window(int getX, int getY, int getSizeX, int getSizeY, String getName) {
    x = getX;
    y = getY;
    sizeX = getSizeX;
    sizeY = getSizeY;
    name = getName;
    interacterable.add("TextBox");
    interacterable.add("Button");
    interacterable.add("ScreenButton");
    interacterable.add("Choice");


    //["TextBox","Button","ScreenButton","MultiChoice"];
  }

  UIElement getElement(String elementName) {
    for (UIElement element : elements) {
      if (element.name.equals(elementName)) {
        return element;
      }
    }
    return null;
  }
  void removeElement(String elementName) {
    for (int i = 0; i < elements.size(); i ++) {
      UIElement e = elements.get(i);
      if (e.name.equals(elementName)) {
        elements.remove(e);
        break;
      }
    }
  }
  void stepWindow() {
    if (keyTapped(9)) { //SWITCHING BETWEEN ACTIVE WINDOWS USING SHIFT.
    int direc = 1;
    if (keyDown(-1)) {
      direc = -1;
    }
      for (int i = 0; i < elements.size(); i ++) {
        UIElement e = elements.get(i);
        if (e.isActive) {
          e.isActive = false;
          int nI = i+direc;
          if (nI == elements.size()) {
              nI = 0;
            } else if (nI < 0) {
              nI = elements.size()-1;
          }
          println(nI);
          UIElement n = elements.get(nI);
          while (!interacterable.contains(n.type)) {
            nI+=direc;
            if (nI == elements.size()) {
              nI = 0;
            } else if (nI == 0) {
             nI = elements.size()-1;
            }
            n = elements.get(nI);
          }
          n.isActive = true;
          
          break;
        }
      }
    }


    for (int i = 0; i < elements.size();i ++) {
      UIElement element = elements.get(i);
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
    if (show) {
      super.drawWindow();
    }
  }
}
