import 'package:flutter/material.dart';
import 'package:toscoot/screens/home/home.dart';
import 'package:toscoot/screens/sessions/sessions.dart';
import 'package:toscoot/screens/tricklists/tricklists.dart';
import 'package:toscoot/services/auth.dart';
import 'package:toscoot/stats/tricklist/tricklistStats.dart';

class BottomNavigator extends StatefulWidget {

  @override
  _BottomNavigatorState createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  final AuthService _auth = AuthService();

  int _currentIndex = 0;
  final List<Widget> _children = [
    Home(),
    TrickLists(),
    Sessions()
  ];

  void onTapBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        
        body: _children[_currentIndex],

        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.orange[900],
          currentIndex: _currentIndex,
          onTap: (index) {
            onTapBar(index);
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