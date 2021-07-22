import 'package:flutter/material.dart';
import 'package:toscoot/models/session.dart';
import 'package:toscoot/services/database.dart';

class CreatedSetTile extends StatefulWidget {

  final CurrentSets sets;
  CreatedSetTile({ this.sets });

  @override
  _CreatedSetTileState createState() => _CreatedSetTileState(sets);
}

class _CreatedSetTileState extends State<CreatedSetTile> {

  final sets;
  _CreatedSetTileState( this.sets );

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
                sets.trick,
                style: TextStyle(
                  color: Color(0xff1a1a1a),
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                sets.reps.toString(),
                style: TextStyle(
                  color: Color(0xff1a1a1a),
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      await DatabaseService().sessionCollection.doc(sets.seshID).collection('sets').doc(sets.id).delete();
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Color(0xff1a1a1a),
                    ),
                    highlightColor: Colors.orange[900],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

