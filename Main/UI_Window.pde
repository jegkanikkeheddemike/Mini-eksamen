class Window {
  int name;
  int description;
  int x;
  int y;
  int sizeX;
  int sizeY;

  boolean hasBackdrop = false;
  color backdropColor = color(150);
  boolean hasOutline = false;
  color outlineColor = color(255);
  int outlineWeight = 2;

  ArrayList<UIElement> elements = new ArrayList<UIElement>();
  ArrayList<UIElement> removeList = new ArrayList<UIElement>();

  Window(int getX, int getY, int getSizeX, int getSizeY) {
    x = getX;
    y = getY;
    sizeX = getSizeX;
    sizeY = getSizeY;
  }

  void stepWindow() {
    for (UIElement i : elements) {
      i.step();
    }
    for (UIElement i : removeList) {
      elements.remove(i);
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
    for (UIElement i : elements) {
      i.drawElement();
    }
  }
}
ArrayList<Window> windows = new ArrayList<Window>();
