void setupCreateAssignmentScreen() {
  createAssignmentWindow = new Window(50, 220, width-100, height-400, "CreateAssignmentWindow");
  createAssignmentWindow.elements.add(new TextDisplay("MakeTestHeader", "New assignment", 20, 40, 40, createAssignmentWindow));
  createAssClassList = new List("AssignClass", "Class", 20, 80, width-1000, 300, createAssignmentWindow);
  createAssignmentWindow.elements.add(createAssClassList);
  createAssTestList = new List("AssignTest", "Tests", width-(width-1000+120), 80, width-1000, 300, createAssignmentWindow);
  createAssignmentWindow.elements.add(createAssTestList);
  createAssignmentWindow.elements.add(new TextBox("DueDate", "DueDate", width/2-160, 240, 200, 40, createAssignmentWindow));
  createAssignmentWindow.elements.add(new Button("AssignAssignment", "Assign", width/2-120, 160, 120, 40, createAssignmentWindow) {
    public void reactClickedOn() {

      for (ClassIDButton CB : pickedClassIDs) {
        for (TestIDButton TB : pickedTestIDs) {
          try {
            Statement st = db.createStatement();
            st.executeUpdate("INSERT INTO Assignments (teacherid, classid, testid, duedate) VALUES ("+mainSession.userID+","+CB.ID+","+TB.ID+",'"+createAssignmentWindow.getElement("DueDate").getOutput()+"')");
            
            st.close();
          }
          catch(Exception e) {
            println(e);
          }
        }
      }
      pickedClassIDs.clear();
      pickedTestIDs.clear();
      createAssignmentWindow.getElement("DueDate").clearText();
      updateAssignments();
      activeScreen = homeTeacherScreen;
    }
  }
  );


  createAssignmentScreen.windows.add(createAssignmentWindow);
}

ArrayList<ClassIDButton> pickedClassIDs = new ArrayList<ClassIDButton>();
ArrayList<TestIDButton> pickedTestIDs = new ArrayList<TestIDButton>();
//Integer pickedClassID;
//Integer pickedTestID;

void updateCreateAssLists() {
  createAssTestList.elements.clear();
  createAssClassList.elements.clear();

  try {
    Statement st = db.createStatement();
    //Give all the assignments that belong to the students class.
    ResultSet rs = st.executeQuery("SELECT * FROM Tests;");
    while (rs.next()) {
      createAssTestList.elements.add(new TestIDButton("CLASS", rs.getString("TestName"), 0, 0, (int) textWidth(rs.getString("TestName")), 30, rs.getInt("testID"), createAssignmentWindow));
    }
  } 
  catch (Exception e) {
    e.printStackTrace();
  }
  try {
    for (Integer ID : mainSession.classIDs) {
      Statement st = db.createStatement();
      ResultSet rs = st.executeQuery ("SELECT * FROM Classes WHERE ClassID = "+ID+";");
      rs.next();
      String className = rs.getString("ClassName");
      textSize(30);
      createAssClassList.elements.add(new ClassIDButton("CLASS", className, 0, 0, (int) textWidth(className), 30, ID, topMenu));
      rs.close();
      st.close();
    }
  }
  catch(Exception e) {
    //e.printStackTrace();
  }
}
