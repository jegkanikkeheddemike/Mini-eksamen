Screen loginScreen = new Screen();
volatile Screen activeScreen = loginScreen;

void UI_Setup() {
  //LOGINSCREEN
  Window loginWindow = new Window(0, 0, width, height);
  loginWindow.elements.add(new textDisplay("Login", "Login", 100, 100, 30, loginWindow));
  loginWindow.elements.add(new Button("Login", "tryk på mig", 20, 20, 20, 20, loginWindow) {
    public void reactClickedOn() {
      //try to log in.
    }
  }
  );
  loginScreen.windows.add(loginWindow);
}
