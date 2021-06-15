import 'package:flutter/material.dart';
import 'package:toscoot/models/tricklist.dart';

class TrickListDetails extends StatelessWidget {

  final TrickList tricklist;

  final tricklistTitle;
  final tricklistTricks;
  TrickListDetails({this.tricklistTitle, this.tricklistTricks, this.tricklist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: Text('tricks'),
          centerTitle: true,
          backgroundColor: Colors.orange[900],
          elevation: 0.0,
        ),
        body: Column(
          children: [
            Text(tricklistTitle),
          ],
        ),
    );
  }
}