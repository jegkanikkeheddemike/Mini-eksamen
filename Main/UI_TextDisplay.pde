class textDisplay extends UIElement {
  int textSize;
  String text;
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
    textSize(textSize);
    text(text, x, y);
  }
}
