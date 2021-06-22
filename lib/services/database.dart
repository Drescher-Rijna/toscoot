import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toscoot/models/session.dart';
import 'package:toscoot/models/tricklist.dart';

class DatabaseService {

  final String uid;
  static String activeID = '6Wh7e2yJstnsouW5gUVI';
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

  Future<void> getActiveID(String id) {
    activeID = id;
  }
  
  final CollectionReference sessionCollection = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).collection('tricklists').doc(activeID).collection('sessions');
  Future<void> updateSessionData(String title, List sets) async {
    return await sessionCollection.add({
      'title': title,
      'sets': sets,
      'created': FieldValue.serverTimestamp(),
    });
  }

  // session from snapshot
  List<Session> _sessionFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Session(
        id: doc.id,
        title: doc['title'] ?? '',
        sets: doc['sets'] ?? '',
        isComplete: doc['isComplete'] ?? '',
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
    return sessionCollection.orderBy("created", descending: false).snapshots()
      .map(_sessionFromSnapshot);
  }

  // get session result


}