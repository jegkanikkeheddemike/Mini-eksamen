
class textDisplay extends UIElement {
  int textSize;
  int textMode = LEFT;
  color textColor = color(0);
  textDisplay(String getName, String getDescription, int getX, int getY, int getSize, Window getOwner, int getTextMode, color getTextColor) {
    name = getName;
    description = getDescription;
    text = getDescription;
    localX = getX;
    localY = getY;
    owner = getOwner;
    textSize = getSize;
    textMode = getTextMode;
    textColor = getTextColor;
    calcXY();
  }
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
    fill(textColor);
    textSize(textSize);
    text(text, x, y);
  }
}
