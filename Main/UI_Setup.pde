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
  setupLoginScreen();
  setupCreateUserScreen();
  setupHomeScreen();
  setupUniversalWindows();
}

  //HOMESCREEN
  assignments = new Window(width-450, 300, 400, 800, "AssignmentsWindow");
  assignments.elements.add(new textDisplay("AssignMentHeader", "Assignments", 20, 40, 40, assignments));
  List asssignmentList = new List("Assignments", "", 10, 50, 380, assignments)
  {
    public void addElements() {
      elements.add(new Assignment("Fysik rapport", "Lav en fucking rapport fag"));
      elements.add(new Assignment("Kemi rapport", "Plz lav en kemi rapport UwU"));
      elements.add(new Assignment("Dansk Stil", "Lav en bigass kæmpe fucking dansk Stil"));
      elements.add(new Assignment("Placeholder", "Alle assignmentsne skal være indivudueller for hver klasse."));
    }
  };
  /*
  
  
  ArrayList<String> classList = new ArrayList<String>();
  classList.add("3ak");
  classList.add("3a");
  List classesList = new List("Classes","",){
    
    
  }
  

  
  for(String classes: classesList){
    
  }
  //assignments.elements.add(new screenButton());
  */
  
  assignments.elements.add(asssignmentList);
  homeScreen.windows.add(assignments);


void setupUniversalWindows() {
  //TOPMENU
  topMenu = new Window(0, 0, width, 200, "TopMenu");
  topMenu.elements.add(new TextDisplay("Header", "The New Lectio", 20, 60, 60, topMenu));
  topMenu.elements.add(new ScreenButton("Logout", "Logout", width-130, 160, 100, 25, topMenu, loginScreen) {
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
