import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toscoot/models/session.dart';
import 'package:toscoot/models/tricklist.dart';

class DatabaseService {

  final String uid;
  static String activeID;
  static String currentSeshID;
  DatabaseService({ this.uid });

  // collection reference
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

  // sessions collectionreference
  Future getActiveID(String id) {
    if (id != null) {
      activeID = id;
      print(activeID);
    } else {
      activeID = null;
      print(activeID);
    }
  }

  final CollectionReference sessionCollection = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).collection('sessions');
  // creating a session with a title
  Future<void> updateSessionData(String title) async {
    return await sessionCollection.add({
      'title': title,
      'created': FieldValue.serverTimestamp(),
      'isComplete': false,
      'listID': activeID,
    }).then((doc) => currentSeshID = doc.id );
  }

  // session from snapshot
  List<Session> _sessionFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Session(
        id: doc.id,
        title: doc['title'] ?? '',
      );
    }).toList();
  }

  // sets collectionreference
  final CollectionReference setsCollection = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).collection('sessions').doc(currentSeshID).collection('sets');

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


  // get users stream
  Stream<QuerySnapshot> get users {
    return userCollection.snapshots();
  }

  // get users tricklists
  Stream<List<TrickList>> get tricklists {
    return trickListCollection.orderBy("created", descending: false).snapshots()
      .map(_trickListFromSnapshot);
  }

  // get users sessions
  Stream<List<Session>> get sessions{
    return sessionCollection.where('listID', isEqualTo: activeID).orderBy("created", descending: false).snapshots()
      .map(_sessionFromSnapshot);
  }

  // get session result
  Stream<List<Sets>> get sets{
    return setsCollection.snapshots()
      .map(_setsFromSnapshot);
  }

}