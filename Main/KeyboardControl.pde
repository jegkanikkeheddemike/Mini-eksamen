ArrayList<Character> downKeys = new ArrayList<Character>();
ArrayList<Character> tappedKeys = new ArrayList<Character>();
ArrayList<Character> ignoredChar = new ArrayList<Character>();
boolean mouseReleased = false;

void keyPressed() {
  if (!downKeys.contains(key) && key != CODED && !ignoredChar.contains(key)) {
    downKeys.add(key);
    tappedKeys.add(key);
  }
}

void keyReleased() {
  if (downKeys.contains(key)) {
    downKeys.remove(downKeys.indexOf(key));
  }
}

boolean keyDown(char input) {
  if (downKeys.contains(input)) {
    return true;
  }
  return false;
}

boolean keyTapped(char input) {
  if (tappedKeys.contains(input)) {
    return true;
  }
  return false;
}


void mouseReleased() {
  mouseReleased = true;
}


void cleanKeyboard() {
  mouseReleased = false;
  tappedKeys.clear();
}

void defineIgnoredChar(){
  ignoredChar.add(TAB);
  ignoredChar.add(DELETE);
  ignoredChar.add(ENTER);

}
