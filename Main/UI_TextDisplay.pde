class textDisplay extends UIElement {
  int textSize;
  String text;
  int textMode = LEFT;
  textDisplay(String getName, String getDescription, int getX, int getY, int getSize, Window getOwner, int getTextMode) {
    name = getName;
    description = getDescription;
    text = getDescription;
    localX = getX;
    localY = getY;
    owner = getOwner;
    textSize = getSize;
    textMode = getTextMode;
    calcXY();
  }
  textDisplay(String getName, String getDescription, int getX, int getY, int getSize, Window getOwner) {
    name = getName;
    description = getDescription;
    text = getDescription;
    localX = getX;
    localY = getY;
    owner = getOwner;
    textSize = getSize;
    calcXY();
  }
  void drawElement() {
    textAlign(textMode);
    fill(0);
    textSize(textSize);
    text(text, x, y);
  }
}
