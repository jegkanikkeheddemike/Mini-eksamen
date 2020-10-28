CREATE TABLE Teachers (
  TeacherID SERIAL PRIMARY KEY,
  TeacherName TEXT NOT NULL,
  ClassIDs INTEGER[],
  Login TEXT NOT NULL,
  Password TEXT NOT NULL
);

CREATE TABLE Students (
  StudentID SERIAL PRIMARY KEY,
  StudentName TEXT NOT NULL,
  ClassID INT NOT NULL,
  Login TEXT NOT NULL,
  Password TEXT NOT NULL
);

CREATE TABLE Classes(
   ClassID SERIAL PRIMARY KEY,
   ClassName TEXT NOT NULL
);

CREATE TABLE Assignments (
	AssignmentID SERIAL PRIMARY KEY,
TeacherID INT NOT NULL,
ClassID INT NOT NULL,
TestID INT NOT NULL,
DueDate TEXT NOT NULL
);


/*SÅ TIL SELVE TEST/SPØRGESKEMA DELEN AF DET*/

CREATE TABLE Tests (
   TestID SERIAL PRIMARY KEY,
   TestName TEXT NOT NULL,
   TestSubject TEXT,
   TestInfo TEXT /*Noget tekst til læreren for at forklare testen til eleverne*/
);

/*Denne tabel komme til at indeholde de spørgsmålstyper vi kommer til at have.
Til at starte med har den nok kun to entries (Multiple choice og frit tekstfelt)
Men man kunne jo også lave nogle hvor der var ET svar til hvad der kunne stå i tekstfeltet, eller noget hvor man skulle sige fra 1-5 eller et eller andet.
*/

CREATE TABLE QuestionTypes (
   QuestionTypeID SERIAL PRIMARY KEY,
   QuestionTypeName TEXT NOT NULL,
);

/*
SQL QUERY: SELECT …. FROM tablename where … links til andre tabeller og bool klausuler;

MultiChoice
TextField
TextFieldWithAnswer
*/


/*
SpørgsmålsTypen fortæller os noget om hvordan vi skal vise spørgsmålet osv.
*/

CREATE TABLE Questions (
   QuestionID SERIAL PRIMARY KEY,
   TestID INT NOT NULL,
   Question TEXT NOT NULL,
   PossibleAnswers TEXT[], /*De her findes kun hvis spørgsmålet er MultiChoice*/
   RightAnswerIndex INT,
   QuestionTypeID INT NOT NULL
);


/*
I svar tabellen er det hovedsageligt rigtig kolonnen der er interessant.
For jeg tænker at på multiplechoice tingen smider vi en RIGHT/WRONG ind og på den frie tekstfelt laver vi en der hedder PENDING.
Hvor læreren så skal gå ind og sige om det er rigtig eller forkert (muligvis procent idk)
*/
CREATE TABLE Answers (
   AnswerID SERIAL PRIMARY KEY,
   StudentID INT NOT NULL,
   AssignmentID INT NOT NULL,
   QuestionID INT NOT NULL,
   Answer TEXT NOT NULL,
   Correctness TEXT NOT NULL /*RIGHT, WRONG (de her er til multichoice), PENDING (for textfield er den pending indtil læreren har vurderet svaret) */
);

