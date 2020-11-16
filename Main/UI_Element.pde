boolean within(float low, float middle, float high) {
  return(low < middle && middle < high);
}

class UIElement {
  String name;
  String description;
  String type = "";
  int localX;
  int localY;
  int sizeX;
  int sizeY;
  int x;
  int y;

  String info;  //Kan bruges til at holde data der kun skal bruges i specifikke tilfælde.

  Window owner;
  boolean isActive = false;
  boolean isVisible = true; //SKAL IMPLEMENTERS I DET UNIKKE OBJEKTS drawElement() !!

  void step() {
    if (!isVisible) {
      return;
    }
    if (clickedOn()) {
      isActive = true;
      reactClickedOn();
    }
    if (clickedOff()) {
      isActive = false;
    }
    if (isActive) {
      stepActive();
    }
    if (isActive && keyTapped(10)) {
      reactEnter();
    }
    stepAlways();
  }
  void drawElement() {
    fill(255, 150, 150);
    rect(x, y, sizeX, sizeY);
    textSize(sizeY - 1);
    fill(0);
    text("NO TEXTURE", x, y + sizeY);
  }
  void drawElementInList(PGraphics window) {
    window.fill(255, 150, 150);
    window.rect(x, y, sizeX, sizeY);
    window.textSize(sizeY - 1);
    window.fill(0);
    window.text("NO TEXTURE", x, y + sizeY);
  }
  boolean clickedOn() {
    if (mouseReleased) {
      if (within(x, mouseX, x + sizeX)) {
        if (within(y, mouseY, y + sizeY)) {
          return true;
        }
      }
    }
    return false;
  }
  boolean clickedOff() {
    if (mouseReleased) {
      if (within(x, mouseX, x + sizeX)) {
        if (within(y, mouseY, y + sizeY)) {
          return false;
        }
      }
      return true;
    }

    return false;
  }
  boolean mouseOn() {
    if (within(x, mouseX, x + sizeX)) {
      if (within(y, mouseY, y + sizeY)) {
        return true;
      }
    }
    return false;
  }
  void reactEnter() {
  }
  void reactClickedOn() {
  }
  void stepActive() {
  }
  void stepAlways() {  //Used only for multiple choice so far
  }
  String getOutput() {
    return "NO OUTPUT GIVEN";
  }
  void deleteMe() {
    owner.removeList.add(this);
  }
  void customInput() {
  }

  //TextBox
  void clearText() {
  }
  void makeVisible() {
    isVisible = true;
  }
  void makeInvisible() {
    isVisible = false;
  }
  void calcXY() {
    x = owner.x + 
      localX;
    y = owner.y + 
      localY;
  }
}

class Button extends UIElement {
  int textAlign = CENTER;
  Button(String getName, String getDescription, int getX, int getY, int getSizeX, int getSizeY, Window getOwner) {
    name = getName;
    description = getDescription;
    localX = getX;
    localY = getY;
    sizeX = getSizeX;
    sizeY = getSizeY;
    owner = getOwner;
    calcXY();
    type = "Button";
  }
  Button(String getName, String getDescription, int getX, int getY, int getSizeX, int getSizeY, Window getOwner, int getTextAlign) {
    name = getName;
    description = getDescription;
    localX = getX;
    localY = getY;
    sizeX = getSizeX;
    sizeY = getSizeY;
    owner = getOwner;
    this.textAlign = getTextAlign;
    calcXY();
    type = "Button";
  }
  void drawElement() {
    if (isVisible) {

      textAlign(textAlign);
      fill(255);
      if (mouseOn() || isActive) {
        fill(200, 200, 255);
      }
      textSize(int(sizeY * 0.8));
      rect(x, y, sizeX, sizeY);
      fill(0);
      text(description, x + (sizeX / 2), y + (sizeY * 0.8));
    }
  }
  void drawElementInList(PGraphics g) {
    if (isVisible) {
      int xOffset = 0;
      if (textAlign == 37) {
        xOffset = -sizeX/2 + 5;
      }
      g.textAlign(textAlign);
      g.fill(255);
      if (mouseOn() || isActive) {
        g.fill(200, 200, 255);
      }
      g.textSize(int(sizeY * 0.8));
      g.rect(localX, localY, sizeX, sizeY);
      g.fill(0);
      g.text(description, localX + (sizeX / 2)+xOffset, localY + (sizeY * 0.8));
    }
  }
  void reactEnter() {
    reactClickedOn();
  }
}


class ScreenButton extends UIElement {
  Screen location;
  ScreenButton(String getName, String getDescription, int getX, int getY, int getSizeX, int getSizeY, Window getOwner, Screen getLocation) {
    name = getName;
    description = getDescription;
    localX = getX;
    localY = getY;
    sizeX = getSizeX;
    sizeY = getSizeY;
    owner = getOwner;
    location = getLocation;
    calcXY();
    type = "ScreenButton";
  }
  void drawElement() {
    textAlign(CENTER);
    fill(255);
    if (mouseOn()) {
      fill(200, 200, 255);
    }
    textSize(int(sizeY * 0.8));
    rect(x, y, sizeX, sizeY);
    fill(0);
    text(description, x + (sizeX / 2), y + (sizeY * 0.8));
  }
  void reactClickedOn() {
    extraAction();
    activeScreen = location;
  }
  void extraAction() {
  }
}

class List extends UIElement {
  PGraphics listRender;
  float scroll = 0;
  float maxScroll = 0;  //KOMMER ALDRIG TIL AT VÆRE 0!!
  ArrayList<UIElement> elements = new ArrayList<UIElement>();
  List(String getName, String getDescription, int getX, int getY, int getSizeX, int getSizeY, Window getOwner) {
    listRender = createGraphics(getSizeX, getOwner.sizeY - 20);
    name = getName;
    description = getDescription;
    localX = getX;
    localY = getY;
    sizeX = getSizeX;
    sizeY = getSizeY;
    owner = getOwner;
    calcXY();
    addElements();
    type = "List";
  }

  void stepAlways() {
    if (isVisible) {
      for (UIElement element : elements) {
        element.step();
      }
      if (mouseOn()) {
        scroll += scrollAmount;
        if (scroll > 0) {
          scroll = 0;
        }
        if (scroll < maxScroll) {
          scroll = maxScroll;
        }
      }
    }
  }

  void drawElement() {
    if (isVisible) {
      PGraphics windowRender = createGraphics(sizeX, sizeY-10);
      fill(0);
      textSize(40);
      text(description, x, y-1);
      int yy = 10+(int) scroll;
      int height = 0;

      windowRender.beginDraw();
      windowRender.background(0, 0, 0, 100);
      for (UIElement i : elements) {
        i.x = x + 10;
        i.y = y + yy;
        i.localX = 10;
        i.localY = yy;
        i.sizeX = sizeX - 20;
        i.drawElementInList(windowRender);
        yy += i.sizeY + 10;
        height += i.sizeY+10;
      }
      if (height > sizeY) {
        maxScroll = -(height-sizeY)-20;
      }
      windowRender.endDraw();
      image(windowRender, x, y);
    }
  }
  void addElements() {
  }
  void makeVisible() {
    isVisible = true;
    for (UIElement element : elements) {
      element.makeVisible();
    }
  }
  void makeInvisible() {
    isVisible = false;
    for (UIElement element : elements) {
      element.makeInvisible();
    }
  }
}
class Test extends UIElement {
  int testID;
  String testSubject;
  Test(int getTestID, String getTestName, String getTestSubject, String getTestDescription) {
    testID = getTestID;
    testSubject = getTestSubject;
    name = getTestName;
    description = getTestDescription;
    sizeY = 50;
    type = "Test";
  }
  void reactClickedOn() {
    println("WHAT SHOULD THE TEACHER BE ABLE TO DO WITH THE ALREADY CREATED TESTS?");
    println(name, "ID:", testID);
  }
  void drawElementInList(PGraphics window) {
    window.fill(255);
    if (mouseOn()) {
      window.fill(200, 200, 255);
    }
    window.rect(localX, localY, sizeX, 50);
    window.fill(0);
    window.textSize(20);
    window.text(name + " ID : " + testID, localX+3, localY + 20);
    window.textSize(15);
    window.text(description, localX+3, localY + 40);
  }
}

class Assignment extends UIElement {  //IS A BUTTON DONT CHANGE
  Date dueDate;
  int testID;
  int assignmentID;
  int classID;
  String className;
  float percentCorrect;
  float percentPending;
  boolean finished = false;
  Assignment(int getAssignmentID, String getName, String getDescription, int getTestID) {
    assignmentID = getAssignmentID;
    name = getName;
    description = getDescription;
    sizeY = 50;
    testID = getTestID;
    type = "Assignment";
  }
  //This is the constructor the teachers will use
  Assignment(int getAssignmentID, String getName, String getDescription, int getTestID, int getClassID, String getClassName) {
    assignmentID = getAssignmentID;
    name = getName;
    description = getDescription;
    sizeY = 50;
    testID = getTestID;
    type = "Assignment";
    classID = getClassID;
    className = getClassName;
    updateRightnessTeacher();
  }
  void reactClickedOn() {
    List answerList = (List) takeTest.getElement("CheckCorrect");
    if (finished) {
      takeTest.getElement("NQButton").isVisible = false;
      ETest.isVisible = false;
      ETest.questions.clear();
      answerList.isVisible = true;
      answerList.elements.clear();
      try {
        Statement getAnswersS = db.createStatement();
        ResultSet answers = getAnswersS.executeQuery("SELECT * FROM answers WHERE(assignmentid = " + assignmentID + " and studentid = " + mainSession.userID + ");");
        Statement getQS = db.createStatement();
        ResultSet q = getQS.executeQuery("SELECT * FROM questions WHERE testid = " + testID);
        while (answers.next()) {
          q.next();
          String question = q.getString("question");
          java.sql.Array pAnswersA = q.getArray("possibleanswers");
          String[] pAnswers = (String[]) pAnswersA.getArray();
          String cAnswer = pAnswers[q.getInt("rightanswerindex")];
          String answer = answers.getString("answer");
          answerList.elements.add(new Answer(question, answer, cAnswer, takeTest));
        }
      } 
      catch (Exception e) {
        e.printStackTrace();
      }
    } else {
      takeTest.getElement("NQButton").isVisible = true;
      ETest.isVisible = true;
      answerList.isVisible = false;
      ETest.cAssignment = this;
      if (mainSession.role.equals("Student")) {
        try {
          Statement st = db.createStatement();
          ResultSet rs = st.executeQuery("SELECT * FROM questions WHERE(testid = " + testID + ");");
          ArrayList<Question> readyQuestions = new ArrayList<Question>();
          while (rs.next()) {
            String Question = rs.getString("question");
            int RAnsIn = rs.getInt("rightanswerindex");
            Array AnsArray = rs.getArray("possibleanswers");  //Arrayen kan ikke læses med det samme. 
            ResultSet ansRS = AnsArray.getResultSet(); //Den skal omdannes til et Reslustset som kan læses og omdannes til en ArrayList
            ArrayList<String> Answers = new ArrayList<String>();
            int QID = rs.getInt("questionid");
            while (ansRS.next()) {
              Answers.add(ansRS.getString(2)); //GetString 1 er bare Indexet i resultsettet. Mens 2 er Værdien
            }
            readyQuestions.add(new Question(testID, assignmentID, Question, Answers, RAnsIn, QID));
          }
          ETest.cQuestionIndex = 0;
          ETest.questions.clear();
          ETest.questions.addAll(readyQuestions);
          ETest.testID = testID;
        } 
        catch(Exception e) {
          e.printStackTrace();
        }
      } else if (mainSession.role.equals("Teacher")) {
        //This is where we should change to specific assignment view/window
        println("SHOW RESULTS FOR TEST NAMED: ", name, " WITH ASSIGNMENTID: ", assignmentID);
      }
    }
  }
  void drawElementInList(PGraphics window) {
    window.fill(255);
    if (mouseOn()) {
      window.fill(200, 200, 255);
    }
    if (finished) {
      window.fill(200, 255, 200);
    }
    window.rect(localX, localY, sizeX, 50);
    window.fill(0);
    if(mainSession.role.equals("Student")){
      window.textSize(20);
      window.text(name + " ID : " + testID, localX+3, localY + 20);
      window.textSize(15);
      window.text(description, localX+3, localY + 40);
      if (finished) {
        window.textSize(20);
        window.text(percentCorrect + "%", localX+280, localY + 40);
      }
    }else if(mainSession.role.equals("Teacher")){
      window.textSize(20);
      window.text(name+" CLASS: "+className, localX+3, localY + 20);
      window.textSize(15);
      window.fill(0,255,0);
      window.text("RIGHT: "+percentCorrect+"% ", localX+3, localY + 40);
      window.fill(200,100,0);
      window.text("PENDING: "+percentPending+"%", localX+3+(textWidth("RIGHT: "+percentCorrect+"% ")/2), localY + 40);
    }
  }
  void updateRightness() {
    int correct = 0;
    int qAmount = 0;
    try {
      //FIRST GET AMOUNT OF QUESTIONS!!!!
      Statement getQs = db.createStatement();
      ResultSet getQr = getQs.executeQuery("SELECT * FROM questions WHERE testid = " + testID + ";");
      while (getQr.next()) {
        qAmount++;
      }
      getQr.close();
      getQs.close();
      Statement st = db.createStatement();
      ResultSet rs = st.executeQuery("SELECT * FROM answers WHERE(assignmentid = " + assignmentID + " and studentid = " + mainSession.userID + ")");
      while (rs.next()) {
        finished = true;
        if (rs.getString("correctness").equals("RIGHT")) {
          correct++;
        }
      }
      rs.close();
      st.close();
      percentCorrect = 100 * correct / qAmount;
    } 
    catch (Exception e) {
      e.printStackTrace();
    }
  }
  void updateRightnessTeacher() {
    int numberOfQuestions = 0;
    int numberOfStudents = 0;
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

      //THEN GET THE NUMBER OF STUDENTS IN THE CLASS     
      Statement getSs = db.createStatement();
      ResultSet getSrs = getSs.executeQuery("SELECT * FROM Students WHERE ClassID = " + classID + ";");
      while (getSrs.next()) {
        numberOfStudents++;
      }
      getSrs.close();
      getSs.close();

      //THEN GET THE NUMBER OF CORRECT ANSWERS AND PENDING ONES
      Statement st = db.createStatement();
      ResultSet rs = st.executeQuery("SELECT * FROM Answers WHERE AssignmentID = " + assignmentID + ";");
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
      percentCorrect = ((float) numberOfCorrect / ((float) numberOfStudents * (float) numberOfQuestions))*100.;
      percentPending = ((float) numberOfPending / ((float) numberOfStudents * (float) numberOfQuestions))*100.;
    } 
    catch (Exception e) {
      e.printStackTrace();
    }
  }
}


class HoriList extends UIElement {

  PGraphics listRender;
  int scrool = 0;
  ArrayList<UIElement> elements = new ArrayList<UIElement>();
  HoriList(String getName, String getDescription, int getX, int getY, int getSizeY, Window getOwner) {
    listRender = createGraphics(getSizeY, getOwner.sizeY - 20);
    name = getName;
    description = getDescription;
    localX = getX;
    localY = getY;
    sizeY = getSizeY;
    owner = getOwner;
    calcXY();
    addElements();
    type = "HoriList";
  }
  void stepAlways() {
    for (UIElement element : elements) {
      element.step();
    }
  }
  void drawElement() {
    textAlign(LEFT);

    textSize(20);
    text(description, x, y);
    int xx = 0;
    for (UIElement i : elements) {
      i.x = x + xx;
      i.y = y;
      i.drawElement();
      xx +=i.sizeX + 10;
    }
  }
  void addElements() {
  }
}

class MultiChoice extends UIElement {
  Choice chosen;
  ArrayList<Choice> choices = new ArrayList<Choice>();
  MultiChoice(String getName, String getDescription, int getX, int getY, Window getOwner) {
    name = getName;
    description = getDescription;
    localX = getX;
    localY = getY;
    owner = getOwner;
    calcXY();
    type = "MultiChoice";
  }

  void drawElement() {
    if (isVisible) {
      textAlign(LEFT);
      fill(0);
      textSize(25);
      text(description, x, y);
      textSize(20);
      for (Choice c : choices) {
        c.drawElement();
      }
    }
  }
  void stepAlways() {
    if (isVisible) {
      int yy = 15;
      for (Choice c : choices) {
        if (!owner.elements.contains(c)) {
          owner.elements.add(c);
        }
        if (c == chosen) {
          c.chosen = true;
        } else {
          c.chosen = false;
        }
        c.x = x+10;
        c.y = y+yy;
        //DEN TEGNER SELV FRA WINDOW
        yy += 30;
        c.step();
      }
    }
  }
  void choose(Choice c) {
    if (choices.contains(c)) {
      chosen = c;
    }
  }
  String getOutput() {
    if (chosen != null) {
      return chosen.choiceName;
    } else {
      return null;
    }
  }
  void clearText() {
    chosen = null;
  }

  void makeVisible() {
    isVisible = true;
    for (Choice c : choices) {
      c.makeVisible();
    }
  }

  void makeInvisible() {
    isVisible = false;
    for (Choice c : choices) {
      c.makeInvisible();
    }
  }
}
class Choice extends UIElement {
  String choiceName;
  boolean chosen = false;
  MultiChoice handler;
  Choice(String getName, MultiChoice handler) {
    choiceName = getName;
    this.handler = handler;
    name = "Choice";
    type = "Choice";
    description = "";
    sizeX = 15;
    sizeY = 15;
  }
  void drawElement() {
    if (isVisible) {
      textAlign(LEFT);
      noStroke();
      fill(255);
      if (isActive) {
        fill(200, 200, 255);
      }
      if (chosen) {
        fill(0);
      }
      rect(x, y, 15, 15);
      fill(0);
      textSize(15);
      text(choiceName, x + 30, y + 15);
    }
  }
  void reactEnter() {
    handler.choose(this);
  }
  void reactClickedOn() {
    handler.choose(this);
  }
}

class TextBox extends UIElement {
  String text = "";
  int cursorIndex = 0;

  TextBox(String getName, String getDescription, int getX, int getY, int getSizeX, int getSizeY, Window getOwner) {
    name = getName;
    description = getDescription;
    localX = getX;
    localY = getY;
    sizeX = getSizeX;
    sizeY = getSizeY;
    owner = getOwner;
    calcXY();
    type = "TextBox";
  }
  void stepActive() {
    if (isVisible) {
      for (Integer tappedKey : tappedKeys) {


        if (tappedKey == BACKSPACE && text.substring(0, cursorIndex).length() > 0) {
          text = text.substring(0, cursorIndex - 1) + text.substring(cursorIndex);
          cursorIndex -= 1;
        } else if (tappedKey == -2 && cursorIndex > 0) {  //LEFT ARROW KEY
          cursorIndex -= 1;
        } else if (tappedKey == -3 && cursorIndex < text.length()) {  //RIGHT ARROW KEY
          cursorIndex += 1;
          //}
        } else if ((tappedKey >= 48 && tappedKey <= 57) || (tappedKey >= 65 && tappedKey <= 122) || (tappedKey >= 32 && tappedKey <= 63)) {
          text = text.substring(0, cursorIndex) + char(tappedKey) + text.substring(cursorIndex);
          cursorIndex += 1;
        }
      }
    }
  }
  void clearText() {
    text = "";
    cursorIndex = 0;
  }

  void drawElement() {
    if (isVisible) {
      textAlign(LEFT);
      stroke(0);
      strokeWeight(sizeY / 10);
      if (isActive) {
        fill(200, 200, 255);
      } else {
        fill(255);
      }
      //WE HAVE TO "SCROLL" THE TEXT WHEN IT IS LONGER THAN THE ACTUAL TEXTBOX!
      //The textbox
      rect(x, owner.y + localY, sizeX, sizeY);
      fill(0);
      textSize(sizeY * 0.8);
      text(text, x + 3, y + sizeY * 0.8);

      //The cursor

      if (isActive) {
        fill(255, 0, 0);
        strokeWeight(4);
        float textBeforeCursor = textWidth(text.substring(0, cursorIndex));
        line(x + textBeforeCursor, owner.y + localY, x + textBeforeCursor, owner.y + localY + sizeY);
      }

      //The description
      fill(0);
      text(description, x + 1, y - 4);
    }
  }

  void drawElementInList(PGraphics window) {
    if (isVisible) {
      window.textAlign(LEFT);
      window.stroke(0);
      window.strokeWeight(sizeY / 10);
      if (isActive) {
        window.fill(200, 200, 255);
      } else {
        window.fill(255);
      }
      //WE HAVE TO "SCROLL" THE TEXT WHEN IT IS LONGER THAN THE ACTUAL TEXTBOX!
      //The textbox
      window.rect(localX, localY, sizeX, sizeY);
      window.fill(0);
      window.textSize(sizeY * 0.8);
      window.text(text, localX + 3, localY + sizeY * 0.8);

      //The cursor

      if (isActive) {
        window.fill(255, 0, 0);
        window.strokeWeight(4);
        float textBeforeCursor = window.textWidth(text.substring(0, cursorIndex));
        window.line(localX + textBeforeCursor, localY, localX + textBeforeCursor, localY + sizeY);
      }

      //The description
      window.fill(0);
      window.text(description, localX + 1, localX - 4);
    }
  }

  String getOutput() {
    return text;
  }
}


class TextDisplay extends UIElement {
  int textSize;
  int textMode = LEFT;
  color textColor = color(0);
  TextDisplay(String getName, String getDescription, int getX, int getY, int getSize, Window getOwner, int getTextMode, color getTextColor) {
    name = getName;
    description = getDescription;
    localX = getX;
    localY = getY;
    owner = getOwner;
    textSize = getSize;
    textMode = getTextMode;
    textColor = getTextColor;
    calcXY();
    type = "TextDisplay";
  }
  TextDisplay(String getName, String getDescription, int getX, int getY, int getSize, Window getOwner, int getTextMode) {
    name = getName;
    description = getDescription;
    localX = getX;
    localY = getY;
    owner = getOwner;
    textSize = getSize;
    textMode = getTextMode;
    calcXY();
  }
  TextDisplay(String getName, String getDescription, int getX, int getY, int getSize, Window getOwner) {
    name = getName;
    description = getDescription;
    localX = getX;
    localY = getY;
    owner = getOwner;
    textSize = getSize;
    calcXY();
  }
  void drawElement() {
    if (isVisible) {
      textAlign(textMode);
      fill(textColor);
      textSize(textSize);
      text(description, x, y);
    }
  }

  void drawElementInList(PGraphics window) {
    if (isVisible) {
      window.textAlign(textMode);
      window.fill(textColor);
      window.textSize(textSize);
      window.text(description, localX, localY);
    }
  }
}

class ClassButton extends Button {
  int buttonClassID;
  ClassButton(String getName, String getDescription, int getX, int getY, int getSizeX, int getSizeY, int ClassID, Window getOwner) {
    super(getName, getDescription, getX, getY, getSizeX, getSizeY, getOwner);
    buttonClassID = ClassID;
    type = "ClassButton";
  }
  void reactClickedOn() {
    println(buttonClassID);
    mainSession.currentClassID = buttonClassID;
    updateAssignments();
  }
}

class ClassIDButton extends Button {
  int ID;
  float Color = 255;
  ClassIDButton(String getName, String getDescription, int getX, int getY, int getSizeX, int getSizeY, int ID_, Window getOwner) {
    super(getName, getDescription, getX, getY, getSizeX, getSizeY, getOwner);
    ID = ID_;
    type = "ClassButton";
  }
  void reactClickedOn() {
    println(ID);
    if (!pickedClassIDs.contains(this)) {
      pickedClassIDs.add(this);
      Color = 100;
    } else {
      pickedClassIDs.remove(this);

      Color = 255;
    }
    updateAssignments();
  }
  void isActive() {
  }
  void drawElementInList(PGraphics g) {
    if (isVisible) {
      int xOffset = 0;
      if (textAlign == 37) {
        xOffset = -sizeX/2 + 5;
      }
      g.textAlign(textAlign);
      g.fill(Color);
      if (mouseOn() || isActive) {
        g.fill(-255/2+Color/2+200, -255/2+Color/2+200, -255/2+Color/2+255);
      }
      g.textSize(int(sizeY * 0.8));
      g.rect(localX, localY, sizeX, sizeY);
      g.fill(0);
      g.text(description, localX + (sizeX / 2)+xOffset, localY + (sizeY * 0.8));
    }
  }
}
class TestIDButton extends Button {
  int ID;
  float Color = 255;
  TestIDButton(String getName, String getDescription, int getX, int getY, int getSizeX, int getSizeY, int ID_, Window getOwner) {
    super(getName, getDescription, getX, getY, getSizeX, getSizeY, getOwner);
    ID = ID_;
    type = "ClassButton";
  }
  void reactClickedOn() {
    println(ID);
    if (!pickedTestIDs.contains(this)) {
      pickedTestIDs.add(this);
      Color = 100;
    } else {
      pickedTestIDs.remove(this);
      Color = 255;
    }
    updateAssignments();
  }
  void isActive() {
  }
  void drawElementInList(PGraphics g) {
    if (isVisible) {
      int xOffset = 0;
      if (textAlign == 37) {
        xOffset = -sizeX/2 + 5;
      }
      g.textAlign(textAlign);
      g.fill(Color);
      if (mouseOn() || isActive) {
        g.fill(-255/2+Color/2+200, -255/2+Color/2+200, -255/2+Color/2+255);
      }
      g.textSize(int(sizeY * 0.8));
      g.rect(localX, localY, sizeX, sizeY);
      g.fill(0);
      g.text(description, localX + (sizeX / 2)+xOffset, localY + (sizeY * 0.8));
    }
  }
}

class ElevTest extends UIElement {
  ArrayList<Question> questions = new ArrayList<Question>();
  int cQuestionIndex = 0;
  int testID;
  Assignment cAssignment;
  ElevTest(String getName, String getDescription, ArrayList<Question> getQuestions) {
    name = getName;
    description = getDescription;
    questions = getQuestions;
    type = "ElevTest";
  }
  ElevTest(String getName, String getDescription) {
    name = getName;
    description = getDescription;
  }
  void stepAlways() {
    if (questions.size() > 0) {
      Question Q = questions.get(cQuestionIndex);
      Q.y = 360;
      Q.step();
    }
  }
  void drawElement() {
    if (questions.size() > 0) {
      Question Q = questions.get(cQuestionIndex);
      Q.y = 360;
      Q.drawElement();
    }
  }
}

class Question extends UIElement {
  int testID;
  int assignmentID;
  int QID;
  String question;
  int rightAnswerIndex;
  ArrayList<String> answerList;
  MultiChoice answers = new MultiChoice(question+"MC", "Choose Your answer", 50, 100, takeTest);
  Question(int getTestID, int getAssignmentID, String getQuestion, ArrayList<String> getAnswers, int getRAI, int getQID) {
    testID = getTestID;
    assignmentID = getAssignmentID;
    question = getQuestion;
    answerList = getAnswers;
    rightAnswerIndex = getRAI;
    QID = getQID;
    for (String A : getAnswers) {
      answers.choices.add(new Choice(A, answers));
    }
    type = "Question";
  }
  void stepAlways() {
    answers.step();
  }
  void drawElement() {
    fill(0);
    textSize(30);
    text(question, 100, y);
    textSize(25);
    answers.drawElement();
  }
}

class Progressbar extends UIElement {
  float sizeValue;
  Progressbar(String getName, int getX, int getY, int getSizeX, int getSizeY, Window getOwner) {
    name = getName;
    localX = getX;
    localY = getY;
    sizeX = getSizeX;
    sizeY = getSizeY;
    owner = getOwner;
    calcXY();
    type = "Progressbar";
  }
  void drawElement() {
    if (ETest.questions.size() != 0) {
      sizeValue = sizeX/(ETest.questions.size());
    }
    if (isVisible) {
      fill(255);
      rect(x, y, sizeX, sizeY);
      fill(0);
      rect(x, y, sizeValue*ETest.cQuestionIndex+1, sizeY);
    }
  }
}

class Answer extends UIElement {
  String question, answer, correctAnswer;
  Answer(String getQ, String getA, String getCA, Window getOwner) {
    question = getQ;
    answer = getA;
    correctAnswer = getCA;
    owner = getOwner;
    type = "Answer";
    localX = 0;
    localY = 0;
    sizeX = takeTest.sizeX-120;
    sizeY = 60;
  }
  void drawElementInList(PGraphics g) {
    if (answer.equals(correctAnswer)) {
      g.fill(200, 255, 200);
    } else {
      g.fill(255, 200, 200);
    }
    g.rect(localX, localY, sizeX, sizeY);
    g.fill(0);
    g.textSize(25);
    g.text(question, localX+3, localY+27);
    g.textSize(20);
    if (answer.equals(correctAnswer)) {
      g.text(answer, localX+3, localY+50);
    } else {
      g.text(answer + " // " + correctAnswer, localX+3, localY+48);
    }
  }
}
