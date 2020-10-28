boolean within(float low, float middle, float high) {
  return (low < middle && middle < high);
}

class UIElement {
  String name;
  String description;

  int localX;
  int localY;
  int sizeX;
  int sizeY;
  int x;
  int y;

  //AAHHHHHHHH
  color textColor;
  String text;
  //AHHHHH

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
    stepAlways();
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
      if (within(x, mouseX, x + sizeX)) {
        if (within(y, mouseY, y + sizeY)) {
          return true;
        }
      }
    }
    return false;
  }
  boolean clickedOff() {
    if (mouseReleased) {
      if (within(x, mouseX, x+sizeX)) {
        if (within(y, mouseY, y + sizeY)) {
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
  void stepAlways() {  //Used only for multiple choice so far
  }
  void setText(String newText) {
    text = newText;
  }
  String getOutput() {
    return "";
  }
  void deleteMe() {
    owner.removeList.add(this);
  }

  //TextBox
  void clearText() {
  }

  void calcXY() {
    x = owner.x + localX;
    y = owner.y + localY;
  }
}

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


class ScreenButton extends UIElement {
  Screen location;
  ScreenButton(String getName, String getDescription, int getX, int getY, int getSizeX, int getSizeY, Window getOwner, Screen getLocation) {
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

class List extends UIElement {
  PGraphics listRender;
  int scrool = 0;
  ArrayList<UIElement> elements = new ArrayList<UIElement>();
  List(String getName, String getDescription, int getX, int getY, int getSizeX, Window getOwner) {
    listRender = createGraphics(getSizeX, getOwner.sizeY-20);
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
    int yy = 10+scrool;
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


class Assignment extends UIElement {
  Date dueDate;
  Assignment(String getName, String getDescription) {
    name = getName;
    description = getDescription;
    sizeX = 280;
    sizeY = 50;
  }
  void reactClickedOn() {
    println(name);
  }
}

class MultiChoice extends UIElement {
  Choice Chosen;
  boolean hasCorrectChoice;
  String correctChocice;

  ArrayList<Choice> Choices = new ArrayList<Choice>();
  MultiChoice(String getName, String getDescription, int getX, int getY, Window getOwner) {
    name = getName;
    description = getDescription;
    localX = getX;
    localY = getY;
    owner = getOwner;
    calcXY();
  }
  MultiChoice(String getName, String getDescription, int getX, int getY, Window getOwner, String getCorrectChocice) {
    name = getName;
    description = getDescription;
    localX = getX;
    localY = getY;
    correctChocice = getCorrectChocice;
    owner = getOwner;
    calcXY();
  }

  void drawElement() {
    textAlign(LEFT);
    fill(0);
    textSize(30);
    text(description, x, y);
    textSize(20);
    int yy = 15;
    for (Choice i : Choices) {
      if (i == Chosen) {
        fill(0);
      } else {
        fill(255);
      }
      rect(x+10, y+yy, 15, 15);
      fill(0);
      text(i.ChoiceName, x+30, y+yy+15);
      yy += 30;
    }
  }
  void stepAlways() {
    int yy = 15;
    for (Choice i : Choices) {
      if (mouseReleased) {
        if (within(x+10, mouseX, x+25)) {
          if (within(y+yy, mouseY, y+yy+15)) {
            Chosen = i;
          }
        }
      }
      yy+= 30;
    }
  }
  String getOutput() {
    if (Chosen != null) {
      return Chosen.ChoiceName;
    } else {
      return null;
    }
  }
  void clearText() {
    Chosen = null;
  }
}


class Choice {
  String ChoiceName;
  Choice(String getName) {
    ChoiceName = getName;
  }
}

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
  void clearText() {
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


class TextDisplay extends UIElement {
  int textSize;
  int textMode = LEFT;
  color textColor = color(0);
  TextDisplay(String getName, String getDescription, int getX, int getY, int getSize, Window getOwner, int getTextMode, color getTextColor) {
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
  TextDisplay(String getName, String getDescription, int getX, int getY, int getSize, Window getOwner, int getTextMode) {
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
  TextDisplay(String getName, String getDescription, int getX, int getY, int getSize, Window getOwner) {
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
