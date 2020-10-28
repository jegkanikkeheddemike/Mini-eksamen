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

void createLogin() {
  Thread createLoginThread = new Thread() {
    public void run() {
      println("RUNNING CREATE LOGIN");
      try {
        //ChooseRole, CreateLogin, CreatePassword, CreatePasswordAgain, CreateRealName, CreateClass
        //Get information from TextBoxes
        String role = createUserWindow.getElement("ChooseRole").getOutput(); //Can be null if a role is not chosen
        String login = createUserWindow.getElement("CreateLogin").getOutput();
        String password1 = createUserWindow.getElement("CreatePassword").getOutput();
        String password2 = createUserWindow.getElement("CreatePasswordAgain").getOutput();
        String userName  = createUserWindow.getElement("CreateRealName").getOutput();
        String className = createUserWindow.getElement("CreateClass").getOutput();

        println(role);
        println(login);
        println(password1);
        println(password2);
        println(userName);
        println(className);

        //We check whether there has been chosen a role
        if (role != null) {
          //We check whether the two passwords are the same
          if (password1.equals(password2)) {
            //We check whether the user already exists
            try {
              Statement st = db.createStatement();
              ResultSet rs = st.executeQuery("SELECT * FROM Users WHERE login = '"+login+"';");
              //If the user already exists
              if (rs.next()) {
                //Throw an ERROR on screen
                errorWindow.getElement("ErrorMessage").setText("The user already exists"); 
                errorWindow.show();

                rs.close();
                st.close();
              } else {
                //If the user doesn't already exists
                rs.close();
                st.close();
                //If it is a student we need to check whether the class they wrote already exists
                try {
                  if (role.equals("Student")) {
                    st = db.createStatement();
                    rs = st.executeQuery("SELECT ClassID FROM Classes WHERE ClassName = '"+className+"';");
                    //If the class exists
                    if (rs.next()) {

                      int classID = rs.getInt("ClassID");

                      rs.close();
                      st.close();
                      //We make a new user with the listed information
                      try {
                        st = db.createStatement();
                        //We should probably hash the password at some point.
                        rs = st.executeQuery("INSERT INTO Users (UserName, Role, ClassID, Login, UserPassword) VALUES ('"+userName+"', '"+role+"', "+str(classID)+", '"+login+"', '"+password1+"');");
                        rs.close();
                        st.close();
                        
                        createLoginSuccess();
                      }
                      catch(java.sql.SQLException e) {
                        println(e);
                      }
                    } else {
                      //The class has to exist already so we give a warning
                      errorWindow.getElement("ErrorMessage").setText("The class you are trying to join does not exist"); 
                      errorWindow.show();
                      rs.close();
                      st.close();
                    }
                  } else if (role.equals("Teacher")) {
                    rs.close();
                    st.close();
                    //We make a new user with the listed information
                    st = db.createStatement();
                    //We should probably hash the password at some point.
                    //For the teacher the class is irrelevant as they should be able to choose them themselves.
                    rs = st.executeQuery("INSERT INTO Users (UserName, Role, ClassID, Login, UserPassword) VALUES ('"+userName+"', '"+role+"', "+str(0)+", '"+login+"', '"+password1+"');");
                    rs.close();
                    st.close();
                    
                    createLoginSuccess();
                  }
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
        } else {
          //Throw an ERROR on screen
          errorWindow.getElement("ErrorMessage").setText("Please choose a role"); 
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
