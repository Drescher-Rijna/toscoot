import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toscoot/models/tricklist.dart';
import 'package:toscoot/screens/tricklists/details_tricktile.dart';

class TricklistDetailsList extends StatefulWidget {

  @override
  _TricklistDetailsListState createState() => _TricklistDetailsListState();
}

class _TricklistDetailsListState extends State<TricklistDetailsList> {

  @override
  Widget build(BuildContext context) {

    final ActiveTricklist activeTricklist = Provider.of<ActiveTricklist>(context) ?? [];
    print('tricks');
    print(activeTricklist.tricks);

    return ListView.builder(
      itemCount: activeTricklist.tricks.length,
      itemBuilder: (context, index) {
        return DetailsTrickTile(activeTricklist.tricks[index]);
      },
    );
  }
}