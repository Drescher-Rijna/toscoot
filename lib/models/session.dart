class Session {

  final String title;
  final sets;
  final String id;
  final bool isComplete;

  Session({ this.title, this.sets, this.id, this.isComplete }); 

}

class SessionSets<List> {
  final String trick;
  final int reps;

  SessionSets({ this.trick, this.reps });

  
}
