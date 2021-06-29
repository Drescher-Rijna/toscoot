import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toscoot/models/session.dart';
import 'package:toscoot/screens/sessions/session_tile.dart';

class SessionList extends StatefulWidget {

  @override
  _SessionListState createState() => _SessionListState();
}

class _SessionListState extends State<SessionList> {
  @override
  Widget build(BuildContext context) {

    final sessions = Provider.of<List<Session>>(context);

    return ListView.builder(
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        return SessionTile(session: sessions[index]);
      },
    );
  }
}