//LOGGED IN USERDATA
//MAKE THIS INTO A SESSION CLASS!!
String userName = "USERNAME!!!!!!";
String userClass = "CLASSS";
String role = "ROLE!!";

class Session{
  String userName;
  String login;
  String role;
  String studentClass;
  Integer[] classIDs;
  
  Session(){
    userName = "";
    login = "";
    role = "";
  }
  
  void updateStudent(String userName_, String login_, String role_, String class_){
   userName = userName_;
   login = login_;
   role = role_;
   studentClass = class_;
  }
  
  void updateTeacher(String userName_, String login_, String role_, Integer[] classIDs_){
   userName = userName_;
   login = login_;
   role = role_;
   classIDs = classIDs_;
  }  
  
  
  void clear(){
   userName = "";
   login = "";
   role = "";
   studentClass = "";
   classIDs = null;
  }
  
}
