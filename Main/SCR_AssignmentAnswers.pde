void setupAssignmentAnswersScreen(){
    setupAssignmentAnswersWindow();
    setupAssignmentStudentAnswersWindow();
    assignmentAnswersScreen.windows.add(assignmentAnswers);
    assignmentAnswersScreen.windows.add(assignmentStudentAnswers);
}

void updateAssignmentAnswers(int testID, int classID, int assignmentID){
    assignmentAnswers.isActive = true;
    assignmentStudentAnswers.isActive = false;
    assignmentAnswersStudents.elements.clear();
    try{
        Statement st = db.createStatement();
        ResultSet rs = st.executeQuery("SELECT StudentName, StudentID FROM Students WHERE ClassID = "+classID+";");
        while(rs.next()){
            assignmentAnswersStudents.elements.add(new AssignmentStudentAnswer(assignmentID, rs.getString("StudentName"), testID, classID, rs.getInt("StudentID")));
        }
        rs.close();
        st.close();
    }catch(Exception e){
        e.printStackTrace();
    }
}

void setupAssignmentAnswersWindow(){
    assignmentAnswers = new Window(50, 220, width-100, height-240, "AssignmentAnswersWindow");

    assignmentAnswers.elements.add(new TextDisplay("AssignmentAnswerHeader", "THIS WILL BE WHERE THE ASSIGNMENT NAME WILL BE!!!", 20, 50, 40, assignmentAnswers));
    assignmentAnswers.elements.add(new TextDisplay("AssignmentAnswerResults", "RESULTS WILL BE HERE!!!", 20, 100, 40, assignmentAnswers));

    assignmentAnswersStudents = new List("StudentsAssignmentAnswers", "", 20, 150, width-100-40, height-240-150-40, assignmentAnswers);
    assignmentAnswers.elements.add(assignmentAnswersStudents);

}

class AssignmentStudentAnswer extends UIElement {  //IS A BUTTON DONT CHANGE
  Date dueDate;
  int testID;
  int assignmentID;
  int classID;
  String className;
  int studentID;
  float percentCorrect;
  float percentPending;
  AssignmentStudentAnswer(int getAssignmentID, String getName, int getTestID, int getClassID, int getStudentID) {
    assignmentID = getAssignmentID;
    name = getName;
    studentID = getStudentID;
    sizeY = 50;
    testID = getTestID;
    type = "Assignment";
    classID = getClassID;
    updateRightness();
  }
  void reactClickedOn() {
      updateAssignmentStudentAnswers(testID, classID, assignmentID, studentID, name, percentCorrect, percentPending);
      assignmentAnswers.isActive = false;
      assignmentStudentAnswers.isActive = true;
  }
  void drawElementInList(PGraphics window) {
    window.fill(255);
    if (mouseOn()) {
      window.fill(200, 200, 255);
    }
    window.rect(localX, localY, sizeX, 50);
    window.fill(0);
    
      window.textSize(20);
      window.text(name, localX+3, localY + 20);
      window.textSize(15);
      window.fill(0,255,0);
      window.text("RIGHT: "+percentCorrect+"% ", localX+3, localY + 40);
      window.fill(200,100,0);
      window.text("PENDING: "+percentPending+"%", localX+3+(textWidth("RIGHT: "+percentCorrect+"% ")/2), localY + 40);
  }
  void updateRightness() {
      //THIS WILL UPDATE THE RIGHTNESS FOR THE SPECIFIC STUDENT
    int numberOfQuestions = 0;
    int numberOfCorrect = 0;
    int numberOfPending = 0;
    try {
      //FIRST GET AMOUNT OF QUESTIONS!!!!
      Statement getQs = db.createStatement();
      ResultSet getQr = getQs.executeQuery("SELECT * FROM Questions WHERE TestID = " + testID + ";");
      while (getQr.next()) {
        numberOfQuestions++;
      }
      getQr.close();
      getQs.close();

      //THEN GET THE NUMBER OF CORRECT ANSWERS AND PENDING ONES
      Statement st = db.createStatement();
      ResultSet rs = st.executeQuery("SELECT * FROM Answers WHERE (StudentID = "+studentID+") AND (AssignmentID = "+assignmentID+");");
      while (rs.next()) {
        String correctness = rs.getString("Correctness");
        if (correctness.equals("RIGHT")) {
          numberOfCorrect++;
        }else if(correctness.equals("PENDING")){
          numberOfPending++;
        }
      }
      rs.close();
      st.close();
      //THANK YOU JAVA FOR BEING VERY GOOD AT FLOATING POINT ARITHMETIC!!!AHHH
      percentCorrect = ((float) numberOfCorrect / ((float) numberOfQuestions))*100.;
      percentPending = ((float) numberOfPending / ((float) numberOfQuestions))*100.;
    } 
    catch (Exception e) {
      e.printStackTrace();
    }
  }
}

class AssignmentStudentSpecificAnswer extends UIElement {  //IS A BUTTON DONT CHANGE
  int testID;
  int questionID;
  String question;
  //String question; THE QUESTION WILL JUST BE THE NAME?
  String answer;
  int assignmentID;
  int classID;
  int studentID;
  String correctness;
  //JUST TO TRY IT OUT!!!
  AssignmentStudentSpecificAnswer(int getAssignmentID, int getQuestionID, String getQuestion, String getAnswer, int getTestID, int getClassID, int getStudentID, String getCorrectness) {
    assignmentID = getAssignmentID;
    questionID = getQuestionID;
    question = getQuestion;
    answer = getAnswer;
    name = question + " " + answer;
    sizeY = 50;
    testID = getTestID;
    type = "AssignmentStudentSpecificAnswer";
    classID = getClassID;
    studentID = getStudentID;
    correctness = getCorrectness;
  }
  void reactClickedOn() {
      println("IT SHOULD BE MADE SUCH THAT ONE COULD CHANGE THE RATING By CLICKING IN THE SIDE BUTTONS AND STUFF");
  }
  void drawElementInList(PGraphics window) {
    window.fill(255);
    if (mouseOn()) {
      window.fill(200, 200, 255);
    }
    window.rect(localX, localY, sizeX, 50);
    window.fill(0);
    
    window.textSize(20);
    window.text(name, localX+3, localY + 20);
    window.textSize(15);
    if(correctness.equals("RIGHT")){
        window.fill(0,255,0);
    }
    else if(correctness.equals("WRONG")){
        window.fill(255,0,0);
    }
    else if(correctness.equals("PENDING")){
        window.fill(200,100,0);
    }
    window.text(correctness, localX+3, localY + 40);
  }
  void updateRightness() {
      //THIS WILL UPDATE THE RIGHTNESS FOR THE SPECIFIC ANSWER MOSTLY TO BE USED WITH PENDING
  }
}

void updateAssignmentStudentAnswers(int testID, int classID, int assignmentID, int studentID, String studentName, float percentCorrect, float percentPending){
    assignmentAnswersSpecificStudent.elements.clear();
    assignmentStudentAnswers.getElement("AssignmentStudentAnswerHeader").description = studentName;
    assignmentStudentAnswers.getElement("AssignmentStudentAnswerResults").description = "RIGHT: "+percentCorrect+"% PENDING: "+percentPending+"%";
    try{
        Statement st = db.createStatement();
        ResultSet rs = st.executeQuery("SELECT Questions.Question AS Question, Answers.QuestionID AS QuestionID, Answers.Answer AS Answer, Answers.Correctness AS Correctness FROM Answers, Questions WHERE (Answers.StudentID = "+studentID+") AND (Answers.AssignmentID = "+assignmentID+") AND (Answers.QuestionID = Questions.QuestionID);");
        while(rs.next()){
            assignmentAnswersSpecificStudent.elements.add(new AssignmentStudentSpecificAnswer(assignmentID, rs.getInt("QuestionID"), rs.getString("Question"), rs.getString("Answer"), testID, classID, studentID, rs.getString("Correctness")));
        }
        rs.close();
        st.close();
    }catch(Exception e){
        e.printStackTrace();
    }
}

void setupAssignmentStudentAnswersWindow(){
    assignmentStudentAnswers = new Window(50, 220, width-100, height-240, "AssignmentStudentAnswersWindow");
    assignmentStudentAnswers.isActive = false;

    assignmentStudentAnswers.elements.add(new TextDisplay("AssignmentStudentAnswerHeader", "HERE THE STUDENT'S NAME WILL BE", 20, 50, 40, assignmentStudentAnswers));
    assignmentStudentAnswers.elements.add(new TextDisplay("AssignmentStudentAnswerResults", "THE STUDENTS SPECIFIC RESULTS WILL BE HERE!!!", 20, 100, 40, assignmentStudentAnswers));
    
    assignmentAnswersSpecificStudent = new List("StudentsAssignmentAnswers", "", 20, 150, width-340-20, height-240-150-40, assignmentStudentAnswers);
    assignmentStudentAnswers.elements.add(assignmentAnswersSpecificStudent);

    MultiChoice changeCorrectness = new MultiChoice("ChangeCorrectness", "Change correctness", width-340+20, 150, assignmentStudentAnswers);
	changeCorrectness.choices.add(new Choice("RIGHT", changeCorrectness));
	changeCorrectness.choices.add(new Choice("WRONG", changeCorrectness));
    assignmentStudentAnswers.elements.add(changeCorrectness);
    
    assignmentStudentAnswers.elements.add(new Button("ChangeCorrectness", "Change correctness", width-340+20, 250, 200, 20, assignmentStudentAnswers){
        public void reactClickedOn(){
            println("DO WHATEVER NEEDS TO BE DONE");
        }
    });
}