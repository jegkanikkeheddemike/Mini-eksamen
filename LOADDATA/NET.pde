Connection db;
import java.sql.*;

void connectToTestDatabase() {
  Thread connectThread = new Thread() {
    public void run() {
      try {
        Class.forName("org.postgresql.Driver");
      }
      catch (java.lang.ClassNotFoundException e) {
        System.out.println(e.getMessage());
      }
      String dataBaseUsername = "wffwnntn";
      String dataBasePassword = "HwrgVfubJlzRmOPCgRQ3UzMG6x-INHP1";
      String url = "jdbc:postgresql://hattie.db.elephantsql.com:5432/wffwnntn";

      try {
        db = DriverManager.getConnection(url, dataBaseUsername, dataBasePassword);
        println("Connecet to database at", millis(), "ms");
      }
      catch (java.sql.SQLException e) {
        System.out.println(e.getMessage());
      }
    }
  };
  connectThread.run();
}
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
  connectThread.run();
}


void loadEleverFromDb() {
  try {
    Statement st = db.createStatement();
    ResultSet rs = st.executeQuery("SELECT * FROM students");
    int loadedElever = 0;
    while (rs.next()) {
      new Elev(rs.getString("studentname"), "DDU");
      println("Loaded", rs.getString("studentname"));
      loadedElever ++;
    }
    st.close();
    rs.close();
    println("Loaded", loadedElever, "elever");
    println("Antal elever", Elever.size());
  } 
  catch (Exception e) {
    e.printStackTrace();
  }
}
