class UIElement {
  String name;
  String description;

  int localX;
  int localY;
  int sizeX;
  int sizeY;
  int x;
  int y;

  Window owner;
  boolean isActive = false;

  void step() {
    if (clickedOn()) {
      isActive = true;
      reactClickedOn();
    }
    if (clickedOff()) {
      isActive = false;
    }
    if (isActive) {
      stepActive();
    }
    if (isActive && keyTapped(ENTER)) {
      reactEnter();
    }
  }
  void drawElement() {
    fill(255, 150, 150);
    rect(x, y, sizeX, sizeY);
    textSize(sizeY-1);
    fill(0);
    text("NO TEXTURE", x, y+sizeY);
  }
  boolean clickedOn() {
    if (mouseReleased) {
      if (math.within(x, mouseX, x + sizeX)) {
        if (math.within(y, mouseY, y + sizeY)) {
          return true;
        }
      }
    }
    return false;
  }
  boolean clickedOff() {
    if (mouseReleased) {
      if (math.within(x, mouseX, x+sizeX)) {
        if (math.within(y, mouseY, y + sizeY)) {
          return false;
        }
      }
      return true;
    }
    
    return false;
  }
  void reactEnter() {
  }
  void reactClickedOn() {
  }
  void stepActive() {
  }
  String getOutput() {
    return "";
  }
  void deleteMe() {
    owner.removeList.add(this);
  }

  void calcXY() {
    x = owner.x + localX;
    y = owner.y + localY;
  }
}
