ArrayList<Integer> downKeys = new ArrayList<Integer>();
ArrayList<Integer> tappedKeys = new ArrayList<Integer>();
ArrayList<Integer> ignoredChar = new ArrayList<Integer>();
boolean mouseReleased = false;

void keyPressed() {
  if (!downKeys.contains(key) &&  !ignoredChar.contains(key)) {
    int k = key;
    downKeys.add((Integer) k);
    tappedKeys.add((Integer) k);
  }
}

void keyReleased() {
  if (downKeys.contains(key)) {
    int k = key;
    downKeys.remove(downKeys.indexOf((Integer) k));
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
  int t = TAB;
  int d = DELETE;
  int e = ENTER;
  ignoredChar.add((Integer) t);
  ignoredChar.add((Integer) d);
  ignoredChar.add((Integer) e);
}
