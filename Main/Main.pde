Session mainSession = new Session();

void settings() {
  int w = int(displayWidth*0.8);
  int h = int(displayHeight*0.8);
  size(w, h);
}

void setup() {
  UI_Setup();
  connectToDatabase();
}

void draw() {
  activeScreen.run();
  cleanKeyboard();
}
