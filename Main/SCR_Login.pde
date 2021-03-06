void setupLoginScreen() {
  //LOGINSCREEN
  loginWindow = new Window(width/2-200, height/2-300, 400, 600, "LoginWindow");
  loginScreen.windows.add(loginWindow);

  loginWindow.elements.add(new TextDisplay("Login", "Login", 200, 80, 45, loginWindow, CENTER));
  loginWindow.elements.add(new TextDisplay("LoadStatus", "Connecting to databse...", 20, loginWindow.sizeY-25, 20, loginWindow, LEFT) {
    public void stepAlways() {
      description = connectionStatus;
    }
  }
  );

  MultiChoice SelectRole = new MultiChoice("Role", "Role", 20, 100, loginWindow);   
  SelectRole.choices.add(new Choice("Student", SelectRole));  
  SelectRole.choices.add(new Choice("Teacher", SelectRole));
  SelectRole.choices.get(0).isActive = true;

  loginWindow.elements.add(SelectRole);

  loginWindow.elements.add(new TextBox("LoginName", "Login Name", 20, 200, 360, 40, loginWindow) {
    public void reactEnter() {
      owner.getElement("LoginButton").reactClickedOn();
    }
  }
  );
  loginWindow.elements.add(new TextBox("Password", "Password", 20, 300, 360, 40, loginWindow) {
    public void reactEnter() {
      owner.getElement("LoginButton").reactClickedOn();
    }
  }
  );

  loginWindow.elements.add(new Button("LoginButton", "Press to login", 90, 400, 220, 40, loginWindow) {
    public void reactClickedOn() {
      login();
    }
  }
  );
  loginWindow.elements.add(new Button("NewUser", "New User", 90, 500, 220, 40, loginWindow) {
    public void reactClickedOn() {
      activeScreen = createUserScreen;
    }
  }
  );
}

void clearLoginFields() {
  //Clear the userlogin & password textbox
  loginWindow.getElement("Role").clearText();
  loginWindow.getElement("LoginName").clearText();
  loginWindow.getElement("Password").clearText();
}

void loginSuccess(String realName) {
  //Show a successmessage
  successWindow.getElement("SuccessMessage").description = "Welcome " + realName; 
  successWindow.show();
  clearLoginFields();
  topMenu.getElement("Username").description = realName;
  updateAssignments();
  updateTopMenu();
  if (mainSession.role.equals("Teacher")) {
    updateTeacherTests();
  }
  for (UIElement u : studentAssignmentList.elements) {
    Assignment a = (Assignment) u;
    a.updateRightness();
  }
  println("USERID: " + mainSession.userID);
}

void updateAssignments() {
  /*
     AssignmentID SERIAL PRIMARY KEY,
   TeacherID INT NOT NULL,
   ClassID INT NOT NULL,
   TestID INT NOT NULL,
   DueDate TEXT NOT NULL
   */
  studentAssignmentList.elements.clear();
  teacherAssignmentList.elements.clear();
  if (mainSession.role.equals("Student")) {
    try {
      Statement st = db.createStatement();
      //Give all the assignments that belong to the students class.
      ResultSet rs = st.executeQuery("SELECT AssignmentID, Assignments.TestID AS TestID, Assignments.DueDate AS DueDate, Tests.TestSubject AS TestSubject, Tests.TestName as TestName FROM Assignments, Tests WHERE (Assignments.TestID = Tests.TestID) AND (Assignments.ClassID = "+mainSession.studentClassID+");");
      while (rs.next()) {
        //HANDLE THE DATE BETTER?
        studentAssignmentList.elements.add(new Assignment(rs.getInt("AssignmentID"), rs.getString("TestName"), rs.getString("TestSubject"), rs.getInt("TestID"),rs.getString("duedate")));
      }
    } 
    catch (Exception e) {
      e.printStackTrace();
    }
  } else if (mainSession.role.equals("Teacher")) {
    try {
      Statement st = db.createStatement();
      ResultSet rs = st.executeQuery("SELECT Assignments.AssignmentID AS AssignmentID, Assignments.TestID AS TestID, Tests.TestSubject AS TestSubject, Tests.TestName AS TestName, Assignments.ClassID AS ClassID, Classes.ClassName AS ClassName, Assignments.DueDate AS DueDate FROM Assignments, Tests, Classes WHERE (Assignments.TestID = Tests.TestID) AND (Assignments.ClassID = Classes.ClassID) AND (Assignments.TeacherID = "+mainSession.userID+");");
      while (rs.next()) {
        //HANDLE THE DATE BETTER?
        teacherAssignmentList.elements.add(new Assignment(rs.getInt("AssignmentID"), rs.getString("TestName"), rs.getString("TestSubject"), rs.getInt("TestID"), rs.getInt("ClassID"),rs.getString("ClassName"),rs.getString("DueDate")));
      }
    } 
    catch (Exception e) {
      e.printStackTrace();
    }
  }
}

void updateTeacherTests() {
  teacherTestList.elements.clear();

  try {
    Statement st = db.createStatement();
    //Give all the assignments that belong to the students class.
    ResultSet rs = st.executeQuery("SELECT * FROM Tests;");
    while (rs.next()) {
      teacherTestList.elements.add(new Test(rs.getInt("TestID"), rs.getString("TestName"), rs.getString("TestSubject"), rs.getString("TestInfo")));
    }
  } 
  catch (Exception e) {
    e.printStackTrace();
  }
}

void login() {
  Thread loginThread = new Thread() {
    public void run() {
      String role  = loginWindow.getElement("Role").getOutput(); //Be careful this might be null.
      String login = loginWindow.getElement("LoginName").getOutput();
      String password = loginWindow.getElement("Password").getOutput();
      println(role, login, password);
        
      if (!isConnected) {
        errorWindow.getElement("ErrorMessage").description = "Failed to connect to Database.\nStatus: " + connectionStatus; 
        errorWindow.show();
        return;
      }


      if (role != null) {
        try {
          if (role.equals("Student")) {
            Statement st = db.createStatement();
            ResultSet rs = st.executeQuery("SELECT Students.studentid AS Studentid, Students.StudentName AS StudentName, Classes.ClassName AS ClassName, Students.Password AS Password, Students.ClassID AS ClassID FROM Students, Classes WHERE (Students.Login = '"+login+"') AND (Classes.ClassID = Students.ClassID);");
            if (rs.next()) {
              String actualPassword = rs.getString("Password");
              if (password.equals(actualPassword)) {
                String realName = rs.getString("StudentName");
                String className = rs.getString("ClassName");
                int studentID = rs.getInt("StudentID");
                int classID = rs.getInt("ClassID");
                //UPDATE SESSION
                mainSession.updateStudent(realName, login, role, className, studentID, classID);

                loginSuccess(realName);
                activeScreen = homeStudentScreen;
              } else {
                errorWindow.getElement("ErrorMessage").description = "The password was incorrect"; 
                errorWindow.show();
              }
              rs.close();
              st.close();
            } else {
              //Throw an ERROR on screen
              errorWindow.getElement("ErrorMessage").description = "There is no student with that login"; 
              errorWindow.show();
            }
          } else if (role.equals("Teacher")) {
            Statement st = db.createStatement();
            ResultSet rs = st.executeQuery("SELECT TeacherID, TeacherName, Password, ClassIDs FROM Teachers WHERE (Login = '"+login+"');");
            if (rs.next()) {
              String actualPassword = rs.getString("Password");
              if (password.equals(actualPassword)) {
                String realName = rs.getString("TeacherName");
                int ID = rs.getInt("TeacherID");
                //We get the array of classIDs which is a sql Array which we then cast into an int array
                java.sql.Array sqlClassIDs = rs.getArray("ClassIDs");
                //We have to handle the case where the teachers doesn't yet have any classes
                if (sqlClassIDs != null) {
                  Integer[] classIDs = (Integer[]) sqlClassIDs.getArray();
                  //UPDATE SESSION
                  mainSession.updateTeacher(realName, login, role, classIDs, ID);
                } else {
                  Integer[] classIDs = new Integer[0];
  

                  mainSession.updateTeacher(realName, login, role, classIDs, ID);
                }
                loginSuccess(realName);
                activeScreen = homeTeacherScreen;
              } else {
                errorWindow.getElement("ErrorMessage").description = "The password was incorrect"; 
                errorWindow.show();
              }
              st.close();
              rs.close();
            } else {
              //Throw an ERROR on screen
              errorWindow.getElement("ErrorMessage").description = "There is no teacher with that login"; 
              errorWindow.show();
            }
          }
        }
        catch (Exception e) {
          e.printStackTrace();
        }
      } else {
        //Throw an ERROR on screen
        errorWindow.getElement("ErrorMessage").description = "Please choose a role"; 
        errorWindow.show();
      }
    }
  };
  loginThread.run();
}
