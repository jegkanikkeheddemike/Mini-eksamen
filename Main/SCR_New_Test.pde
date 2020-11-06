


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
void setupMakeTestWindow(){
	makeTest = new Window(50, 220, width-100, height-240, "MakeTestWindow");
	makeTest.elements.add(new TextDisplay("MakeTestHeader", "New test", 20, 40, 40, makeTest));
	makeTest.elements.add(new TextBox("TestName", "Name of the test", 20, 80, width-100-40, 40, makeTest));
	makeTest.elements.add(new TextBox("TestSubject", "Test subject", 20, 160, width-100-40, 40, makeTest));
	makeTest.elements.add(new TextBox("TestInfo", "Some info about the test", 20, 240, width-100-40, 40, makeTest));
	makeTest.elements.add(new Button("GoToMakeQuestion", "Proceed to make questions", (width-100-40)/2-((width-100-40)/2)/2, 320, (width-100-40)/2, 40, makeTest){
		public void reactClickedOn(){
			println("TEST IF ALL THE VALUES ARE THERE");
			println("MAKE THE NEW TEST IN THE DATABASE");
			println("SWITCH TO THE MAKE QUESTIONS WINDOW");
			//We switch to the makequestion window
			makeTest.isActive = false;
			makeQuestion.isActive = true;
		}
	});
}

void switchQuestionType(){
	println("We switched to: ", makeQuestion.getElement("QuestionType").getOutput());
	String questionType = makeQuestion.getElement("QuestionType").getOutput();
	if(questionType.equals("Multiple choice")){
		//Make the fields unique for textfield invisible
		makeQuestion.getElement("TextFieldQuestionType").makeInvisible();
		//Make the fields unique for multiple choice visible
		makeQuestion.getElement("Possible answers").makeVisible();
		makeQuestion.getElement("AnswerRight").makeVisible();
		makeQuestion.getElement("NewAnswer").makeVisible();
	}else if(questionType.equals("Text field")){
		//Make the fields unique for multiple choice invisible
		makeQuestion.getElement("Possible answers").makeInvisible();
		makeQuestion.getElement("AnswerRight").makeInvisible();
		makeQuestion.getElement("NewAnswer").makeInvisible();
		//Make the fields unique for textfield visible
		makeQuestion.getElement("TextFieldQuestionType").makeVisible();
	}
}

void addAnswerToMultichoice(){
	int answerNum = answerRight.choices.size()+1;
	makeQuestionAnswerList.elements.add(new TextDisplay("Answer"+answerNum+"Header", str(answerNum), 0, 0, 10, makeQuestion));
	makeQuestionAnswerList.elements.add(new TextBox(str(answerNum), "", 0, 0, width-300-40-40, 40, makeQuestion));
	answerRight.choices.add(new Choice(str(answerNum), answerRight));
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

	makeQuestionAnswerList = new List("Possible answers", "", 20, 120, width-300-40, height-240-120-60, makeQuestion);
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

	// TEXTFIELD QUESTIONTYPE
	makeQuestion.elements.add(new TextDisplay("TextFieldQuestionType", "SPACE FOR STUDENT TO ANSWER", 20, 300, 20, makeQuestion));
	makeQuestion.getElement("TextFieldQuestionType").makeInvisible();
	
	//GENERAL
	makeQuestion.elements.add(new Button("AddQuestion", "Add the question", ((width-100)/3)*0+((width-100)/3)/2-((width-100)/4)/2, height-240-60, ((width-100)/4), 40, makeQuestion){
		public void reactClickedOn(){
			println("HERE WE ARE GONNA ADD THE QUESTION TO THE DATABASE AND CLEAR THE QUESTION");
		}
	});

	makeQuestion.elements.add(new Button("FinishTest", "Add last question", ((width-100)/3)*2+((width-100)/3)/2-((width-100)/4)/2, height-240-60, ((width-100)/4), 40, makeQuestion){
		public void reactClickedOn(){
			println("HERE WE ARE GONNA ADD THE QUESTION TO THE DATABASE AND CLEAR THE QUESTION AND FINISH");
		}
	});




	/*
	TextBox for the question (CHECK)
	
	Multichoice of which type of question is is.
	
	IF IT IS A MULTICHOICE
		List of textboxes
		Button to add a possible answer
		MultiChoice of which of the possible answers are correct
	
	IF IT IS A TEXTBOX
		TextDisplay with the following text "This is where the student will write their answer"
	Button to add the question to the test and go on to the next question
	Button to add the question to the test and "finish" the test

	*/
}