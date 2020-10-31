import java.io.File;
import java.io.IOException;
//THORPATH = processing-java --sketch="C:\Users\Thor Skipper\OneDrive\Dokumenter\GitHub\Mini-eksamen\Main" --run
class Runprogram {
    Console console;
    public static void main(String[] args) {
        String myPath = System.getProperty("user.dir");
        try {
        Runtime.getRuntime().exec("processing-java --sketch=\"" + myPath + "\\Main\" --run");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}