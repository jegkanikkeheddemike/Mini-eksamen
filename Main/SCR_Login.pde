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
  successWindow.getElement("SuccessMessage").setText("Welcome " + realName); 
  successWindow.show();
  clearLoginFields();
  activeScreen = homeScreen;
}

void login() {
  Thread loginThread = new Thread() {
    public void run() {
      String role  = loginWindow.getElement("Role").getOutput(); //Be careful this might be null.
      String login = loginWindow.getElement("LoginName").getOutput();
      String password = loginWindow.getElement("Password").getOutput();

      if (role != null) {
        try {
          if (role.equals("Student")) {
            Statement st = db.createStatement();

            ResultSet rs = st.executeQuery("SELECT Students.StudentName AS StudentName, Classes.ClassName AS ClassName, Students.Password AS Password FROM Students, Classes WHERE (Students.Login = '"+login+"') AND (Classes.ClassID = Students.ClassID);");
            if (rs.next()) {
              String actualPassword = rs.getString("Password");
              if (password.equals(actualPassword)) {
                String realName = rs.getString("StudentName");
                String className = rs.getString("ClassName");

                //UPDATE SESSION
                mainSession.updateStudent(realName, login, role, className);

                loginSuccess(realName);
              } else {
                errorWindow.getElement("ErrorMessage").setText("The password was incorrect"); 
                errorWindow.show();
              }
              st.close();
              rs.close();
            } else {
              //Throw an ERROR on screen
              errorWindow.getElement("ErrorMessage").setText("There is no student with that login"); 
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
              } else {
                errorWindow.getElement("ErrorMessage").setText("The password was incorrect"); 
                errorWindow.show();
              }
              st.close();
              rs.close();
            } else {
              //Throw an ERROR on screen
              errorWindow.getElement("ErrorMessage").setText("There is no teacher with that login"); 
              errorWindow.show();
            }
          }
        }
        catch (Exception e) {
          println(e);
        }
      } else {
        //Throw an ERROR on screen
        errorWindow.getElement("ErrorMessage").setText("Please choose a role"); 
        errorWindow.show();
      }
    }
  };
  loginThread.run();
}
