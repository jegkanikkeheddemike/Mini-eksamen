Screen loginScreen = new Screen();
Screen createUserScreen = new Screen();
volatile Screen activeScreen = loginScreen;

Window loginWindow;
Window createUserWindow;

void UI_Setup() {
  //LOGINSCREEN
  loginWindow = new Window(width/2-200, height/2-300, 400, 600);
  loginScreen.windows.add(loginWindow);

  loginWindow.elements.add(new textDisplay("Login", "Login", 200, 80, 45, loginWindow, CENTER));

  loginWindow.elements.add(new textBox("Username", "Username", 20, 180, 360, 40, loginWindow) {
    public void reactEnter() {
      owner.findElement("LoginButton").reactClickedOn();
    }
  }
  );

  loginWindow.elements.add(new textBox("Password", "Password", 20, 280, 360, 40, loginWindow) {
    public void reactEnter() {
      owner.findElement("LoginButton").reactClickedOn();
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



  //CREATE USER SCREEN
  createUserWindow = new Window(width/2-200, height/2-300, 400, 600);
  createUserScreen.windows.add(createUserWindow);

  createUserWindow.elements.add(new textDisplay("CreateUser", "Create New User", 200, 80, 45, createUserWindow, CENTER));
  multiChoice SelectRole = new multiChoice("ChooseType", "What are you?", 10, 150, createUserWindow);
  {//Select roles
    SelectRole.Choices.add(new Choice("Student"));
    SelectRole.Choices.add(new Choice("Teacher"));
  }
  createUserWindow.elements.add(SelectRole);

  createUserWindow.elements.add(new textBox("CreateUsername", "Username", 20, 280, 360, 40, createUserWindow) {
    public void reactEnter() {
      owner.findElement("CreateUserButton").reactClickedOn();
    }
  }
  );

  createUserWindow.elements.add(new textBox("CreatePassword", "Password", 20, 380, 360, 40, createUserWindow) {
    public void reactEnter() {
      owner.findElement("CreateUserButton").reactClickedOn();
    }
  }
  );

  createUserWindow.elements.add(new Button("CreateUserButton", "Create User", 90, 520, 220, 40, createUserWindow) {
    public void reactClickedOn() {
      if (owner.findElement("ChooseType").getOutput() != null) {
        //String username = owner.findElement("CreateUsername").getOutput();
        //String password = owner.findElement("CreatePassword").getOutput();
        createLogin();
        activeScreen = loginScreen;
      } else {
        println("Please Choose a role");
      }
    }
  }
  );
}
