package datapackage;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;

public class LoadData {
  static BufferedReader DATA;
  static ArrayList<Elev> Elever;

  public static void main(String[] args) {
    String Line = "";
    String Split = ";";
    Elever = new ArrayList<Elev>();
    try {
      DATA = new BufferedReader(new FileReader("DATA.csv"));
      while ((Line = DATA.readLine()) != null) {
        String[] LineData = Line.split(Split);
        try {
          if (LineData[1].equals("Elev")) {
            String Name = LineData[3];
            String Klasse = LineData[2];
            Klasse = Klasse.substring(2, 5);
            Elever.add(new Elev(Name, Klasse));
          }
        } catch (Exception e) {
        }
      }
      for (Elev i : Elever) {
        System.out.println(i.Name + " " + i.Klasse);
      }
    } catch (FileNotFoundException e) {
      System.out.println(e);
    } catch (IOException e) {
      System.out.println(e);
    }

  }
}

class Elev {
  String Name;
  String Klasse;

  public Elev(String Name, String Klasse) {
    this.Name = Name;
    this.Klasse = Klasse;
  }
}
