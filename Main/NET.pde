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
      String username = loginWindow.findElement("Username").getOutput();
      String password = loginWindow.findElement("Password").getOutput();
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
          Window loginWindow = loginScreen.windows.get(0);
          
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

void createLogin() {
  Thread createLoginThread = new Thread() {
    public void run() {
      try {
        //username
      } 
      catch(Exception e) {
        println(e);
      }


      println("Trying to create login, but its 23:33 and im too tired to keep working right now :} instead log in as Thor9987 / thorPass");
    }
  };
  createLoginThread.start();
}
