void setupCreateUserScreen() {
  //CREATE USER SCREEN
  createUserWindow = new Window(width/2-200, height/2-400, 400, 800, "CreateUserWindow");
  createUserScreen.windows.add(createUserWindow);

  createUserWindow.elements.add(new TextDisplay("CreateUser", "Create New User", 200, 80, 45, createUserWindow, CENTER));
  MultiChoice SelectRole = new MultiChoice("ChooseRole", "What are you?", 10, 150, createUserWindow);
  {//Select roles
    SelectRole.Choices.add(new Choice("Student"));
    SelectRole.Choices.add(new Choice("Teacher"));
  }
  createUserWindow.elements.add(SelectRole);

  createUserWindow.elements.add(new TextBox("CreateLogin", "Login name", 20, 280, 360, 40, createUserWindow) {
    public void reactEnter() {
      owner.getElement("CreateUserButton").reactClickedOn();
    }
  }
  );

  createUserWindow.elements.add(new TextBox("CreatePassword", "Password", 20, 380, 360, 40, createUserWindow) {
    public void reactEnter() {
      owner.getElement("CreateUserButton").reactClickedOn();
    }
  }
  );

  createUserWindow.elements.add(new TextBox("CreatePasswordAgain", "Password again", 20, 480, 360, 40, createUserWindow) {
    public void reactEnter() {
      owner.getElement("CreateUserButton").reactClickedOn();
    }
  }
  );

  createUserWindow.elements.add(new TextBox("CreateRealName", "Real Name", 20, 580, 360, 40, createUserWindow) {
    public void reactEnter() {
      owner.getElement("CreateUserButton").reactClickedOn();
    }
  }
  );

  createUserWindow.elements.add(new TextBox("CreateClass", "Class", 20, 680, 360, 40, createUserWindow) {
    public void reactEnter() {
      owner.getElement("CreateUserButton").reactClickedOn();
    }
  }
  );

  createUserWindow.elements.add(new Button("CreateUserButton", "Create User", 90, createUserWindow.sizeY-50, 220, 40, createUserWindow) {
    public void reactClickedOn() {
      if (owner.getElement("ChooseRole").getOutput() != null) {
        //String username = owner.getElement("CreateUsername").getOutput();
        //String password = owner.getElement("CreatePassword").getOutput();
        createLogin();
      } else {
        println("Please Choose a role");
      }
    }
  }
  );
}
