
void setupTeacherAssignmentsWindow(){
  teacherAssignments = new Window(width-450, 300, 400, height-400, "TeacherAssignmentsWindow");
  teacherAssignments.elements.add(new TextDisplay("TeacherAssignmentHeader", "Assignments", 20, 40, 40, teacherAssignments));
  teacherAssignmentList = new List("TeacherAssignments", "", 10, 50, 380,height-(400+50+60), teacherAssignments);
  teacherAssignments.elements.add(teacherAssignmentList);
  ScreenButton newAssignmentButton = new ScreenButton("NewAssignment", "+", 400/2-40/2, height-400-60, 40, 40, teacherAssignments,createAssignmentScreen);
  teacherAssignments.elements.add(newAssignmentButton);
}

void setupTeacherTestsWindow(){
  teacherTests = new Window(50, 300, 400, height-400, "TeacherTestsWindow");

  teacherTests.elements.add(new TextDisplay("TeacherTestHeader", "Tests", 20, 40, 40, teacherTests));
  teacherTestList = new List("TeacherTests", "", 10, 50, 380,height-(400+50+60), teacherTests);
  teacherTests.elements.add(teacherTestList);
  Button newTestButton = new Button("NewTest", "+", 400/2-40/2, height-400-60, 40, 40, teacherTests){//width-450 + 400/2, height-400 - 30, 30, 30, teacherAssignments){
    public void reactClickedOn(){
      println("HERE WE SHOULD SWITCH TO THE ADD A NEW TESTSTSTSTS SCREEN");
      activeScreen = newTestScreen;
    }
  };
  teacherTests.elements.add(newTestButton);
}


void setupHomeTeacherScreen() {
  homeTeacherScreen.windows.add(teacherAssignments);
  homeTeacherScreen.windows.add(teacherTests);
}


void setupStudentAssignmentsWindow(){
  studentAssignments = new Window(width-450, 300, 400, height-400, "StudentAssignmentsWindow");
  studentAssignments.elements.add(new TextDisplay("StudentAssignmentHeader", "Assignments", 20, 40, 40, studentAssignments));
  studentAssignmentList = new List("StudentsAssignments", "", 10, 50, 380,height-(400+50), studentAssignments);
  studentAssignments.elements.add(studentAssignmentList);
}


void setupHomeStudentScreen() {
  //HOMESCREEN
  homeStudentScreen.windows.add(studentAssignments);

  takeTest = new Window(50, 300, width-550, height-400, "takeTestWindow");
  ETest = new ElevTest("ElevTest", "Her tager du dine tests");
  takeTest.elements.add(ETest);
  takeTest.elements.add(new Progressbar("PROGRESSBAR", width-800, 30, 220, 40, takeTest) {
    
    public void stepAlways() {
      if (ETest.questions.size()-1 == ETest.cQuestionIndex) {
        isVisible = true;
      } else if (ETest.questions.size() == 0) {
        isVisible = false;
      } else {
        isVisible = true;
      }
    }
  }
  );
  takeTest.elements.add(new Button("NQButton", "Next", width-800, height-530, 220, 100, takeTest) {
    public void reactClickedOn() {
      if (ETest.questions.size() > ETest.cQuestionIndex) {
        try {
          String correctness;
          Question Q = ETest.questions.get(ETest.cQuestionIndex);
          if (Q.answers.getOutput() == Q.answerList.get(Q.rightAnswerIndex)) {
            correctness = "RIGHT";
          } else {
            correctness = "WRONG";
          }
          Statement st = db.createStatement();
          st.executeUpdate("INSERT INTO answers (studentid,assignmentid,questionid,answer,correctness) VALUES("+mainSession.userID+","+Q.assignmentID+","+ Q.QID+",'" +Q.answers.getOutput()+"','" + correctness+"')");
          st.close();
        } 
        catch (Exception e) {
          e.printStackTrace();
        }
        takeTest.elements.removeAll(ETest.questions.get(ETest.cQuestionIndex).answers.choices);
        if (ETest.questions.size() > ETest.cQuestionIndex+1) {
          ETest.cQuestionIndex++;
        } else {
          ETest.questions.clear();
          ETest.cAssignment.updateRightness();
          ETest.cAssignment = null;
        }
      }
    }
    public void stepAlways() {
      if (ETest.questions.size()-1 == ETest.cQuestionIndex) {
        description = "Finish";
        isVisible = true;
      } else if (ETest.questions.size() == 0) {
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
