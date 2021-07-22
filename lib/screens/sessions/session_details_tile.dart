import 'package:flutter/material.dart';
import 'package:toscoot/models/session.dart';

class DetailsTile extends StatefulWidget {

  final CurrentSets currentSets;
  DetailsTile({ this.currentSets });

  @override
  _DetailsTileState createState() => _DetailsTileState(currentSets);
}

class _DetailsTileState extends State<DetailsTile> {

  final currentSets;
  _DetailsTileState( this.currentSets );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        color: Color(0xffe6e6e6),
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5)),
        elevation: 1,
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                currentSets.trick,
                style: TextStyle(
                  color: Color(0xff1a1a1a),
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                currentSets.reps.toString(),
                style: TextStyle(
                  color: Color(0xff1a1a1a),
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}