import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toscoot/models/tricklist.dart';
import 'package:toscoot/models/user.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future<void> updateUserData(String username, String email) async {
    return await userCollection.doc(uid).set({
      'username': username,
      'email': email,
    });
  }

  final CollectionReference trickListCollection = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).collection('tricklists');
  Future<void> updateTrickListData(String title, List tricks) async {
    return await trickListCollection.add({
      'title': title,
      'tricks': tricks,
    });
  }

  // trick list from snapshot
  List<TrickList> _trickListFromSnapshot(QuerySnapshot snapshot) {
    print(trickListCollection);
    return snapshot.docs.map((doc) {
      return TrickList(
        title: doc['title'] ?? '',
        tricks: doc['tricks'] ?? '',
      );
    }).toList();
  }

  // get users stream
  Stream<QuerySnapshot> get users {
    return userCollection.snapshots();
  }

  Stream<List<TrickList>> get tricklists {
    return trickListCollection.snapshots()
      .map(_trickListFromSnapshot);
  }


}