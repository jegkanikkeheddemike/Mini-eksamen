void setupTopMenuScreen() {
  //TOPMENU
  topMenu = new Window(0, 0, width, 200, "TopMenu");
  topMenu.elements.add(new TextDisplay("Header", "The New Lectio", 20, 60, 60, topMenu));
  topMenu.elements.add(new TextDisplay("Username", mainSession.userName, 20, 120, 30, topMenu));
  topMenu.elements.add(new ScreenButton("Logout", "Logout", width-130, 160, 100, 25, topMenu, loginScreen) {
    public void extraAction() {
    }
  }
  );
  topMenu.elements.add(new HoriList("Classes", "", 10, 160, 27, topMenu) {
    public void addElements() {
      if (mainSession.classIDs != null) {
        try {
          for (Integer ID : mainSession.classIDs) {
            Statement st = db.createStatement();
            ResultSet rs = st.executeQuery ("SELECT * FROM Classes WHERE ClassID = "+ID+";");
            rs.next();
            String className = rs.getString("ClassName");
            elements.add(new ClassButton("CLASS", className, 0, 0, 50, 30, ID, topMenu));
            rs.close();
            st.close();
          }
        }
        catch(Exception e) {
          println(e);
        }
      }
    }
  }
  );
  homeScreen.windows.add(topMenu);
}
class ClassButton extends Button {
  int buttonClassID;
  ClassButton(String getName, String getDescription, int getX, int getY, int getSizeX, int getSizeY, int ClassID, Window getOwner) {
    super(getName, getDescription, getX, getY, getSizeX, getSizeY,getOwner);
    buttonClassID = ClassID;
  }
  void drawElement() {
    textAlign(CENTER);
    fill(255);
    textSize(int(sizeY*0.8));
    rect(x, y, sizeX, sizeY);
    fill(0);
    text(description, x+(sizeX/2), y+(sizeY*0.8));
  }
  void reactClickedOn(){
    mainSession.currentClassID = buttonClassID;
  }
}
