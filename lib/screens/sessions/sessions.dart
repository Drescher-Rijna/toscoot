import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toscoot/models/session.dart';
import 'package:toscoot/models/tricklist.dart';
import 'package:toscoot/models/user.dart';
import 'package:toscoot/screens/sessions/create_session.dart';
import 'package:toscoot/screens/sessions/sessions_list.dart';
import 'package:toscoot/services/auth.dart';
import 'package:toscoot/services/database.dart';
import 'package:toscoot/shared/alertSettings.dart';
import 'package:toscoot/shared/loading.dart';

class Sessions extends StatefulWidget {

  @override
  _SessionsState createState() => _SessionsState();
}

class _SessionsState extends State<Sessions> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Session>>.value(
      value: DatabaseService().sessions,
      child: StreamBuilder(
        stream: DatabaseService().users,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData user = snapshot.data;
            return Scaffold(
              backgroundColor: Colors.grey[100],
              appBar: AppBar(
                title: Text('Sessions'),
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
              body: Padding(
                padding: const EdgeInsets.only(bottom: 80.0),
                child: SessionList(),
              ),
              floatingActionButton: new FloatingActionButton(
                onPressed: user.activeID == 'noIDisChoosen' ? null : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Create_Session()),
                  );
                },
                elevation: 5,
                backgroundColor: user.activeID == 'noIDisChoosen' ? Colors.grey[700] : Color(0xffad0000),
                child: new Icon(Icons.add),
              ),
            );
          } else {
            return Loading();
          }
        },
        
      ),
    );
  }
}