import 'package:flutter/material.dart';
import 'package:toscoot/models/tricklist.dart';

class TrickListDetails extends StatelessWidget {

  final TrickList tricklist;

  final tricklistTitle;
  final List<dynamic> tricklistTricks;
  TrickListDetails({this.tricklistTitle, this.tricklistTricks, this.tricklist});

  Widget getTrickWidgets(List<dynamic>tricks)
    {
      return new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: tricks.map((trick) => 
          Container(
            padding: EdgeInsets.fromLTRB(0.0, 25.0, 0, 3.0),
            margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 2.0, color: Colors.orange[900]),
              ),
            ),
            child: new Text(
              trick,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[100],
              ),
            ),
          )).toList()
      );
    }

  @override
  Widget build(BuildContext context) {

    
    

    return Scaffold(
      backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: Text(tricklistTitle),
          centerTitle: true,
          backgroundColor: Colors.orange[900],
          elevation: 0.0,
        ),
        body: Column(
          children: [
            Container(
              child: getTrickWidgets(tricklistTricks),
            ),
            
          ],
        ),
    );
  }
}