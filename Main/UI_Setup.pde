/*
UI_Setup skal deles op i flere underfunktioner som deles ud i filer.
Hvor funktionerne fra NET er med i den pågældende fil
Altså knap-reaktions-funktioner er i samme fil som UI den høre til.
*/


Screen loginScreen = new Screen();
Screen createUserScreen = new Screen();
Screen homeScreen = new Screen();
volatile Screen activeScreen = loginScreen;

Window loginWindow;
Window createUserWindow;
Window topMenu;
Window assignments;
TimedWindow errorWindow;
TimedWindow successWindow;

//SPLIT THIS UP INTO SEPERATE SETUP FUNCTIONS THAT ARE THEN CALLED IN HERE
void UI_Setup() {
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

  createUserWindow.elements.add(new TextBox("CreatePassword", "Password", 20, 380, 360, 40, createUserWindow){
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
        
        //Switch back to the loginScreen
        activeScreen = loginScreen;
      } else {
        println("Please Choose a role");
      }
    }
  }
  );

  //HOMESCREEN
  assignments = new Window(width-450, 300, 400, 800, "AssignmentsWindow");
  assignments.elements.add(new TextDisplay("AssignMentHeader", "Assignments", 20, 40, 40, assignments));
  List asssignmentList = new List("Assignments", "", 10, 50, 380, assignments)
  {
    public void addElements() {
      elements.add(new Assignment("Fysik rapport", "Lav en fucking rapport fag"));
      elements.add(new Assignment("Kemi rapport", "Plz lav en kemi rapport UwU"));
      elements.add(new Assignment("Dansk Stil", "Lav en bigass kæmpe fucking dansk Stil"));
      elements.add(new Assignment("Placeholder", "Alle assignmentsne skal være indivudueller for hver klasse."));
    }
  };
  assignments.elements.add(asssignmentList);
  homeScreen.windows.add(assignments);

  //TOPMENU
  topMenu = new Window(0, 0, width, 200, "TopMenu");
  topMenu.elements.add(new TextDisplay("Header", "The New Lectio", 20, 60, 60, topMenu));
  topMenu.elements.add(new screenButton("Logout", "Logout", width-130, 160, 100, 25, topMenu, loginScreen) {
    public void extraAction() {
      userName = null;
      userClass = null;
      role = null;
    }
  }
  );
  homeScreen.windows.add(topMenu);
  
  //Success and error windows. Setting their time to 1 second.
  //ERRORWINDOW
  errorWindow = new TimedWindow(0, 0, width, 200, "Error", 1000);
  errorWindow.backdropColor = color(255, 0, 0, 125);
  errorWindow.elements.add(new TextDisplay("ErrorMessage", "", width/2, 100, 60, errorWindow, CENTER, color(255)));
  
  //SUCCESSWINDOW
  successWindow = new TimedWindow(0, 0, width, 200, "Success", 1000);
  successWindow.backdropColor = color(0, 255, 0, 125);
  successWindow.elements.add(new TextDisplay("SuccessMessage", "", width/2, 100, 60, successWindow, CENTER, color(255)));
  
  //Adding the success and error window to all of the screens.
  loginScreen.windows.add(errorWindow);
  createUserScreen.windows.add(errorWindow);
  homeScreen.windows.add(errorWindow);
  loginScreen.windows.add(successWindow);
  createUserScreen.windows.add(successWindow);
  homeScreen.windows.add(successWindow);
}
