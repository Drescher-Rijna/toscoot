import 'package:flutter/material.dart';
import 'package:toscoot/services/auth.dart';
import 'package:toscoot/shared/alertSettings.dart';
import 'package:toscoot/stats/all-time/allTimeStats.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: new AppBar(
        title: Text('ToScoot'),
        centerTitle: true,
        backgroundColor: Color(0xffa10a02),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.grey[100],
            ),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
          IconButton(
            icon: Icon(Icons.settings), 
            onPressed: () {
              alertSettings(context);
            }
          ),
        ],
      ),
      body: AllTimeStats(),
    );
  }
}