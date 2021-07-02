import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toscoot/models/session.dart';
import 'package:toscoot/screens/sessions/create_session.dart';
import 'package:toscoot/screens/sessions/sessions_list.dart';
import 'package:toscoot/services/auth.dart';
import 'package:toscoot/services/database.dart';

class Sessions extends StatefulWidget {

  @override
  _SessionsState createState() => _SessionsState();
}

class _SessionsState extends State<Sessions> {
  final AuthService _auth = AuthService();

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Session>>.value(
      value: DatabaseService().sessions,
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: Text('Sessions'),
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
        body: SessionList(),
        floatingActionButton: new FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Create_Session()),
            );
          },
          elevation: 5,
          backgroundColor: Colors.orange[900],
          child: new Icon(Icons.add),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.orange[900],
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            switch (_currentIndex) {
              case 2:
                Navigator.push(context, MaterialPageRoute(builder: (context) => Sessions()));
              break;
            }
          },
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
      ),
    );
  }
}