CREATE TABLE Users IF NOT EXISTS(
    UserID SERIAL PRIMARY KEY,
    UserName TEXT NOT NULL,
    ClassID INT NOT NULL /*FOR LÆRERNE SKRIVES DERES KLASSER BARE '3a 3ak 2a' ...*/
    Role TEXT NOT NULL,
    Login TEXT NOT NULL,
    UserPassword TEXT NOT NULL, /* DETTE SKAL HASHES*/
)
CREATE TABLE Users IF NOT EXISTS(
    UserID SERIAL PRIMARY KEY,
    UserName TEXT NOT NULL,
    Role TEXT NOT NULL,
    ClassID INT NOT NULL, /*FOR LÆRERNE SKRIVES DERES KLASSER BARE '3a 3ak 2a' ...*/
    Login TEXT NOT NULL,
    UserPassword TEXT NOT NULL /* DETTE SKAL HASHES*/
)


CREATE TABLE Classes IF NOT EXISTS(
    ClassID SERIAL PRIMARY KEY,
    ClassName TEXT NOT NULL
)



/*SÅ TIL SELVE TEST/SPØRGESKEMA DELEN AF DET*/

CREATE TABLE Test IF NOT EXISTS(
    TestID SERIAL PRIMARY KEY,
    TestName TEXT NOT NULL,
    TestSubject TEXT /* DETTE SKAL HASHES*/
)

/*Denne tabel komme til at indeholde de spørgsmålstyper vi kommer til at have.
Til at starte med har den nok kun to entries (Multiple choice og frit tekstfelt)
Men man kunne jo også lave nogle hvor der var ET svar til hvad der kunne stå i tekstfeltet, eller noget hvor man skulle sige fra 1-5 eller et eller andet.
*/

CREATE TABLE QuestionTypes IF NOT EXISTS(
    QuestionTypeID SERIAL PRIMARY KEY,
    QuestionTypeName TEXT NOT NULL,
)

/*
SpørgsmålsTypen fortæller os noget om hvordan vi skal vise spørgsmålet osv.
*/
CREATE TABLE Questions IF NOT EXISTS(
    QuestionID SERIAL PRIMARY KEY,
    TestID INT NOT NULL,
    Question TEXT NOT NULL,
    PossibleAnswers TEXT,
    RightAnswer TEXT,
    QuestionTypeID INT NOT NULL
)


/*
I svar tabellen er det hovedsageligt rigtig kolonnen der er interessant.
For jeg tænker at på multiplechoice tingen smider vi en RIGHT/WRONG ind og på den frie tekstfelt laver vi en der hedder PENDING.
Hvor læreren så skal gå ind og sige om det er rigtig eller forkert (muligvis procent idk)
*/
CREATE TABLE Answer IF NOT EXISTS(
    AnswerID SERIAL PRIMARY KEY,
    UserID INT NOT NULL,
    QuestionID INT NOT NULL,
    Answer TEXT NOT NULL,
    Correctness TEXT NOT NULL
)