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
    fill(0);
    rect(x, y, sizeX, sizeY);
    text(description, x, y);
  }
}
