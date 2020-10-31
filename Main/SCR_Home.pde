void setupHomeTeacherScreen() {
  //HOMESCREEN
  assignments = new Window(width-450, 300, 400, height-400, "AssignmentsWindow");
  assignments.elements.add(new TextDisplay("AssignMentHeader", "Assignments", 20, 40, 40, assignments));
  assignmentList = new List("Assignments", "", 10, 50, 380, assignments);

  assignments.elements.add(assignmentList);
  homeTeacherScreen.windows.add(assignments);
}

void setupHomeStudentScreen() {
  //HOMESCREEN
  homeStudentScreen.windows.add(assignments);

  takeTest = new Window(50, 300, width-550, height-400, "takeTestWindow");
  ETest = new ElevTest("ElevTest", "Her tager du dine tests");
  takeTest.elements.add(ETest);
  takeTest.elements.add(new Button("NQButton", "Next", width-800, height-530, 220, 100, takeTest) {
    public void reactClickedOn() {
      if (ETest.Questions.size() > ETest.CQuestionIndex) {
        try {
          String correctness;
          Question Q = ETest.Questions.get(ETest.CQuestionIndex);
          if (Q.answers.getOutput() == Q.AnswerList.get(Q.rightAnswerIndex)) {
            correctness = "RIGHT";
          } else {
            correctness = "WRONG";
          }
          Statement st = db.createStatement();
          st.executeUpdate("INSERT INTO answers (studentid,assignmentid,questionid,answer,correctness) VALUES("+mainSession.userID+","+ETest.testID+","+ Q.QID+",'" +Q.answers.getOutput()+"','" + correctness+"')");
          st.close();
        } 
        catch (Exception e) {
          e.printStackTrace();
        }
        if (ETest.Questions.size() > ETest.CQuestionIndex+1) {
          ETest.CQuestionIndex++;
        } else {
          ETest.Questions.clear();
        }
      }
    }
    public void stepAlways() {
      if (ETest.Questions.size()-1 == ETest.CQuestionIndex) {
        description = "Finish";
        isVisible = true;
      } else if (ETest.Questions.size() == 0) {
        isVisible = false;
      } else {
        description = "Next";
        isVisible = true;
      }
      
    }
  }
  );

  homeStudentScreen.windows.add(takeTest);
}
