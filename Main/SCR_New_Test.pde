


void setupNewTestScreen(){
	newTestScreen.windows.add(makeTest);
	newTestScreen.windows.add(makeQuestion);
}
/*
Window makeTest;
Window makeQuestion;
List makeQuestionAnswerList;
*/
//Testname, testSubject, testInfo,
void clearMakeTestWindow(){
	makeTest.getElement("TestName").clearText();
	makeTest.getElement("TestSubject").clearText();
	makeTest.getElement("TestInfo").clearText();
}

void setupMakeTestWindow(){
	makeTest = new Window(50, 220, width-100, height-240, "MakeTestWindow");
	makeTest.elements.add(new TextDisplay("MakeTestHeader", "New test", 20, 40, 40, makeTest));
	makeTest.elements.add(new TextBox("TestName", "Name of the test", 20, 80, width-100-40, 40, makeTest));
	makeTest.elements.add(new TextBox("TestSubject", "Test subject", 20, 160, width-100-40, 40, makeTest));
	makeTest.elements.add(new TextBox("TestInfo", "Some info about the test", 20, 240, width-100-40, 40, makeTest));
	makeTest.elements.add(new Button("GoToMakeQuestion", "Proceed to make questions", (width-100-40)/2-((width-100-40)/2)/2, 320, (width-100-40)/2, 40, makeTest){
		public void reactClickedOn(){
			String name = makeTest.getElement("TestName").getOutput();
			String subject = makeTest.getElement("TestSubject").getOutput();
			String info = makeTest.getElement("TestInfo").getOutput();
			//The test has to have a name
			if(name != null){
				try{
					//The subject and info aren't necessary but we default it to an empty string if they are null
					if(subject == null) subject = "";
					if(info == null) info = "";
					//Create the new test
					Statement st = db.createStatement();
					st.executeUpdate("INSERT INTO Tests (TestName, TestSubject, TestInfo)  VALUES ('"+name+"', '"+subject+"', '"+info+"');");
					st.close();
				}catch (Exception e) {
      				e.printStackTrace();
	  			}
				
				//Get the id of test just created for future use
				try{
					Statement st = db.createStatement();
					ResultSet rs = st.executeQuery("SELECT * FROM Tests WHERE TestName='"+name+"';");
					rs.next();
					mainSession.teacherTestID = rs.getInt("TestID");
					rs.close();
					st.close();
				}catch (Exception e) {
      				e.printStackTrace();
	  			}
				
				//We switch to the makequestion window
				makeTest.isActive = false;
				makeQuestion.isActive = true;

				clearMakeTestWindow();				
				
				//Show what the test id for DEBUG PURPOSEs
				successWindow.getElement("SuccessMessage").description = "Test "+name+" created";
				successWindow.show();
			}else{
                errorWindow.getElement("ErrorMessage").description = "You have to name the test"; 
                errorWindow.show();
			}
		}
	});
}

void switchQuestionType(){
	println("We switched to: ", makeQuestion.getElement("QuestionType").getOutput());
	String questionType = makeQuestion.getElement("QuestionType").getOutput();
	if(questionType != null){
		if(questionType.equals("Multiple choice")){
			//Make the fields unique for multiple choice visible
			makeQuestion.getElement("Possible answers").makeVisible();
			makeQuestion.getElement("AnswerRight").makeVisible();
			makeQuestion.getElement("NewAnswer").makeVisible();
		}else if(questionType.equals("Text field")){
			//Make the fields unique for multiple choice invisible
			makeQuestion.getElement("Possible answers").makeInvisible();
			makeQuestion.getElement("AnswerRight").makeInvisible();
			makeQuestion.getElement("NewAnswer").makeInvisible();
		}
	}else{
		//If none is selected all of them should be hidden
		//makeQuestion.getElement("TextFieldQuestionType").makeInvisible();  //DET CRASHER NÅR DEN KØRER. "TextFieldQuestionType" Bliver aldrig brugt
		makeQuestion.getElement("Possible answers").makeInvisible();
		makeQuestion.getElement("AnswerRight").makeInvisible();
		makeQuestion.getElement("NewAnswer").makeInvisible();
	}
}

void addAnswerToMultichoice(){
	int answerNum = answerRight.choices.size()+1;
	makeQuestionAnswerList.elements.add(new TextDisplay("Answer"+answerNum+"Header", str(answerNum), 0, 0, 20, makeQuestion));
	makeQuestionAnswerList.elements.add(new TextBox(str(answerNum), "", 0, 0, width-300-40-40, 40, makeQuestion));
	answerRight.choices.add(new Choice(str(answerNum), answerRight));
}

void addQuestion(){
	String question = makeQuestion.getElement("Question").getOutput();
	String questionType = makeQuestion.getElement("QuestionType").getOutput();
	int questionTypeID;
	String possibleAnswers = "";
	int rightAnswerIndex;
	if(!question.equals("")){
		if(questionType != null){
			if(questionType.equals("Multiple choice")){
				questionTypeID = 1;
				List l = (List) makeQuestion.getElement("Possible answers");	
				if(l.elements.size() > 0){
					if(makeQuestion.getElement("AnswerRight").getOutput() != null){
						//We collect all the possible answers
						println(l.elements);
						for(UIElement element : l.elements){
							println(element);
							println(element.type);
							if(element.type.equals("TextBox")){
								possibleAnswers += "\"" + element.getOutput() + "\",";
							}
						}
						//Delete the last comma
						possibleAnswers = possibleAnswers.substring(0, possibleAnswers.length()-1);

						//Get the right answer index
						rightAnswerIndex = int(makeQuestion.getElement("AnswerRight").getOutput())-1;

						//Add the question
						try{
							Statement st = db.createStatement();
							st.executeUpdate("INSERT INTO Questions (TestID, Question, PossibleAnswers, RightAnswerIndex, QuestionTypeID)  VALUES ("+mainSession.teacherTestID+", '"+question+"', '{"+possibleAnswers+"}', "+rightAnswerIndex+", "+questionTypeID+");");
							st.close();
						}catch (Exception e) {
							e.printStackTrace();
						}

						//If everything checks out we clear the make question window
						clearMakeQuestionWindow();
					}else{
						errorWindow.getElement("ErrorMessage").description = "You have to state the right answer"; 
						errorWindow.show();
					}
					//Check if the
				}else{
					errorWindow.getElement("ErrorMessage").description = "You have to give possible answers"; 
					errorWindow.show();
				}
			}else if(questionType.equals("Text field")){
				questionTypeID = 2;
				possibleAnswers = "'{}'";
				rightAnswerIndex = 0;
				//Add the question
				try{
					Statement st = db.createStatement();
					st.executeUpdate("INSERT INTO Questions (TestID, Question, QuestionTypeID)  VALUES ("+mainSession.teacherTestID+", '"+question+"', "+questionTypeID+");");
					st.close();
				}catch (Exception e) {
					e.printStackTrace();
				}
				clearMakeQuestionWindow();
			}
		}else{
			errorWindow.getElement("ErrorMessage").description = "You have to choose a question type"; 
			errorWindow.show();	
		}
	}else{
		errorWindow.getElement("ErrorMessage").description = "You have to have a question"; 
		errorWindow.show();
	}
}

void clearMakeQuestionWindow(){
	makeQuestion.getElement("Question").clearText();
	makeQuestion.getElement("QuestionType").clearText();
	switchQuestionType();
	//Multichoice specific
	List posAns = (List) makeQuestion.getElement("Possible answers");
	posAns.elements = new ArrayList<UIElement>();
	MultiChoice ansRight = (MultiChoice) makeQuestion.getElement("AnswerRight");
	ansRight.clearText();
	ansRight.choices = new ArrayList<Choice>();
}

void setupMakeQuestionWindow(){
	makeQuestion = new Window(50, 220, width-100, height-240, "MakeQuestionWindow");
	makeQuestion.isActive = false;
	makeQuestion.elements.add(new TextDisplay("MakeQuestionHeader", "New question", 20, 40, 40, makeQuestion));
	makeQuestion.elements.add(new TextBox("Question", "Question", 20, 80, width-300-40, 40, makeQuestion));

	MultiChoice questionType = new MultiChoice("QuestionType", "Question type", width-300, 40, makeQuestion){
		public void choose(Choice c){
			if (choices.contains(c)){
				chosen = c;
			}
			//Whenever a new is chosen we have to switch the type of question the teacher is making
			switchQuestionType();
		}
	};
	questionType.choices.add(new Choice("Multiple choice", questionType));
	questionType.choices.add(new Choice("Text field", questionType));
	questionType.choices.get(0).isActive = true;
	makeQuestion.elements.add(questionType);

	// MULTICHOICE QUESTIONTYPE

	makeQuestionAnswerList = new List("Possible answers", "", 20, 140, width-340-20, height-240-140-40, makeQuestion);
	makeQuestion.elements.add(makeQuestionAnswerList);
	makeQuestionAnswerList.makeInvisible();

	answerRight = new MultiChoice("AnswerRight", "Right answer", width-300, 130, makeQuestion);
	makeQuestion.elements.add(answerRight);
	answerRight.makeInvisible();

	makeQuestion.elements.add(new Button("NewAnswer", "New answer", ((width-100)/3)*1+((width-100)/3)/2-((width-100)/4)/2, height-240-60,  ((width-100)/4), 40, makeQuestion){
		public void reactClickedOn(){
			addAnswerToMultichoice();
		}
	});
	makeQuestion.getElement("NewAnswer").makeInvisible();

	
	//GENERAL
	makeQuestion.elements.add(new Button("AddQuestion", "Add question", ((width-100)/3)*0+((width-100)/3)/2-((width-100)/4)/2, height-240-60, ((width-100)/4), 40, makeQuestion){
		public void reactClickedOn(){
			addQuestion();
		}
	});

	makeQuestion.elements.add(new Button("FinishTest", "Finish", ((width-100)/3)*2+((width-100)/3)/2-((width-100)/4)/2, height-240-60, ((width-100)/4), 40, makeQuestion){
		public void reactClickedOn(){

			if(makeQuestion.getElement("Question").getOutput().equals("")){
				makeTest.isActive = true;
				makeQuestion.isActive = false;
				updateTeacherTests();
				activeScreen = homeTeacherScreen;
			}else{
				errorWindow.getElement("ErrorMessage").description = "Add the question before finishing the test"; 
				errorWindow.show();
			}
		}
	});
}
