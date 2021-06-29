import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toscoot/models/session.dart';
import 'package:toscoot/screens/sessions/session_details_tile.dart';

class SessionDetails_List extends StatefulWidget {

  @override
  _SessionDetails_ListState createState() => _SessionDetails_ListState();
}

class _SessionDetails_ListState extends State<SessionDetails_List> {
  @override
  Widget build(BuildContext context) {
    final currentSets = Provider.of<List<CurrentSets>>(context);

    return ListView.builder(
      itemCount: currentSets.length,
      itemBuilder: (context, index) {
        return DetailsTile(currentSets: currentSets[index],);
      },
    );
  }
}