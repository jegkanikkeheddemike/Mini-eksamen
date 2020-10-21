class multiChoice extends UIElement {
  Choice Chosen;
  boolean hasCorrectChoice;
  String correctChocice;

  ArrayList<Choice> Choices = new ArrayList<Choice>();
  multiChoice(String getName, String getDescription, int getX, int getY, Window getOwner) {
    name = getName;
    description = getDescription;
    localX = getX;
    localY = getY;
    owner = getOwner;
    calcXY();
  }
  multiChoice(String getName, String getDescription, int getX, int getY, Window getOwner, String getCorrectChocice) {
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
}


class Choice {
  String ChoiceName;
  Choice(String getName) {
    ChoiceName = getName;
  }
}
