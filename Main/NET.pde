Connection db;
import java.sql.*;
String connectionStatus = "Connecting to database...";
boolean isConnected = false;
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
        connectionStatus = "Connected to database.";
        isConnected = true;
        println("Connected to database at", millis(), "ms");
      }
      catch (java.sql.SQLException e) {
        connectionStatus = "Failed to connect to database";
        System.out.println(e.getMessage());
      }
    }
  };
  connectThread.start();
}
