Connection db;
import java.sql.*;
//HUSK!!
//Resultset executeQuery(String"") bruges til KUN til at hente data
//void updateQuery(String"") bruges Kun til at opdatere data i databasen 

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
//MAKE THIS INTO A SESSION CLASS!!
String userName;
String userClass;
String role;
