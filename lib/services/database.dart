import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:toscoot/models/results.dart';
import 'package:toscoot/models/session.dart';
import 'package:toscoot/models/tricklist.dart';
import 'package:toscoot/models/user.dart';

class DatabaseService {

// VALUES VALUES VALUES VALUES VALUES VALUES VALUES VALUES VALUES VALUES VALUES VALUES VALUES VALUES VALUES VALUES VALUES
  final String uid;
  final String tricklistID;
  final String statsResultsID;

  static String ActiveID;
  static String currentSeshID;
  static String currentResultsID;

  DatabaseService({ this.uid, this.tricklistID , this.statsResultsID });







// USERS USERS USERS USERS USERS USERS USERS USERS USERS USERS USERS USERS USERS USERS USERS USERS USERS USERS USERS
  // collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  // creating the user document
  Future<void> updateUserData(String username, String email) async {
    return await userCollection.doc(uid).set({
      'username': username,
      'email': email,
      'ActiveID': 'noIDisChoosen',
      'showAlerts': true,
    });
  }

  // creating user ActiveID
  Future<void> updateUserActiveID(String id) async {
    return await userCollection.doc(FirebaseAuth.instance.currentUser.uid).update({
      'ActiveID': id,
    });
  }

  // change user showAlerts
  Future<void> updateUserAlerts(bool showAlerts) async {
    return await userCollection.doc(FirebaseAuth.instance.currentUser.uid).update({
      'showAlerts': showAlerts,
    });
  }

  // trick list from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: snapshot.id,
      activeID: snapshot['ActiveID'],
      showAlerts: snapshot['showAlerts']
    );
  }

  // get users stream
  Stream<UserData> get users {
    return userCollection.doc(FirebaseAuth.instance.currentUser.uid).snapshots().
    map(_userDataFromSnapshot);
  }







// TRICKLISTS TRICKLISTS TRICKLISTS TRICKLISTS TRICKLISTS TRICKLISTS TRICKLISTS TRICKLISTS TRICKLISTS TRICKLISTS TRICKLISTS
  // tricklist collection reference for current user
  final CollectionReference trickListCollection = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).collection('tricklists');
  Future<void> updateTrickListData(String title, List<String> tricks) async {
    return await trickListCollection.add({
      'title': title,
      'tricks': tricks,
      'created': FieldValue.serverTimestamp(),
      'isActive': false,
    }).then((doc) {
      tricks.forEach((trick) {
        trickListCollection.doc(doc.id).collection('totals').doc(trick).set({
          'lands':  0,
          'fails': 0,
          'trick': trick,
          'listID': doc.id,
        },
        );
      });
    }).then((doc) {
      tricks.forEach((trick) {
        totalsCollection.doc(trick).get().then((doc) {
          if (doc.exists) {
            print('document already exists');
          } else {
            totalsCollection.doc(trick).set({
              'lands':  0,
              'fails': 0,
              'trick': trick,
              },
            );
          }
        }); 
        
      });
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

  // get users tricklists
  Stream<List<TrickList>> get tricklists {
    return trickListCollection.orderBy("created", descending: false).snapshots()
      .map(_trickListFromSnapshot);
  }

  // get user active list
  Stream<ActiveTricklist> get activeTricklist {
    return trickListCollection.doc(ActiveID).snapshots()
      .map(_activeListFromSnapshot);
  }

  // get user clicked tricklist
  Stream<ActiveTricklist> get clickedTricklist {
    return trickListCollection.doc(tricklistID).snapshots()
      .map(_activeListFromSnapshot);
  }







// SESSIONS SESSIONS SESSIONS SESSIONS SESSIONS SESSIONS SESSIONS SESSIONS SESSIONS SESSIONS SESSIONS SESSIONS SESSIONS
  // sessions collectionreference
  final CollectionReference sessionCollection = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).collection('sessions');
  // creating a session with a title
  Future<void> updateSessionData(String title) async {
    return await sessionCollection.add({
      'title': title,
      'created': FieldValue.serverTimestamp(),
      'isComplete': false,
      'listID': ActiveID,
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

  // get users sessions
  Stream<List<Session>> get sessions{
    return sessionCollection.where('listID', isEqualTo: ActiveID).orderBy("created", descending: false).snapshots()
      .map(_sessionFromSnapshot);
  }

  // get current sessions sets
  Stream<List<CurrentSets>> get currentSets{
    return sessionCollection.doc(currentSeshID).collection('sets').snapshots()
      .map(_currentSetsFromSnapshot);
  }



  // SETS SETS SETS SETS SETS SETS SETS SETS SETS SETS SETS SETS SETS SETS SETS SETS SETS SETS SETS SETS SETS SETS
    // sets collectionreference
    final CollectionReference setsCollection = FirebaseFirestore.instance.collection('users')
    .doc(FirebaseAuth.instance.currentUser.uid).collection('sessions')
    .doc(currentSeshID).collection('sets');
    // adding sets to the just creating session
    Future<void> updateSetsData(String trick, int reps) async {
      return await sessionCollection.doc(currentSeshID).collection('sets').add({
        'trick': trick,
        'reps': reps,
        'listID': ActiveID,
        'seshID': currentSeshID,
      });
    }

    // sets from snapshot
    List<Sets> _setsFromSnapshot(QuerySnapshot snapshot) {
      return snapshot.docs.map((doc) {
        return Sets(
          id: doc.id,
          trick: doc['trick'],
          reps: doc['reps'],
          seshID: doc['seshID']
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

    // get session sets
    Stream<List<Sets>> get sets{
      return setsCollection.snapshots()
        .map(_setsFromSnapshot);
    }







// RESULTS RESULTS RESULTS RESULTS RESULTS RESULTS RESULTS RESULTS RESULTS RESULTS RESULTS RESULTS RESULTS RESULTS
  // results collection reference
  final CollectionReference resultsCollection = FirebaseFirestore.instance.collection('users')
  .doc(FirebaseAuth.instance.currentUser.uid).collection('results');

  // create intial document for result and get current results ID
  Future<void> initResults() async {
    return await resultsCollection.add({
      'seshID': currentSeshID,
      'seshDate': FieldValue.serverTimestamp(),
      'overallTime': '00:00:00',
      'listID': ActiveID,
    }).then((doc) => currentResultsID = doc.id).then((doc) => sessionCollection.doc(currentSeshID).update({'resultsID': currentResultsID}));
  }

  // update current results document data
  Future<void> updateResultsData(String time) async {
    return await resultsCollection.doc(currentResultsID).update({
      'overallTime': time,
    });
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

  // get the current session complete results
  Stream<Results> get completeResults{
    return resultsCollection.doc(currentResultsID).snapshots()
      .map(_currentSeshResultsFromSnapshot);
  }







// SET RESULTS SET RESULTS SET RESULTS SET RESULTS SET RESULTS SET RESULTS SET RESULTS SET RESULTS SET RESULTS
  // set results collection reference
  final CollectionReference setResultsCollection = FirebaseFirestore.instance.collection('users')
  .doc(FirebaseAuth.instance.currentUser.uid).collection('setResults');

  // create intial document for result and get current results ID
  Future<void> initSetResults(String trick, int reps) async {
    return await setResultsCollection.add({
      'trick': trick,
      'goal': reps,
      'lands': 0,
      'fails': 0,
      'setTime': '00:00:00',
      'isDone': false,
      'listID': ActiveID,
      'seshID': currentSeshID,
      'resultsID': currentResultsID,
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
      'setDate': FieldValue.serverTimestamp(),
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

  // get the current set results in active sesh
  Stream<List<SetResults>> get setResults{
    return setResultsCollection.where('seshID', isEqualTo: currentSeshID).snapshots()
      .map(_currentSetResultsFromSnapshot);
  }







// TOTALS TOTALS TOTALS TOTALS TOTALS TOTALS TOTALS TOTALS TOTALS TOTALS TOTALS TOTALS TOTALS TOTALS TOTALS TOTALS
  // collection reference
  final CollectionReference totalsCollection = FirebaseFirestore.instance.collection('users')
    .doc(FirebaseAuth.instance.currentUser.uid).collection('totals');

  // update totals
  Future<void> updateTotalsData(int lands, int fails, String trick) async {
    return await totalsCollection.doc(trick).update({
      'lands': FieldValue.increment(lands),
      'fails': FieldValue.increment(fails)
    });
  }

  // update tricklist totals
  Future<void> updateTricklistTotalsData(int lands, int fails, String trick) async {
    return await trickListCollection.doc(ActiveID).collection('totals').doc(trick).update({
      'lands': FieldValue.increment(lands),
      'fails': FieldValue.increment(fails)
    });
  }

  // tricklist totals
  List<Totals> _totalsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Totals(
        trick: doc['trick'] ?? '',
        lands: doc['lands'] ?? '',
        fails: doc['fails'] ?? '',
        listID: doc['listID'] ?? '',
      );
    }).toList();
  }

  // tricklist totals stream
  Stream<List<Totals>> get totals{
    return trickListCollection.doc(tricklistID).collection('totals').snapshots()
      .map(_totalsFromSnapshot);
  }

  // All Time totals from snapshot
  List<AllTimeTotals> _allTimeTotalsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return AllTimeTotals(
        id: doc.id ?? '',
        trick: doc['trick'] ?? '',
        lands: doc['lands'] ?? '',
        fails: doc['fails'] ?? '',
      );
    }).toList();
  }

  // All Time Totals
  Stream<List<AllTimeTotals>> get allTimeTotals{
    return totalsCollection.snapshots()
      .map(_allTimeTotalsFromSnapshot);
  }







// STATS STATS STATS STATS STATS STATS STATS STATS STATS STATS STATS STATS STATS STATS STATS STATS STATS STATS STATS STATS
  // results collection reference for stats
  final CollectionReference statsResultsCollection = FirebaseFirestore.instance.collection('users')
  .doc(FirebaseAuth.instance.currentUser.uid).collection('results');

  // current sets results from snapshot for sesh stats
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

  // current sets results from snapshot for tricklist stats
  List<SetResults> _tricklistSetResultsFromSnapshot(QuerySnapshot snapshot) {
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


  // get overall results for ALL TIME stats
  Stream<Results> get statsResults{
    return statsResultsCollection.doc(statsResultsID).snapshots()
      .map(_statsResultsFromSnapshot);
  }

  // get sets results for SESH stats
  Stream<List<SetResults>> get statsSetResults{
    return setResultsCollection.where('seshID', isEqualTo: currentSeshID).snapshots()
      .map(_statsSetResultsFromSnapshot);
  }

  // get sets results for TRICKLIST stats
  Stream<List<SetResults>> get tricklistSetResults{
    return setResultsCollection.where('listID', isEqualTo: tricklistID).snapshots()
      .map(_tricklistSetResultsFromSnapshot);
  }

  // all time set results
  Stream<List<SetResults>> get allTimeSetResults{
    return setResultsCollection.snapshots()
      .map(_statsSetResultsFromSnapshot);
  }


  // week old sets results from snapshot for ALL TIME STATS
  List<SetResultsOld> _statsSetResultsOldFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return SetResultsOld(
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

  // get sets results for stats ALL TIME STATS from a week ago
  Stream<List<SetResultsOld>> get allTimeWeekAgoSetResults{
    return setResultsCollection
    .where('setDate', isLessThanOrEqualTo: DateTime.now().subtract(Duration(days: 7)))
    .snapshots()
      .map(_statsSetResultsOldFromSnapshot);
  }

  // old sets results from snapshot for TRICKLIST STATS
  List<SetResultsOld> _tricklistSetResultsOldFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return SetResultsOld(
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

  // get sets set results for stats TRICKLIST STATS from a week ago
  Stream<List<SetResultsOld>> get tricklistWeekAgoSetResults{
    return setResultsCollection
    .where('listID', isEqualTo: tricklistID)
    .where('setDate', isLessThanOrEqualTo: DateTime.now().subtract(Duration(days: 7)))
    .snapshots()
      .map(_tricklistSetResultsOldFromSnapshot);
  }





// RATIOS RATIOS RATIOS RATIOS RATIOS RATIOS RATIOS RATIOS RATIOS RATIOS
final CollectionReference ratiosCollection = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).collection('ratios');

Future<void> setRatios() async {
    totalsCollection.snapshots().map((snapshot) {
      print(snapshot);
      return snapshot.docs.forEach((doc) {
        print(doc['trick']);
        return FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).collection('ratios').doc(doc.id).set({
          'trick': doc['trick'] ?? '',
          'ratio': doc['lands']/(doc['lands'] + doc['fails']) ?? 0,
        });
      });
    }).toList();
  
}

// old sets results from snapshot for TRICKLIST STATS
  List<AllTimeRatio> _allTimeRatiosFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return AllTimeRatio(
        id: doc.id,
        trick: doc['trick'] ?? '',
        ratio: doc['ratio'] ?? 0,
      );
    }).toList();
  }

  // get sets set results for stats TRICKLIST STATS from a week ago
  Stream<List<AllTimeRatio>> get allTimeRatios{
    return ratiosCollection.orderBy('ratio', descending: true).snapshots()
      .map(_allTimeRatiosFromSnapshot);
  }








// GENERAL GENERAL GENERAL GENERAL GENERAL GENERAL GENERAL GENERAL GENERAL GENERAL GENERAL GENERAL GENERAL GENERAL
  // Deletion of all things connected with tricklist ID
  Future<void> deleteFromTricklist(id) {
      trickListCollection.doc(id).delete()
      .then((doc) => {
        trickListCollection.doc(id).collection('totals').where('listID', isEqualTo: id).get()
        .then((snapshot) {
          for(DocumentSnapshot ds in snapshot.docs){
              ds.reference.delete();
          }
        })
      })
      .then((doc) {
        sessionCollection.where('listID', isEqualTo: id).get().then((snapshot) {
          for(DocumentSnapshot ds in snapshot.docs){
              ds.reference.delete();
          }
      })
      .then((snapshot) {
        resultsCollection.where('listID', isEqualTo: id).get().then((snapshot) {
        for(DocumentSnapshot ds in snapshot.docs)
          {
            ds.reference.delete();
          }
        }).then((snapshot) {
          setResultsCollection.where('listID', isEqualTo: id).get().then((snapshot) {
            for(DocumentSnapshot ds in snapshot.docs)
            {
              ds.reference.delete();
            }
          });
        });
      });
    });
  }

  // Deletion of all things connected with sesh ID
  Future<void> deleteFromSession(id) {
      sessionCollection.doc(id).delete()
      .then((snapshot) {
        sessionCollection.doc(id).collection('sets').where('seshID', isEqualTo: id).get().then((snapshot) {
          for(DocumentSnapshot ds in snapshot.docs)
          {
            ds.reference.delete();
          }
        });
      })
      .then((snapshot) {
        resultsCollection.where('seshID', isEqualTo: id).get().then((snapshot) {
        for(DocumentSnapshot ds in snapshot.docs)
          {
            ds.reference.delete();
          }
        }).then((snapshot) {
          setResultsCollection.where('seshID', isEqualTo: id).get().then((snapshot) {
            for(DocumentSnapshot ds in snapshot.docs)
            {
              ds.reference.delete();
            }
          });
        });
      });
  }

  


}