
class Screen {
  String name;
  ArrayList<Window> windows = new ArrayList<Window>();
  void run() {
    background(230);
    for (Window i: windows) {
      i.stepWindow();
    }
    for (Window i: windows) {
      i.drawWindow();
    }
  }
}
