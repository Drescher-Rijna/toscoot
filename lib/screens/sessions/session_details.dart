import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toscoot/models/session.dart';
import 'package:toscoot/screens/sessions/session_active.dart';
import 'package:toscoot/screens/sessions/session_details_list.dart';
import 'package:toscoot/services/auth.dart';
import 'package:toscoot/services/database.dart';

class SessionDetails extends StatelessWidget {

  final Session session;
  final sessionTitle;
  
  SessionDetails({this.sessionTitle, this.session});

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(sessionTitle),
          centerTitle: true,
          backgroundColor: Color(0xffa10a02),
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(
                Icons.person,
                color: Colors.grey[100],
              ),
              label: Text(
                'logout',
                style: TextStyle(
                  color: Colors.grey[100],
                ),
              ),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
        
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
                TextButton.icon(
                  onPressed: () async {
                    await DatabaseService().initResults();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SessionActive()));
                  }, 
                  icon: Icon(
                    Icons.play_arrow,
                    color: Colors.grey[100],
                    size: 24.0,
                  ), 
                  label: Text(
                    'Start session',
                    style: TextStyle(
                      color: Colors.grey[100],
                      fontSize: 24.0,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xffa10a02),
                    padding: EdgeInsets.all(13.0),
                  ),
                  
                ),
                SizedBox(height: 10,),
              Expanded(
                child: StreamProvider<List<CurrentSets>>.value(
                  value: DatabaseService().currentSets,
                  child: SessionDetails_List(),
                ),
              ),
            ],
          ),
        ),
      );
  }
}