import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toscoot/models/results.dart';
import 'package:toscoot/models/session.dart';
import 'package:toscoot/models/tricklist.dart';

class DatabaseService {

  final String uid;
  final String activeTricklistID;
  final String statsSeshID;
  final String statsTricklistID;
  final String statsResultsID;

  static String listID = ActiveID.getID();
  static String currentSeshID;
  static String currentResultsID;
  static String currentSetResultsID;

  static DateTime dateAWeekAgo;
  static String tricklistStatID;

  DatabaseService({ this.uid, this.activeTricklistID , this.statsTricklistID, this.statsSeshID, this.statsResultsID });

  


  // users collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  Future<void> updateUserData(String username, String email) async {
    return await userCollection.doc(uid).set({
      'username': username,
      'email': email,
    });
  }

  // tricklist collection reference for current user
  final CollectionReference trickListCollection = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).collection('tricklists');
  Future<void> updateTrickListData(String title, List tricks) async {
    return await trickListCollection.add({
      'title': title,
      'tricks': tricks,
      'created': FieldValue.serverTimestamp(),
      'isActive': false,
    });
  }

  // trick list from snapshot
  List<TrickList> _trickListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return TrickList(
        id: doc.id,
        title: doc['title'] ?? '',
        tricks: doc['tricks'] ?? '',
        isActive: doc['isActive'] ?? '',
      );
    }).toList();
  }

  // active tricklist from snapshot
  ActiveTricklist _activeListFromSnapshot(DocumentSnapshot snapshot) {
    return ActiveTricklist(
      id: snapshot.id,
      tricks: snapshot['tricks']
      
    );
  }

   

  // sessions collectionreference
  final CollectionReference sessionCollection = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).collection('sessions');
  // creating a session with a title
  Future<void> updateSessionData(String title) async {
    return await sessionCollection.add({
      'title': title,
      'created': FieldValue.serverTimestamp(),
      'isComplete': false,
      'listID': ActiveID.getID(),
      'resultsID': 'nothing yet',
    }).then((doc) => currentSeshID = doc.id );
  }

  // get current sesh id
  Future getSeshID(String id) {
    if (id != null) {
      currentSeshID = id;
      print(currentSeshID);
    } else {
      currentSeshID = null;
      print(currentSeshID);
    }
  }

  // complete current session
  Future<void> completeSession(bool isComplete, String seshID) async {
    return await sessionCollection.doc(seshID).update({
      'isComplete': isComplete,
    });
  }

  // session from snapshot
  List<Session> _sessionFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Session(
        id: doc.id,
        title: doc['title'] ?? '',
        isComplete: doc['isComplete'] ?? '',
        resultsID: doc['resultsID'] ?? '',
      );
    }).toList();
  }



  // sets collectionreference
  final CollectionReference setsCollection = FirebaseFirestore.instance.collection('users')
  .doc(FirebaseAuth.instance.currentUser.uid).collection('sessions')
  .doc(currentSeshID).collection('sets');
  // adding sets to the just creating session
  Future<void> updateSetsData(String trick, int reps) async {
    return await sessionCollection.doc(currentSeshID).collection('sets').add({
      'trick': trick,
      'reps': reps,
    });
  }

  // sets from snapshot
  List<Sets> _setsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Sets(
        id: doc.id,
        trick: doc['trick'],
        reps: doc['reps'],
      );
    }).toList();
  }

  // current sesh sets from snapshot
  List<CurrentSets> _currentSetsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return CurrentSets(
        id: doc.id,
        trick: doc['trick'],
        reps: doc['reps'],
      );
    }).toList();
  }



  // results collection reference
  final CollectionReference resultsCollection = FirebaseFirestore.instance.collection('users')
  .doc(FirebaseAuth.instance.currentUser.uid).collection('results');

  // set results collection reference
  final CollectionReference setResultsCollection = FirebaseFirestore.instance.collection('users')
  .doc(FirebaseAuth.instance.currentUser.uid).collection('results').doc(currentResultsID).collection('setResults');

  // create intial document for result and get current results ID
  Future<void> initResults() async {
    return await resultsCollection.add({
      'seshID': currentSeshID,
      'seshDate': FieldValue.serverTimestamp(),
      'overallTime': '00:00:00',
      'listID': ActiveID.getID(),
    }).then((doc) => currentResultsID = doc.id).then((doc) => sessionCollection.doc(currentSeshID).update({'resultsID': currentResultsID}));
  }

  // update current results document data
  Future<void> updateResultsData(String time) async {
    return await resultsCollection.doc(currentResultsID).update({
      'overallTime': time,
    });
  }

  // create intial document for result and get current results ID
  Future<void> initSetResults(String trick, int reps) async {
    return await setResultsCollection.add({
      'trick': trick,
      'goal': reps,
      'lands': 0,
      'fails': 0,
      'setTime': '00:00:00',
      'isDone': false,
      'listID': ActiveID.getID(),
    });
  }

  // update current set results data
  Future<void> updateSetResultsData(String setID, int lands, int fails, String time) async {
    return await setResultsCollection.doc(setID).update({
      'lands': lands,
      'fails': fails,
      'setTime': time,
    });
  }

  Future<void> endSet(String setID, int lands, int fails, String time, bool isDone) async {
    return await setResultsCollection.doc(setID).update({
      'lands': lands,
      'fails': fails,
      'setTime': time,
      'isDone': isDone,
    });
  }

  // current sets results from snapshot
  List<SetResults> _currentSetResultsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return SetResults(
        id: doc.id,
        trick: doc['trick'] ?? '',
        lands: doc['lands'] ?? '',
        fails: doc['fails'] ?? '',
        goal: doc['goal'] ?? '',
        setTime: doc['setTime'] ?? '',
        isDone: doc['isDone'] ?? '',
      );
    }).toList();
  }

  // current sesh results from snapshot
  Results _currentSeshResultsFromSnapshot(DocumentSnapshot snapshot) {
      return Results(
        id: snapshot.id,
        sessionID: snapshot['seshID'],
        completeTime: snapshot['overallTime'],
        completionDate: snapshot['seshDate'],
      );

  }

  // current tricklist all results from snapshot
  List<Results> _currentTricklistResultsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Results(
        id: doc.id,
        sessionID: doc['seshID'],
        completeTime: doc['overallTime'],
        completionDate: doc['seshDate'],
      );
    }).toList();
  }

  // current user all results ever from snapshot


  




  // STREAMS STREAMS STREAMS STREAMS STREAMS

  // get users stream
  Stream<QuerySnapshot> get users {
    return userCollection.snapshots();
  }

  // get users tricklists
  Stream<List<TrickList>> get tricklists {
    return trickListCollection.orderBy("created", descending: false).snapshots()
      .map(_trickListFromSnapshot);
  }

  // get user active list
  Stream<ActiveTricklist> get activeTricklist {
    return trickListCollection.doc(activeTricklistID).snapshots()
      .map(_activeListFromSnapshot);
  }

  // get users sessions
  Stream<List<Session>> get sessions{
    return sessionCollection.where('listID', isEqualTo: ActiveID.getID()).orderBy("created", descending: false).snapshots()
      .map(_sessionFromSnapshot);
  }

  // get current sessions sets
  Stream<List<CurrentSets>> get currentSets{
    return sessionCollection.doc(currentSeshID).collection('sets').snapshots()
      .map(_currentSetsFromSnapshot);
  }

  // get session sets
  Stream<List<Sets>> get sets{
    return setsCollection.snapshots()
      .map(_setsFromSnapshot);
  }


  // get the current session complete results
  Stream<Results> get completeResults{
    return resultsCollection.doc(currentResultsID).snapshots()
      .map(_currentSeshResultsFromSnapshot);
  }

  // get the current set results in active sesh
  Stream<List<SetResults>> get setResults{
    return setResultsCollection.snapshots()
      .map(_currentSetResultsFromSnapshot);
  }



  // STATS STATS STATS STATS STATS
  // results collection reference for stats
  final CollectionReference statsResultsCollection = FirebaseFirestore.instance.collection('users')
  .doc(FirebaseAuth.instance.currentUser.uid).collection('results');

  // current sets results from snapshot for stats
  List<SetResults> _statsSetResultsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return SetResults(
        id: doc.id,
        trick: doc['trick'] ?? '',
        lands: doc['lands'] ?? '',
        fails: doc['fails'] ?? '',
        goal: doc['goal'] ?? '',
        setTime: doc['setTime'] ?? '',
        isDone: doc['isDone'] ?? '',
      );
    }).toList();
  }

  // current sesh results from snapshot for stats
  Results _statsResultsFromSnapshot(DocumentSnapshot snapshot) {
      return Results(
        id: snapshot.id,
        sessionID: snapshot['seshID'] ?? '',
        completeTime: snapshot['overallTime'] ?? '',
        completionDate: snapshot['seshDate'] ?? '',
      );

  }

  // get overall results for stats
  Stream<Results> get statsResults{
    return statsResultsCollection.doc(statsResultsID).snapshots()
      .map(_statsResultsFromSnapshot);
  }

  // get sets results for stats
  Stream<List<SetResults>> get statsSetResults{
    return statsResultsCollection.doc(statsResultsID).collection('setResults').snapshots()
      .map(_statsSetResultsFromSnapshot);
  }



  // get all results for tricklist all-time
  List<Results> _statsTricklistResultsFromSnapshot(QuerySnapshot snapshot) {
      snapshot.docs.map((doc) {
        return Results(
          id: doc.id,
          sessionID: doc['seshID'] ?? '',
          completeTime: doc['overallTime'] ?? '',
          completionDate: doc['seshDate'] ?? '',
        );
      }).toList();
  }



  // Get the Date from 7 days ago from today
  Future<DateTime> getDate() {
    dateAWeekAgo = new DateTime.now().subtract(const Duration(days: 7));
    print(dateAWeekAgo);
  }

  // get overall results for stats
  Stream<List<Results>> get statsTricklistResults{
    return statsResultsCollection.where('listID', isEqualTo: ActiveID.getID())
    .snapshots()
      .map(_statsTricklistResultsFromSnapshot);
  }

  // get overall results for stats from a week ago
  Stream<List<Results>> get statsTricklistWeekAgoResults{
    return statsResultsCollection.where('listID', isEqualTo: ActiveID.getID())
    .where('seshDate', isLessThanOrEqualTo: dateAWeekAgo).snapshots()
      .map(_statsTricklistResultsFromSnapshot);
  }

  // get sets results for stats
  Future<String> getListIDForStats(id) {
    tricklistStatID = id;
  }

  Stream<List<SetResults>> get statsTricklistSetResults{
    return statsResultsCollection.doc(tricklistStatID).collection('setResults').where('listID', isEqualTo: ActiveID.getID()).snapshots()
      .map(_statsSetResultsFromSnapshot);
  }

  // get sets results for stats for tricklist from a week ago
  Stream<List<SetResults>> get statsTricklistWeekAgoSetResults{
    return statsResultsCollection.doc(tricklistStatID).collection('setResults')
    .where('listID', isEqualTo: ActiveID.getID())
    .where('seshDate', isLessThanOrEqualTo: dateAWeekAgo)
    .snapshots()
      .map(_statsSetResultsFromSnapshot);
  }




















  

}