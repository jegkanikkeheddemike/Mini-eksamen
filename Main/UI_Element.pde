boolean within(float low, float middle, float high) {
  return(low < middle && middle < high);
}

class UIElement {
  String name;
  String description;

  int localX;
  int localY;
  int sizeX;
  int sizeY;
  int x;
  int y;


  Window owner;
  boolean isActive = false;
  boolean isVisible = true; //SKAL IMPLEMENTERS I DET UNIKKE OBJEKTS drawElement(); !!

  void step() {
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
    if (isActive && keyTapped(ENTER)) {
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

  //TextBox
  void clearText() {
  }

  void calcXY() {
    x = owner.x + localX;
    y = owner.y + localY;
  }
}

class Button extends UIElement {
  Button(String getName, String getDescription, int getX, int getY, int getSizeX, int getSizeY, Window getOwner) {
    name = getName;
    description = getDescription;
    localX = getX;
    localY = getY;
    sizeX = getSizeX;
    sizeY = getSizeY;
    owner = getOwner;
    calcXY();
  }
  void drawElement() {
	if (isVisible) {
		textAlign(CENTER);
		fill(255);
		textSize(int(sizeY * 0.8));
		rect(x, y, sizeX, sizeY);
		fill(0);
		text(description, x + (sizeX / 2), y + (sizeY * 0.8));
  	}
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
  }
  void drawElement() {
    textAlign(CENTER);
    fill(255);
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
  int scrool = 0;
  ArrayList<UIElement> elements = new ArrayList<UIElement>();
  List(String getName, String getDescription, int getX, int getY, int getSizeX, Window getOwner) {
    listRender = createGraphics(getSizeX, getOwner.sizeY - 20);
    name = getName;
    description = getDescription;
    localX = getX;
    localY = getY;
    sizeX = getSizeX;
    owner = getOwner;
    calcXY();
    addElements();
  }

  void stepAlways() {
    for (UIElement element : elements) {
      element.step();
    }
  }

  void drawElement() {

    textSize(20);
    text(description, x, y);
    int yy = 10 + scrool;
    for (UIElement i : elements) {
      i.x = x + 10;
      i.y = y + yy;
      i.sizeX = sizeX - 20;
      i.drawElement();
      yy += i.sizeY + 10;
    }
  }
  void addElements() {
  }
}


class Assignment extends UIElement {
  Date dueDate;
  int testID;
  Assignment(String getName, String getDescription, int getTestID) {
    name = getName;
    description = getDescription;
    sizeY = 50;
    testID = getTestID;
  }
  void reactClickedOn() {
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
        readyQuestions.add(new Question(testID, Question, Answers, RAnsIn, QID));
      }
      ETest.CQuestionIndex = 0;
      ETest.Questions.clear();
      ETest.Questions.addAll(readyQuestions);
      ETest.testID = testID;
    } 
    catch(Exception e) {
      e.printStackTrace();
    }
  }
  void drawElement() {
    fill(255);
    rect(x, y, sizeX, 50);
    fill(0);
    textSize(20);
    text(name + " ID : " + testID, x, y + 20);
    textSize(15);
    text(description, x, y + 40);
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
  Choice Chosen;
  boolean hasCorrectChoice;
  String correctChocice;

  ArrayList<Choice> Choices = new ArrayList<Choice>();
  MultiChoice(String getName, String getDescription, int getX, int getY, Window getOwner) {
    name = getName;
    description = getDescription;
    localX = getX;
    localY = getY;
    owner = getOwner;
    calcXY();
  }
  MultiChoice(String getName, String getDescription, int getX, int getY, Window getOwner, String getCorrectChocice) {
    name = getName;
    description = getDescription;
    localX = getX;
    localY = getY;
    correctChocice = getCorrectChocice;
    owner = getOwner;
    calcXY();
  }

  void drawElement() {
    textAlign(LEFT);
    fill(0);
    textSize(25);
    text(description, x, y);
    textSize(20);
    int yy = 15;
    for (Choice i : Choices) {
      if (i == Chosen) {
        fill(0);
      } else {
        fill(255);
      }
      rect(x + 10, y + yy, 15, 15);
      fill(0);
      text(i.ChoiceName, x + 30, y + yy + 15);
      yy += 30;
    }
  }
  void stepAlways() {
    int yy = 15;
    for (Choice i : Choices) {
      if (mouseReleased) {
        if (within(x + 10, mouseX, x + 25)) {
          if (within(y + yy, mouseY, y + yy + 15)) {
            Chosen = i;
          }
        }
      }
      yy += 30;
    }
  }
  String getOutput() {
    if (Chosen != null) {
      return Chosen.ChoiceName;
    } else {
      return null;
    }
  }
  void clearText() {
    Chosen = null;
  }
}


class Choice {
  String ChoiceName;
  Choice(String getName) {
    ChoiceName = getName;
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
  }
  void stepActive() {

    for (Integer tappedKey : tappedKeys) {


      if (tappedKey == BACKSPACE && text.substring(0, cursorIndex).length() > 0) {
        text = text.substring(0, cursorIndex - 1) + text.substring(cursorIndex);
        cursorIndex -= 1;
      } else if (tappedKey == '=' && cursorIndex > 0) {
        cursorIndex -= 1;
      } else if (tappedKey == '?' && cursorIndex < text.length()) {
        cursorIndex += 1;
        //}
      } else if ((tappedKey >= 48 && tappedKey <= 57) || (tappedKey >= 65 && tappedKey <= 122)) {
        text = text.substring(0, cursorIndex) + char(tappedKey) + text.substring(cursorIndex);
        cursorIndex += 1;
      }
    }
  }
  void clearText() {
    text = "";
    cursorIndex = 0;
  }

  void drawElement() {
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
      strokeWeight(2);
      float textBeforeCursor = textWidth(text.substring(0, cursorIndex));
      line(x + textBeforeCursor, owner.y + localY, x + textBeforeCursor, owner.y + localY + sizeY);
    }

    //The description
    fill(0);
    text(description, x + 1, y - 4);
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
    textAlign(textMode);
    fill(textColor);
    textSize(textSize);
    text(description, x, y);
  }
}

class ClassButton extends Button {
  int buttonClassID;
  ClassButton(String getName, String getDescription, int getX, int getY, int getSizeX, int getSizeY, int ClassID, Window getOwner) {
    super(getName, getDescription, getX, getY, getSizeX, getSizeY, getOwner);
    buttonClassID = ClassID;
  }
  void drawElement() {
    textAlign(CENTER);
    fill(255);
    textSize(int(sizeY * 0.8));
    rect(x, y, sizeX, sizeY);
    fill(0);
    text(description, x + (sizeX / 2), y + (sizeY * 0.8));
  }
  void reactClickedOn() {
    mainSession.currentClassID = buttonClassID;
  }
}


class ElevTest extends UIElement {
  ArrayList<Question> Questions = new ArrayList<Question>();
  int CQuestionIndex = 0;
  int testID;
  ElevTest(String getName, String getDescription, ArrayList<Question> getQuestions) {
    name = getName;
    description = getDescription;
    Questions = getQuestions;
  }
  ElevTest(String getName, String getDescription) {
    name = getName;
    description = getDescription;
  }
  void stepAlways() {
    if (Questions.size() > 0) {
      Question Q = Questions.get(CQuestionIndex);
      Q.y = 360;
      Q.step();
    }
  }
  void drawElement() {
    if (Questions.size() > 0) {
      Question Q = Questions.get(CQuestionIndex);
      Q.y = 360;
      Q.drawElement();
    }
  }
}


class Question extends UIElement {
  int testID;
  int QID;
  String question;
  int rightAnswerIndex;
  ArrayList<String> AnswerList;
  MultiChoice answers = new MultiChoice(question+"MC", "Choose Your answer", 50, 100, takeTest);
  Question(int getTestID, String getQuestion, ArrayList<String> getAnswers, int getRAI, int getQID) {
    testID = getTestID;
    question = getQuestion;
    AnswerList = getAnswers;
    rightAnswerIndex = getRAI;
    QID = getQID;
    for (String A : getAnswers) {
      answers.Choices.add(new Choice(A));
    }
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
