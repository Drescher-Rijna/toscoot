import 'package:flutter/material.dart';
import 'package:toscoot/screens/sessions/sessions.dart';
import 'package:toscoot/screens/tricklists/tricklists.dart';
import 'package:toscoot/services/auth.dart';
import 'package:toscoot/stats/tricklist/tricklistStats.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: Text('ToScoot'),
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
        body: AllTimeStats(),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.orange[900],
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            switch (_currentIndex) {
              case 0:
                
              break;
              case 1:
                Navigator.push(context, MaterialPageRoute(builder: (context) => TrickLists()));
              break;
              case 2:
                Navigator.push(context, MaterialPageRoute(builder: (context) => Sessions()));
              break;
            }
          },
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
          ],
          selectedItemColor: Colors.grey[100],
        ),
      ),
    );
  }
}