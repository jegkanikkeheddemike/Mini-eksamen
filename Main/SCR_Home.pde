void setupHomeTeacherScreen() {
  //HOMESCREEN
  assignments = new Window(width-450, 300, 400, height-400, "AssignmentsWindow");
  assignments.elements.add(new TextDisplay("AssignMentHeader", "Assignments", 20, 40, 40, assignments));
  asssignmentList = new List("Assignments", "", 10, 50, 380, assignments);
  
  assignments.elements.add(asssignmentList);
  homeTeacherScreen.windows.add(assignments);
}

void setupHomeStudentScreen() {
  //HOMESCREEN
  homeStudentScreen.windows.add(assignments);
  
  takeTest = new Window(50,300,width-550,height-400,"takeTestWindow");
  ETest = new ElevTest("ElevTest","Her tager du dine tests");
  takeTest.elements.add(ETest);
  takeTest.elements.add(new Button("NQButton","Next",width-800,height-530,220,100,takeTest){
    public void reactClickedOn() {
      if (ETest.Questions.size() > ETest.CQuestionIndex+1)
        ETest.CQuestionIndex++;
    }
  }
  );

  homeStudentScreen.windows.add(takeTest);
}
