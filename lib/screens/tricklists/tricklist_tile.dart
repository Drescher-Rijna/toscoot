import 'package:flutter/material.dart';
import 'package:toscoot/models/tricklist.dart';
import 'package:toscoot/screens/tricklists/tricklist_details.dart';
import 'package:toscoot/services/database.dart';

class TrickListTile extends StatelessWidget {

  final TrickList tricklist;
  TrickListTile({ this.tricklist });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        color: Colors.grey[800],
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5)),
        elevation: 1,
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                tricklist.title,
                style: TextStyle(
                  color: Colors.grey[100],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TrickListDetails(tricklistTitle: tricklist.title, tricklistTricks: tricklist.tricks,)));
                    },
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey[100],
                    ),
                    highlightColor: Colors.orange[900],
                  ),
                  IconButton(
                    onPressed: () async {
                      await DatabaseService().trickListCollection.doc(tricklist.id).delete();
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.grey[100],
                    ),
                    highlightColor: Colors.orange[900],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.check_circle_outline_sharp,
                      color: Colors.grey[900],
                    ),
                    focusColor: Colors.green[600],
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