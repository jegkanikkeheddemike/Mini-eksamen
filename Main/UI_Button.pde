class Button extends UIElement {
  Button(String getName, String getDescription, int getX, int getY, int getSizeX, int getSizeY, Window getOwner) {
    name = getName;
    description = getDescription;
    localX = getX;
    localY = getY;
    sizeX = getSizeX;
    sizeY = getSizeY;
    owner = getOwner;
    calcXY();
  }
  void drawElement() {
    textAlign(CENTER);
    fill(255);
    textSize(int(sizeY*0.8));
    rect(x, y, sizeX, sizeY);
    fill(0);
    text(description, x+(sizeX/2), y+(sizeY*0.8));
  }
}


class screenButton extends UIElement {
  Screen location;
  screenButton(String getName, String getDescription, int getX, int getY, int getSizeX, int getSizeY, Window getOwner, Screen getLocation) {
    name = getName;
    description = getDescription;
    localX = getX;
    localY = getY;
    sizeX = getSizeX;
    sizeY = getSizeY;
    owner = getOwner;
    location = getLocation;
    calcXY();
  }
  void drawElement() {
    textAlign(CENTER);
    fill(255);
    textSize(int(sizeY*0.8));
    rect(x, y, sizeX, sizeY);
    fill(0);
    text(description, x+(sizeX/2), y+(sizeY*0.8));
  }
  void reactClickedOn() {
    extraAction();
    activeScreen = location;
  }
  void extraAction() {
  }
}
