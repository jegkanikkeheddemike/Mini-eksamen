import java.io.FileReader;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;


ArrayList<Elev> Elever = new ArrayList<Elev>();
static BufferedReader DATA;

boolean addcsvToDb(String cName, String fName) {
  Elever.clear();
  String dirpath = dataPath("");
  loadEleverFromDb();
  String Line = "";
  String Split = ";";
  boolean returnThis = true;

  try {
    String file = dirpath+"\\"+fName;
    //println(file);
    DATA = new BufferedReader(new FileReader(file));
    //println(DATA.);


    //println("DATA EXISTS");
      String[] LineData = Line.split(Split);
    while ((Line = DATA.readLine()) != null) {
      try {
        if (LineData[1].equals("Elev")) {
          String Name = LineData[3];
          String Klasse = LineData[2];
          Klasse = Klasse.substring(2, 5);
          Elev e = new Elev(Name, cName);

          Statement ClassSt = db.createStatement();
          ResultSet ClassRs = ClassSt.executeQuery("SELECT * FROM classes WHERE(classname = '"+e.Klasse+"');");
          int ClassID;
          if (ClassRs.next()) {
            ClassID = ClassRs.getInt("classid");
          } else {
            Statement NewClass = db.createStatement();
            NewClass.executeUpdate("INSERT INTO classes (classname) VALUES('"+e.Klasse+"')");
            NewClass.close();
            ClassRs = ClassSt.executeQuery("SELECT * FROM classes WHERE(classname = '"+e.Klasse+"');");
            ClassID = ClassRs.getInt("classid");
          }

          Statement ElevSt = db.createStatement();  //Koden nedenunder bliver åbenbart ikke kørt??????
          ElevSt.executeUpdate("INSERT INTO students (studentname,classid,login,password) VALUES('"+e.Name+"','"+ClassID+"','"+e.Login+"','"+e.Pass+"')");
          ElevSt.close();
          println("Added:",e.Name,",",ClassID,",",e.Login,",",e.Pass,"To Database");
        }
      } 
      catch (Exception e) {
      }
    }
  } 
  catch (FileNotFoundException e) {
    //System.out.println(e.getMessage());
    returnThis = false;
  } 
  catch (IOException e) {
    System.out.println(e);
    returnThis = false;
  }
  return returnThis;
}


class Elev {
  String Name;
  String Klasse;
  String Login;
  String Pass = "PASS PLACEHOLDER";

  public Elev(String Name, String Klasse) {
    this.Name = Name;
    this.Klasse = Klasse;
    this.Login = makeLogin(Name);
    this.Pass = makePass();
    Elever.add(this);
  }
  String makeLogin(String Name) {
    int nameNr = 0;
    String Login = "";
    boolean noMatch = false;
    while (noMatch == false) {
      //println("MAKING FOR " + Name + nameNr);
      Login = Name.substring(0, 4)+nameNr;
      boolean foundMatch = false;
      for (Elev e : Elever) {
        if (e.Login.equals(Login)) {
          //println(Name + " found match with", e.Name);
          nameNr++;
          foundMatch = true;
        }
      }
      if (!foundMatch) {
        noMatch = true;
      }
    }
    return Login;
  }
  String makePass() {
    String Pass = "";
    Pass += ""+char(int(random(101, 122)));
    Pass += ""+char(int(random(101, 122)));
    Pass += ""+char(int(random(101, 122)));
    Pass += ""+char(int(random(101, 122)));
    return Pass;
  }
}



void loadEleverFromDb() {
  try {
    Statement st = db.createStatement();
    ResultSet rs = st.executeQuery("SELECT * FROM students");
    int loadedElever = 0;

    

    while (rs.next()) {
      Statement st2 = db.createStatement();
      ResultSet rs2 = st2.executeQuery("SELECT * FROM classes WHERE(classid = '" + rs.getInt("classid") + "')");
      rs2.next();
      Elev e = new Elev(rs.getString("studentname"), rs2.getString("classname") );
      e.Pass = rs.getString("password");
      //println("Loaded", rs.getString("studentname") , rs2.getString("classname"));
      loadedElever ++;
    }
    st.close();
    rs.close();
    //println("Loaded", loadedElever, "elever");
    //println("Antal elever", Elever.size());
  } 
  catch (Exception e) {
    e.printStackTrace();
  }
}
