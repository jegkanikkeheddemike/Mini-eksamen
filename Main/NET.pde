Connection db;
import java.sql.*;
void connectToDatabase() {
  Thread connectThread = new Thread() {
    public void run() {
      try {
        Class.forName("org.postgresql.Driver");
      }
      catch (java.lang.ClassNotFoundException e) {
        System.out.println(e.getMessage());
      }
      String dataBaseUsername = "rerxoubu";
      String dataBasePassword = "kNVkLOXQ6d38WUGrUXvrXL6odC2F_9yN";
      String url = "jdbc:postgresql://hattie.db.elephantsql.com:5432/rerxoubu";

      try {
        db = DriverManager.getConnection(url, dataBaseUsername, dataBasePassword);
        println("Connecet to database at", millis(), "ms");
      }
      catch (java.sql.SQLException e) {
        System.out.println(e.getMessage());
      }
    }
  };
  connectThread.start();
}
//LOGGED IN USERDATA
String userName;
String userClass;
String role;

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
            userClass = rs.getString("class");
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

void createLoginSuccess() {
  //If we successfully create the new user the text and multiple choice fields should be cleared
  createUserWindow.getElement("ChooseRole").clearText();
  createUserWindow.getElement("CreateLogin").clearText();
  createUserWindow.getElement("CreatePassword").clearText();
  createUserWindow.getElement("CreatePasswordAgain").clearText();
  createUserWindow.getElement("CreateRealName").clearText();
  createUserWindow.getElement("CreateClass").clearText();

  //Show a successmessage
  successWindow.getElement("SuccessMessage").setText("A new user was successfully created"); 
  successWindow.show();
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
