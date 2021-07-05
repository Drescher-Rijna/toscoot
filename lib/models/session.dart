class Session {

  final String title;
  final String id;
  final bool isComplete;
  final String resultsID;

  Session({ this.title, this.id, this.isComplete, this.resultsID });

}

class Sets {

  String id;
  String trick;
  int reps;
  String seshID;

  Sets({ this.id, this.trick, this.reps, this.seshID });

}

class CurrentSets {

  final String id;
  final String trick;
  final int reps;

  CurrentSets({ this.id, this.trick, this.reps });
}