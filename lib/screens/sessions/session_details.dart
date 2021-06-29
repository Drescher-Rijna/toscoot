import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toscoot/models/session.dart';
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
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: Text(sessionTitle),
          centerTitle: true,
          backgroundColor: Colors.orange[900],
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
                TextButton.icon(
                  onPressed: () {}, 
                  icon: Icon(
                    Icons.play_arrow,
                    color: Colors.grey[100],
                    size: 24.0,
                  ), 
                  label: Text(
                    'Start session',
                    style: TextStyle(
                      color: Colors.grey[100],
                      fontSize: 20.0,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.orange[900],
                    padding: EdgeInsets.all(13.0),
                  ),
                  
                ),
              Expanded(
                child: StreamProvider<List<CurrentSets>>.value(
                  value: DatabaseService().currentSets,
                  child: SessionDetails_List(),
                ),
              ),
            ],
          ),
        ),

        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.orange[900],
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'Tricklists',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_time_rounded),
              label: 'Sessions',
              
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.linear_scale),
              label: 'Lines',
            ),
          ],
          selectedItemColor: Colors.grey[100],
        ),
      );
  }
}