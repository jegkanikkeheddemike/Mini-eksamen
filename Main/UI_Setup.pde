Screen loginScreen = new Screen();
Screen createUserScreen = new Screen();
Screen homeScreen = new Screen();
volatile Screen activeScreen = loginScreen;

Window loginWindow;
Window createUserWindow;
Window topMenu;
Window assignMents;

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
  createUserWindow = new Window(width/2-200, height/2-400, 400, 800);
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
  createUserWindow.elements.add(new textBox("CreateRealname", "Real Name", 20, 480, 360, 40, createUserWindow) {
    public void reactEnter() {
      owner.findElement("CreateUserButton").reactClickedOn();
    }
  }
  );
  createUserWindow.elements.add(new textBox("CreateClass", "Class", 20, 580, 360, 40, createUserWindow) {
    public void reactEnter() {
      owner.findElement("CreateUserButton").reactClickedOn();
    }
  }
  );

  createUserWindow.elements.add(new Button("CreateUserButton", "Create User", 90, createUserWindow.sizeY-80, 220, 40, createUserWindow) {
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

  //HOMESCREEN
  assignMents = new Window(width-450, 300, 400, 800);
  assignMents.elements.add(new textDisplay("AssignMentHeader", "Assignments", 20, 40, 40, assignMents));
  List asssignMentList = new List("Assignments", "", 10, 50, 380, assignMents)
  {
    public void addElements() {
      elements.add(new assignMent("Fysik rapport", "Lav en fucking rapport fag"));
      elements.add(new assignMent("Kemi rapport", "Plz lav en kemi rapport UwU"));
      elements.add(new assignMent("Dansk Stil", "Lav en bigass kæmpe fucking dansk Stil"));
      elements.add(new assignMent("Placeholder", "Alle assignmentsne skal være indivudueller for hver klasse."));
    }
  };
  assignMents.elements.add(asssignMentList);
  homeScreen.windows.add(assignMents);

  //TOPMENU
  topMenu = new Window(0, 0, width, 200);
  topMenu.elements.add(new textDisplay("Header", "The New Lectio", 20, 60, 60, topMenu));
  topMenu.elements.add(new screenButton("Logout", "Logout", width-130, 160, 100, 25, topMenu, loginScreen) {
    public void extraAction() {
      givenName = null;
      surName=null;
      userClass=null;
      role=null;
    }
  }
  );
  homeScreen.windows.add(topMenu);
}
