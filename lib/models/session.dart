class Session {

  final String title;
  final String id;
  final bool isComplete;

  Session({ this.title, this.id, this.isComplete });

}

class Sets {

  final String id;
  final String trick;
  final int reps;

  Sets({ this.id, this.trick, this.reps });

}

class CurrentSets {

  final String id;
  final String trick;
  final int reps;

  CurrentSets({ this.id, this.trick, this.reps });
}