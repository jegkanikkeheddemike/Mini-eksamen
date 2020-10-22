class List extends UIElement {
  ArrayList<UIElement> elements = new ArrayList<UIElement>();
  List(String getName, String getDescription, int getX, int getY, int getSizeX, Window getOwner) {
    name = getName;
    description = getDescription;
    localX = getX;
    localY = getY;
    sizeX = getSizeX;
    owner = getOwner;
    calcXY();
    addElements();
  }
  void drawElement() {
    textSize(20);
    text(description, x, y);
    int yy = 10;
    for (UIElement i : elements) {
      fill(255);
      rect(x, y+yy, sizeX, 50);
      fill(0);
      textSize(20);
      text(i.name, x, y+yy+20);
      textSize(15);
      text(i.description, x, y+yy+40);
      yy += 60;
    }
  }
  void addElements() {
  }
}

class assignMent extends UIElement {
  Date dueDate;
  assignMent(String getName, String getDescription) {
    name = getName;
    description = getDescription;
    sizeX = 280;
    sizeY = 50;
  }
  void reactClickedOn() {
    println(name);
  }
}
