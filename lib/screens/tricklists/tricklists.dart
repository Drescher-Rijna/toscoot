import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toscoot/models/tricklist.dart';
import 'package:toscoot/screens/home/home.dart';
import 'package:toscoot/screens/sessions/sessions.dart';
import 'package:toscoot/screens/tricklists/create_tricklist.dart';
import 'package:toscoot/screens/tricklists/trick_list.dart';
import 'package:toscoot/services/auth.dart';
import 'package:toscoot/services/database.dart';
import 'package:toscoot/shared/alertSettings.dart';

class TrickLists extends StatefulWidget {

  @override
  _TrickListsState createState() => _TrickListsState();
}

class _TrickListsState extends State<TrickLists> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<TrickList>>.value(
      value: DatabaseService().tricklists,
      child: Scaffold(
        backgroundColor: Color(0xff121212),
        appBar: AppBar(
          title: Text('Tricklists'),
          centerTitle: true,
          backgroundColor: Color(0xffbd0f15),
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
            IconButton(
            icon: Icon(Icons.settings), 
            onPressed: () {
              alertSettings(context);
            }
          ),
          ],
        ),
        body: TrickListScreen(),
        floatingActionButton: new FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TrickListForm()),
            );
          },
          elevation: 5,
          backgroundColor: Color(0xffbd0f15),
          child: new Icon(Icons.add),
        ),

      ),
    );
  }
}