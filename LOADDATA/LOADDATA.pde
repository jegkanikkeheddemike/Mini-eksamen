import java.io.FileReader;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;

static BufferedReader DATA;
static ArrayList<Elev> Elever;

void setup() {
  Elever = new ArrayList<Elev>();
  connectToDatabase();
  loadEleverFromDb();
  String Line = "";
  String Split = ";";

  try {
    DATA = new BufferedReader(new FileReader("C:\\GitHub\\Mini-eksamen\\LOADDATA\\LoadData\\DATA.csv"));
    while ((Line = DATA.readLine()) != null) {
      String[] LineData = Line.split(Split);
      try {
        if (LineData[1].equals("Elev")) {
          String Name = LineData[3];
          String Klasse = LineData[2];
          Klasse = Klasse.substring(2, 5);
          Elev e = new Elev(Name, "DDU");

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

          Statement ElevSt = db.createStatement();
          ElevSt.executeUpdate("INSERT INTO students (studentname,classid,login,password) VALUES('"+e.Name+"','"+ClassID+"','"+e.Login+"','"+e.Pass+"')");
        }
      } 
      catch (Exception e) {
      }
    }
    println("____");
    for (Elev e : Elever) {
      System.out.println(e.Login + " " + e.Pass);
    }
  } 
  catch (FileNotFoundException e) {
    System.out.println(e);
  } 
  catch (IOException e) {
    System.out.println(e);
  }
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
          println(Name + " found match with", e.Name);
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
    Pass += ""+char(int(random(101,122)));
    Pass += ""+char(int(random(101,122)));
    Pass += ""+char(int(random(101,122)));
    Pass += ""+char(int(random(101,122)));
    return Pass;
  }
}
