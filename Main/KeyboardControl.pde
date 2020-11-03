ArrayList<Integer> downKeys = new ArrayList<Integer>();
ArrayList<Integer> tappedKeys = new ArrayList<Integer>();
ArrayList<Integer> ignoredChar = new ArrayList<Integer>();
boolean mouseReleased = false;
float scrollAmount = 0;
void keyPressed() {
  if (!downKeys.contains(key) &&  !ignoredChar.contains(key)) {
    int k = (int) key;
    downKeys.add(k);
    tappedKeys.add(k);
  }
}

void keyReleased() {
  if (downKeys.contains(key)) {
    int k = (int) key;
    downKeys.remove(downKeys.indexOf(k));
  }
}

void mouseWheel(MouseEvent e) {
  scrollAmount = 8*e.getCount();
}

boolean keyDown(char input) {
  if (downKeys.contains(input)) {
    return true;
  }
  return false;
}
boolean keyDown(int input) {
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
boolean keyTapped(int input) {
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
  scrollAmount *= 0.7;
}

void defineIgnoredChar(){
  int t = TAB;
  int d = DELETE;
  ignoredChar.add((Integer) t);
  ignoredChar.add((Integer) d);
}
