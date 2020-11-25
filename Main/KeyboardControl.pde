ArrayList<Integer> downKeys = new ArrayList<Integer>();
ArrayList<Integer> tappedKeys = new ArrayList<Integer>();
ArrayList<Integer> ignoredChar = new ArrayList<Integer>();
boolean mouseReleased = false;
float scrollAmount = 0;
void keyPressed() {
  int k = (int) key;
  if (key == CODED) {
    if (keyCode == SHIFT) {
      k = -1;
    }
    else if (keyCode == LEFT) {
      k = -2;
    }
    else if (keyCode == RIGHT) {
      k = -3;
    }
  }
  if (!downKeys.contains(k) &&  !ignoredChar.contains(k)) {
    downKeys.add(k);
    tappedKeys.add(k);
  }
}

void keyReleased() {
  int k = (int) key;
  if (key == CODED) {
    if (keyCode == SHIFT) {
      k = -1;
    }
    else if (keyCode == LEFT) {
      k = -2;
    }
    else if (keyCode == RIGHT) {
      k = -3;
    }
  } else {
    k = (int) key;
  }
  if (downKeys.contains(k)) {
    downKeys.remove(downKeys.indexOf(k));
  }
}

void mouseWheel(MouseEvent e) {
  scrollAmount = -8*e.getCount();
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
