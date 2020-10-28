void setupLoginScreen() {
  //LOGINSCREEN
  loginWindow = new Window(width/2-200, height/2-300, 400, 600, "LoginWindow");
  loginScreen.windows.add(loginWindow);

  loginWindow.elements.add(new TextDisplay("Login", "Login", 200, 80, 45, loginWindow, CENTER));
  loginWindow.elements.add(new TextBox("Username", "Username", 20, 180, 360, 40, loginWindow) {
    public void reactEnter() {
      owner.getElement("LoginButton").reactClickedOn();
    }
  }
  );

  loginWindow.elements.add(new TextBox("Password", "Password", 20, 280, 360, 40, loginWindow) {
    public void reactEnter() {
      owner.getElement("LoginButton").reactClickedOn();
    }
  }
  );

  loginWindow.elements.add(new Button("LoginButton", "Press to login", 90, 470, 220, 40, loginWindow) {
    public void reactClickedOn() {
      login();
    }
  }
  );
  loginWindow.elements.add(new Button("NewUser", "New User", 90, 520, 220, 40, loginWindow) {
    public void reactClickedOn() {
      activeScreen = createUserScreen;
    }
  }
  );
}
