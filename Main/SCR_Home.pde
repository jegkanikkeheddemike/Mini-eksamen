void setupHomeScreen() {
  //HOMESCREEN
  assignments = new Window(width-450, 300, 400, 800, "AssignmentsWindow");
  assignments.elements.add(new TextDisplay("AssignMentHeader", "Assignments", 20, 40, 40, assignments));
  List asssignmentList = new List("Assignments", "", 10, 50, 380, assignments)
  {
    public void addElements() {
      elements.add(new Assignment("Fysik rapport", "Lav en fucking rapport fag"));
      elements.add(new Assignment("Kemi rapport", "Plz lav en kemi rapport UwU"));
      elements.add(new Assignment("Dansk Stil", "Lav en bigass kæmpe fucking dansk Stil"));
      elements.add(new Assignment("Placeholder", "Alle assignmentsne skal være indivudueller for hver klasse."));
    }
  };
  assignments.elements.add(asssignmentList);
  homeScreen.windows.add(assignments);
}
