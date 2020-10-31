void setupLoginScreen() {
  //LOGINSCREEN
  loginWindow = new Window(width/2-200, height/2-300, 400, 600, "LoginWindow");
  loginScreen.windows.add(loginWindow);

  loginWindow.elements.add(new TextDisplay("Login", "Login", 200, 80, 45, loginWindow, CENTER));

  MultiChoice SelectRole = new MultiChoice("Role", "Role", 20, 100, loginWindow);  
  {//Select roles  
    SelectRole.Choices.add(new Choice("Student"));  
    SelectRole.Choices.add(new Choice("Teacher"));
  }  
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
  try {
    Statement st = db.createStatement();
    ResultSet rs = st.executeQuery("SELECT * FROM tests");
    while (rs.next()) {
      assignmentList.elements.add(new Assignment(rs.getString("TestName"),rs.getString("testSubject"),rs.getInt("TestID")));
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

      if (role != null) {
        try {
          if (role.equals("Student")) {
            Statement st = db.createStatement();
            ResultSet rs = st.executeQuery("SELECT Students.studentid AS Studentid, Students.StudentName AS StudentName, Classes.ClassName AS ClassName, Students.Password AS Password FROM Students, Classes WHERE (Students.Login = '"+login+"') AND (Classes.ClassID = Students.ClassID);");
            if (rs.next()) {
              String actualPassword = rs.getString("Password");
              if (password.equals(actualPassword)) {
                String realName = rs.getString("StudentName");
                String className = rs.getString("ClassName");
                int studentID = rs.getInt("studentid");

                //UPDATE SESSION
                mainSession.updateStudent(realName, login, role, className,studentID);

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
            ResultSet rs = st.executeQuery("SELECT TeacherName, Password, ClassIDs FROM Teachers WHERE (Login = '"+login+"');");
            if (rs.next()) {
              String actualPassword = rs.getString("Password");
              if (password.equals(actualPassword)) {
                String realName = rs.getString("TeacherName");
                //We get the array of classIDs which is a sql Array which we then cast into an int array
                java.sql.Array sqlClassIDs = rs.getArray("ClassIDs");
                //We have to handle the case where the teachers doesn't yet have any classes
                if (sqlClassIDs != null) {
                  Integer[] classIDs = (Integer[]) sqlClassIDs.getArray();
                  //UPDATE SESSION
                  mainSession.updateTeacher(realName, login, role, classIDs);
                } else {
                  Integer[] classIDs = new Integer[0];
                  mainSession.updateTeacher(realName, login, role, classIDs);
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
