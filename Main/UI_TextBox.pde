class TextBox extends UIElement {
  String text = "";
  TextBox(String getName, String getDescription, int getX, int getY, int getSizeX, int getSizeY, Window getOwner) {
    name = getName;
    description = getDescription;
    localX = getX;
    localY = getY;
    sizeX = getSizeX;
    sizeY = getSizeY;
    owner = getOwner;
    calcXY();
  }
  void stepActive() {
    for (Character i : tappedKeys) {
      if (i == BACKSPACE && text.length() > 0) {
        text = text.substring(0, text.length()-1);
      } else if (i != ENTER && i != BACKSPACE && i!=TAB) {
        text += i;
      }
    }
  }
  void clearText(){
    text = "";
  }
  
  void drawElement() {
    textAlign(LEFT);
    stroke(0);
    strokeWeight(sizeY/10);
    if (isActive) {
      fill(200, 200, 255);
    } else {
      fill(255);
    }
    rect(x, owner.y+localY, sizeX, sizeY);
    fill(0);
    textSize(sizeY*0.8);
    text(text, x+3, y+sizeY * 0.8);

    fill(0);
    text(description, x+1, y-4);
  }
  String getOutput() {
    return text;
  }
}
