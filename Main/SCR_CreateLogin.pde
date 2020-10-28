void setupCreateUserScreen() {
  //CREATE USER SCREEN
  createUserWindow = new Window(width/2-200, height/2-400, 400, 800, "CreateUserWindow");
  createUserScreen.windows.add(createUserWindow);

  createUserWindow.elements.add(new TextDisplay("CreateUser", "Create Teacher Profile", 200, 80, 45, createUserWindow, CENTER));

  createUserWindow.elements.add(new TextBox("CreateLogin", "Login", 20, 280, 360, 40, createUserWindow) {
    public void reactEnter() {
      owner.getElement("CreateTeacherButton").reactClickedOn();
    }
  }
  );

  createUserWindow.elements.add(new TextBox("CreatePassword", "Password", 20, 380, 360, 40, createUserWindow) {
    public void reactEnter() {
      owner.getElement("CreateTeacherButton").reactClickedOn();
    }
  }
  );

  createUserWindow.elements.add(new TextBox("CreatePasswordAgain", "Password again", 20, 480, 360, 40, createUserWindow) {
    public void reactEnter() {
      owner.getElement("CreateTeacherButton").reactClickedOn();
    }
  }
  );

  createUserWindow.elements.add(new TextBox("CreateRealName", "Real Name", 20, 580, 360, 40, createUserWindow) {
    public void reactEnter() {
      owner.getElement("CreateTeacherButton").reactClickedOn();
    }
  }
  );

  createUserWindow.elements.add(new Button("CreateTeacherButton", "Create Teacher", 90, createUserWindow.sizeY-50, 220, 40, createUserWindow) {
    public void reactClickedOn() {
      createLogin();
    }
  }
  );
}

void clearCreateLoginFields() {
  createUserWindow.getElement("CreateLogin").clearText();
  createUserWindow.getElement("CreatePassword").clearText();
  createUserWindow.getElement("CreatePasswordAgain").clearText();
  createUserWindow.getElement("CreateRealName").clearText();
}

void createLoginSuccess() {
  //If we successfully create the new user the text and multiple choice fields should be cleared
  clearCreateLoginFields();

  //Show a successmessage
  successWindow.getElement("SuccessMessage").setText("A new user was successfully created"); 
  successWindow.show();
  println("SUCCESS");
  
  //Switch back to login-screen
  activeScreen = loginScreen;
}


void createLogin() {
  Thread createLoginThread = new Thread() {
    public void run() {
      println("RUNNING CREATE LOGIN");
      try {
        //ChooseRole, CreateLogin, CreatePassword, CreatePasswordAgain, CreateRealName, CreateClass
        //Get information from TextBoxes
        String login = createUserWindow.getElement("CreateLogin").getOutput();
        String password1 = createUserWindow.getElement("CreatePassword").getOutput();
        String password2 = createUserWindow.getElement("CreatePasswordAgain").getOutput();
        String teacherName  = createUserWindow.getElement("CreateRealName").getOutput();

        //We check whether the two passwords are the same
        if (password1.equals(password2)) {
          //We check whether the teacher already exists
          try {
            Statement st = db.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM Teachers WHERE Login = '"+login+"';");
            //If the user already exists
            if (rs.next()) {
              //Throw an ERROR on screen
              errorWindow.getElement("ErrorMessage").setText("The login already exists"); 
              errorWindow.show();

              rs.close();
              st.close();
            } else {
              //If the teacher doesn't already exists
              rs.close();
              st.close();
              try {
                //We make a new teacher with the listed information
                st = db.createStatement();
                //We should probably hash the password at some point.!!!
                st.executeUpdate("INSERT INTO Teachers (TeacherName, Login, Password) VALUES ('"+teacherName+"', '"+login+"', '"+password1+"');");
                st.close();
                createLoginSuccess();
              }
              catch(java.sql.SQLException e) {
                println(e);
              }
            }
          }
          catch(java.sql.SQLException e) {
            println(e);
          }
        } else {
          //Throw an ERROR on screen
          errorWindow.getElement("ErrorMessage").setText("The passwords aren't the same"); 
          errorWindow.show();
        }
      } 
      catch(Exception e) {
        println(e);
      }
    }
  };
  createLoginThread.start();
}
