class Results {

  String id;
  String sessionID;
  String completeTime;
  DateTime completionDate;

  Results({ this.id, this.sessionID, this.completeTime, this.completionDate });

}

class SetResults {

  String id;
  String trick;
  int lands;
  int fails;
  int goal;
  String setTime;
  bool isDone;

  SetResults({ this.id, this.trick, this.lands, this.fails, this.goal, this.setTime, this.isDone });

}