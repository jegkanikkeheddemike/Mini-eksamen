

Session mainSession = new Session();

class Session{
  String userName;
  String login;
  String role;
  //int studentClassID;
  String studentClass;
  Integer[] classIDs;
  //String[] classNames;
  Integer currentClassID;
  
  Session(){
    userName = "";
    login = "";
    role = "";
    classIDs = new Integer[10];
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
