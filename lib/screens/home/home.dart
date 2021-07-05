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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: new AppBar(
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
    );
  }
}