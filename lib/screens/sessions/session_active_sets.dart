import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toscoot/models/results.dart';
import 'package:toscoot/screens/sessions/session_active_settile.dart';
import 'package:toscoot/shared/loading.dart';

class SessionActiveSets extends StatefulWidget {

  @override
  _SessionActiveSetsState createState() => _SessionActiveSetsState();
}

class _SessionActiveSetsState extends State<SessionActiveSets> {
  @override
  Widget build(BuildContext context) {

    final setResults = Provider.of<List<SetResults>>(context) ?? [];

    return ListView.builder(
      itemCount: setResults.length,
      itemBuilder: (context, index) {
        return SessionActiveSetTile(setResults[index]);
      },
    );
  }
}