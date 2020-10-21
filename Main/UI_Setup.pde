Screen loginScreen = new Screen();
volatile Screen activeScreen = loginScreen;

Window loginWindow;

void UI_Setup() {
  //LOGINSCREEN
  loginWindow = new Window(width/2-200, height/2-300, 400, 600);
  loginWindow.elements.add(new textDisplay("Login", "Login", 200, 80, 50, loginWindow, CENTER));
  loginWindow.elements.add(new textBox("Username", "Username", 20, 180, 360, 40, loginWindow) {
    public void reactEnter() {
      loginWindow.findElement("LoginButton").reactClickedOn();
    }
  }
  );
  loginWindow.elements.add(new textBox("Password", "Password", 20, 280, 360, 40, loginWindow));

  loginWindow.elements.add(new Button("LoginButton", "Press to login", 90, 520, 220, 40, loginWindow) {
    public void reactClickedOn() {
      String username = loginWindow.findElement("Username").getOutput();
      String password = loginWindow.findElement("Password").getOutput();
      println("Logged in as", username, "at", millis());
    }
  }
  );
  loginScreen.windows.add(loginWindow);

  //CREATE USER SCREEN
}
