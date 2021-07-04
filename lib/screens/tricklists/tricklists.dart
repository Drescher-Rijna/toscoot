import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toscoot/models/tricklist.dart';
import 'package:toscoot/screens/home/home.dart';
import 'package:toscoot/screens/sessions/sessions.dart';
import 'package:toscoot/screens/tricklists/create_tricklist.dart';
import 'package:toscoot/screens/tricklists/trick_list.dart';
import 'package:toscoot/services/auth.dart';
import 'package:toscoot/services/database.dart';

class TrickLists extends StatefulWidget {

  @override
  _TrickListsState createState() => _TrickListsState();
}

class _TrickListsState extends State<TrickLists> {
  final AuthService _auth = AuthService();

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<TrickList>>.value(
      value: DatabaseService().tricklists,
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: Text('Tricklists'),
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
        body: TrickListScreen(),
        floatingActionButton: new FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Create_TrickList()),
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
              case 0:
                Navigator.pop(context, MaterialPageRoute(builder: (context) => Home()));
              break;
              case 1:
                Navigator.pop(context, MaterialPageRoute(builder: (context) => TrickLists()));
              break;
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
          ],
          selectedItemColor: Colors.grey[100],
        ),
      ),
    );
  }
}