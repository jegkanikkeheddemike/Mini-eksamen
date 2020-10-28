void setupLoginScreen() {
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
}

void login() {
  Thread loginThread = new Thread() {
    public void run() {
      String username = loginWindow.getElement("Username").getOutput();
      String password = loginWindow.getElement("Password").getOutput();
      println(username);
      try {
        Statement st = db.createStatement();
        ResultSet rs = st.executeQuery("SELECT * FROM users WHERE(login = '"+username+"' AND userpassword='"+password+"')");
        if (rs.next()) {
          userName = rs.getString("username");
          role = rs.getString("role");
          if (role.equals("student")) {
            userClass = rs.getString("classid");
          } else {
            userClass = null;
          }
          st.close();
          rs.close();
          println("logged in as", userName);
          activeScreen = homeScreen;
          //Clear the userlogin & password textbox
          loginWindow.getElement("Username").clearText();
          loginWindow.getElement("Password").clearText();
        }
      } 
      catch (Exception e) {
        println(e);
      }
    }
  };
  loginThread.run();
}
