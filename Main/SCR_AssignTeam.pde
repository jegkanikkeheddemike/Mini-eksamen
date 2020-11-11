void setupAssignTeamScreen() {
  assignTeamWindow = new Window(50, 300, width-550, height-400, "assignTeamWindow");
  assignTeamWindow.elements.add(new TextDisplay("AssignTeamHeader", "Make new Class", 20, 40, 40, assignTeamWindow, LEFT));
  assignTeamWindow.elements.add(new TextBox("CLASSNAME", "New Classname",   20, 100,  500,  40, assignTeamWindow));
  assignTeamWindow.elements.add(new TextBox("PATH","CSV filename. Must be in DATA folder",20, 200,  800,  40, assignTeamWindow));
  assignTeamWindow.elements.add(new Button("CREATECLASS", "Create Class",   20, 250,  200,  40, assignTeamWindow) {
    public void reactClickedOn() {
      try {
        String className = assignTeamWindow.getElement("CLASSNAME").getOutput();
        String fName = assignTeamWindow.getElement("PATH").getOutput();
        println(fName);
        
        Statement stCheck = db.createStatement();
        ResultSet rsCheck = stCheck.executeQuery("SELECT * FROM CLASSES WHERE(classname = '" + className + "')");
        if (rsCheck.next()) {
          errorWindow.getElement("ErrorMessage").description = "Class already exist";
          errorWindow.show();
          return;
        }

        Statement st = db.createStatement();
        st.executeUpdate("INSERT INTO classes (classname) VALUES('" + className + "')");
        st.close(); //*/
        addcsvToDb(className,fName);
        ((List) existingTeams.getElement("TeamsList")).customInput();
      }
      catch (Exception e) {
        e.printStackTrace();
      }
    }
  }
  );
  existingTeams = new Window(width-450, 300, 400, height-400, "existingTeamsWindow");
  existingTeams.elements.add(new TextDisplay("AssignTeamHeader", "Assign Class", 20, 40, 40, existingTeams, LEFT));
  existingTeams.elements.add(new Button("ASSIGNCLASS", "Add Class", 20, existingTeams.sizeY-50, existingTeams.sizeX-40, 40, existingTeams) {
    public void reactClickedOn() {
      if (info != null) {
        try {
          Statement st = db.createStatement();
          ResultSet rs = st.executeQuery("SELECT * FROM classes WHERE(classname = '"+info+"')");
          rs.next();
          int ID = rs.getInt("classid");
          println("ID = ", ID);
          rs.close();
          st.close();
          mainSession.classIDs = (Integer[]) append(mainSession.classIDs, ID);
          String sArray = "'{";
          for (int i = 0; i < mainSession.classIDs.length; i ++) {
            sArray += mainSession.classIDs[i]+"";
            if (i+1 < mainSession.classIDs.length) {
              sArray += ",";
            }
          }
          sArray += "}'";
          st = db.createStatement();
          st.executeUpdate("UPDATE teachers SET classids = " + sArray + " WHERE (teachername = '" + mainSession.userName +"');");
          st.close();
          updateTopMenu();
          info = null;
          description = "Add Classs";
        } 
        catch(Exception e) {
          e.printStackTrace();
        }
      }
    }
  }
  );
  existingTeams.elements.add(new List("TeamsList", "", 10, 50, existingTeams.sizeX-20, existingTeams.sizeY-100, existingTeams) {
    public void customInput() {
      try {
        elements.clear();
        Statement st = db.createStatement();
        ResultSet rs = st.executeQuery("SELECT * FROM classes");
        while (rs.next()) {
          elements.add(new Button("ClassBut", rs.getString("classname"), 0, 0, sizeX-20, 50, existingTeams, LEFT) {
            public void reactClickedOn() {
              existingTeams.getElement("ASSIGNCLASS").info = this.description;
              existingTeams.getElement("ASSIGNCLASS").description = "Add " + existingTeams.getElement("ASSIGNCLASS").info;
            }
          }
          );
        }
        rs.close();
        st.close();
      }
      catch(Exception e) {
        e.printStackTrace();
      }
    }
  }
  );


  assignTeamScreen.windows.add(assignTeamWindow);
  assignTeamScreen.windows.add(existingTeams);
}
