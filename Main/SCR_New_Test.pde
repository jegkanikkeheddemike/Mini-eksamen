void setupNewTestScreen(){
	newTestScreen.windows.add(makeTest);
	newTestScreen.windows.add(makeQuestion);
}

/*
Window makeTest;
Window makeQuestion;
*/
//Testname, testSubject, testInfo,
void setupMakeTestWindow(){
	makeTest = new Window(50, 220, width-100, height-240, "MakeTestWindow");
	makeTest.elements.add(new TextDisplay("MakeTestHeader", "New test", 20, 40, 40, makeTest));
	makeTest.elements.add(new TextBox("TestName", "Name of the test", 20, 80, width-100-40, 40, makeTest));
	makeTest.elements.add(new TextBox("TestSubject", "Test subject", 20, 160, width-100-40, 40, makeTest));
	makeTest.elements.add(new TextBox("TestInfo", "Some info about the test", 20, 240, width-100-40, 40, makeTest));
	makeTest.elements.add(new Button("GoToMakeQuestion", "Proceed to make questions", 20, 320, (width-100-40), 40, makeTest){
		public void reactClickedOn(){
			println("MAKE THE NEW TEST");
			println("SWITCH TO THE MAKE QUESTIONS WINDOW");
		}
	});
}

void setupMakeQuestionWindow(){
	makeQuestion = new Window(50, 300, width-100, height-300-50, "MakeQuestionWindow");
	makeQuestion.isActive = false;
}