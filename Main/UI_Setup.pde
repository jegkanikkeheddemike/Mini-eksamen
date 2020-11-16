/*
UI_Setup skal deles op i flere underfunktioner som deles ud i filer.
 Hvor funktionerne fra NET er med i den pågældende fil
 Altså knap-reaktions-funktioner er i samme fil som UI den høre til.
 */


Screen loginScreen = new Screen();
Screen createUserScreen = new Screen();
Screen homeTeacherScreen = new Screen();
Screen homeStudentScreen = new Screen();
Screen assignTeamScreen = new Screen();
Screen newTestScreen = new Screen();
Screen createAssignmentScreen = new Screen();
volatile Screen activeScreen = loginScreen;

Window loginWindow;
Window createUserWindow;
Window topMenu;
Window studentAssignments;

Window teacherAssignments;
Window teacherTests;
Window takeTest;
Window makeTest;
Window makeQuestion;

Window assignTeamWindow;
Window existingTeams;

Window createAssignmentWindow;

TimedWindow errorWindow;
TimedWindow successWindow;

List studentAssignmentList;
List teacherAssignmentList;
List teacherTestList;
List makeQuestionAnswerList;
List createAssTestList;
List createAssClassList;
MultiChoice answerRight;
ElevTest ETest;

//SPLIT THISPERATE SETUP FUNCTIONS THAT ARE THEN CALLED IN HERE
void UI_Setup() {
  setupLoginScreen();
  setupCreateUserScreen();
  setupTeacherAssignmentsWindow();
  setupTeacherTestsWindow();
  setupHomeTeacherScreen();
  setupStudentAssignmentsWindow();
  setupHomeStudentScreen();
  setupAssignTeamScreen();
  setupMakeTestWindow();
  setupMakeQuestionWindow();
  setupNewTestScreen();
  setupCreateAssignmentScreen();
  setupUniversalWindows();
}


void setupUniversalWindows() {
  setupTopMenu();
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
  homeTeacherScreen.windows.add(errorWindow);
  homeStudentScreen.windows.add(errorWindow);
  assignTeamScreen.windows.add(errorWindow);
  newTestScreen.windows.add(errorWindow);
  createAssignmentScreen.windows.add(errorWindow);

  loginScreen.windows.add(successWindow);
  createUserScreen.windows.add(successWindow);
  homeTeacherScreen.windows.add(successWindow);
  homeStudentScreen.windows.add(successWindow);
  assignTeamScreen.windows.add(successWindow);
  newTestScreen.windows.add(successWindow);
  createAssignmentScreen.windows.add(successWindow);
}


void setupTopMenu() {
  //TOPMENU
  topMenu = new Window(0, 0, width, 200, "TopMenu");
  topMenu.elements.add(new TextDisplay("Header", "The New Lectio", 20, 60, 60, topMenu));
  topMenu.elements.add(new TextDisplay("Username", mainSession.userName, 20, 120, 30, topMenu));
  topMenu.elements.add(new Button("Backbutton", "Back", width-210, 160, 60, 25, topMenu) {
    public void reactClickedOn() {
      if (mainSession.role.equals("Student")) {
        activeScreen = homeStudentScreen;
      } else {
        activeScreen = homeTeacherScreen;
      }
      pickedClassIDs.clear();
      pickedTestIDs.clear();
    }
  }
  );
  topMenu.elements.add(new ScreenButton("Logout", "Logout", width-130, 160, 100, 25, topMenu, loginScreen) {
    public void extraAction() {
      ETest.questions.clear();
      List answerList = (List) takeTest.getElement("CheckCorrect");
      answerList.elements.clear();
      takeTest.getElement("CheckCorrect").isVisible = false;
    }
  }
  );
  homeTeacherScreen.windows.add(topMenu);
  homeStudentScreen.windows.add(topMenu);
  assignTeamScreen.windows.add(topMenu);
  newTestScreen.windows.add(topMenu);
  createAssignmentScreen.windows.add(topMenu);
}

void updateTopMenu() {
  if (mainSession.role == "Teacher") {
    topMenu.removeElement("Classes");
    topMenu.elements.add(new HoriList("Classes", "", 10, 160, 27, topMenu) {
      public void addElements() {
        try {
          for (Integer ID : mainSession.classIDs) {
            Statement st = db.createStatement();
            ResultSet rs = st.executeQuery ("SELECT * FROM Classes WHERE ClassID = "+ID+";");
            rs.next();
            String className = rs.getString("ClassName");
            textSize(30);
            elements.add(new ClassButton("CLASS", className, 0, 0, (int) textWidth(className), 30, ID, topMenu));
            rs.close();
            st.close();
          }
        }
        catch(Exception e) {
          //e.printStackTrace();
        }
        elements.add(new ScreenButton("NEW CLASS", "+", 0, 0, 30, 30, topMenu, assignTeamScreen) {
          public void extraAction() {
            existingTeams.getElement("TeamsList").customInput(); //DEFINED IN SCR_ASSIGNTEAMS
          }
        }
        );
      }
    }
    );
  } else {
    topMenu.removeElement("Classes");
  }
}
