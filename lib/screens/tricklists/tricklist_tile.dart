import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toscoot/models/tricklist.dart';
import 'package:toscoot/screens/tricklists/tricklist_details.dart';
import 'package:toscoot/services/database.dart';

class TrickListTile extends StatefulWidget {

  final TrickList tricklist;
  TrickListTile({ this.tricklist });

  @override
  _TrickListTileState createState() => _TrickListTileState(tricklist);
}

class _TrickListTileState extends State<TrickListTile> {

  final tricklist;
  _TrickListTileState( this.tricklist );

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
                  FutureBuilder(
                      future: DatabaseService().trickListCollection.doc(tricklist.id).get(),
                      builder: (context, AsyncSnapshot snapshot) {
                        return IconButton(
                          icon: Icon(Icons.check_circle_outline_sharp),
                          color: snapshot.data['isActive'] ? Colors.greenAccent[400] : Colors.grey[900],
                          onPressed: () async {
                            if (!snapshot.data['isActive']) {

                              await DatabaseService().trickListCollection.doc(tricklist.id).update({
                                'isActive': true,
                              });

                              print(tricklist.isActive);

                            } else {

                              await DatabaseService().trickListCollection.doc(tricklist.id).update({
                                'isActive': false,
                              });

                              print(tricklist.isActive);

                            }
                            
                          },
                        );
                      }
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

