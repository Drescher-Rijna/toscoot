import 'package:flutter/material.dart';
import 'package:toscoot/models/session.dart';

class SessionDetails extends StatelessWidget {

  final Session session;

  final sessionTitle;
  final List<dynamic> sessionSets;
  SessionDetails({this.sessionTitle, this.sessionSets, this.session});

  Widget getSetsWidgets(List<dynamic> sets)
    {
      print(sets);
      print(sessionSets);
        return new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: sets.map((set) => 
          Container(
            padding: EdgeInsets.fromLTRB(0.0, 25.0, 0, 3.0),
            margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 2.0, color: Colors.orange[900]),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                new Text(
                  set[1]['trick'],
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey[100],
                  ),
                ),
                new Text(
                  set[1]['reps'] + ' reps',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey[100],
                  ),
                ),
              ],
            ),
          ),).toList(),
      );
      
      
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: Text(sessionTitle),
          centerTitle: true,
          backgroundColor: Colors.orange[900],
          elevation: 0.0,
        ),
        body: Column(
          children: [
            Container(
              child: getSetsWidgets(sessionSets),
            ),
            
          ],
        ),
    );
  }
}