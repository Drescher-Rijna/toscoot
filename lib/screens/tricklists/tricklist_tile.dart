import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toscoot/models/tricklist.dart';
import 'package:toscoot/screens/tricklists/tricklist_details.dart';
import 'package:toscoot/services/database.dart';
import 'package:toscoot/stats/tricklist/tricklistStatsCurrent.dart';

class TrickListTile extends StatefulWidget {

  final TrickList tricklist;
  TrickListTile({ this.tricklist });

  @override
  _TrickListTileState createState() => _TrickListTileState(tricklist);
}

class _TrickListTileState extends State<TrickListTile> {

  final tricklist;
  _TrickListTileState( this.tricklist );
  bool _isDisabled = false;
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        color: Colors.grey[900],
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
                  fontSize: 16.0,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TrickListDetails(tricklistTitle: tricklist.title, tricklistTricks: tricklist.tricks,)));
                    },
                    icon: Icon(
                      Icons.read_more,
                      color: Colors.grey[100],
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TricklistStatsCurrent(tricklist.id)));
                    },
                    icon: Icon(
                      Icons.leaderboard,
                      color: Colors.grey[100],
                    ),
                  ),

                  IconButton(
                    onPressed: () async {
                      if (tricklist.id == ActiveID.getID()) {
                        ActiveID.setID('noIDisChoosen');
                      }
                      await DatabaseService().deleteFromTricklist(tricklist.id);
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.grey[100],
                    ),
                    highlightColor: Colors.orange[900],
                  ),

                  FutureBuilder(
                      future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).collection('tricklists').doc(tricklist.id).get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return IconButton(
                          icon: Icon(Icons.check_circle_outline_sharp),
                          color: snapshot.data['isActive'] ? Color(0xff00e000) : Colors.grey[700],
                          disabledColor: Colors.grey[900],
                          onPressed: () async {
                            if (ActiveID.getID() == 'noIDisChoosen') {
                              setState(() {
                                _isDisabled = false;                                
                              });
                            } 
                            if (ActiveID.getID() != 'noIDisChoosen' && ActiveID.getID() != tricklist.id) {
                              setState(() {
                                _isDisabled = true;                                
                              });
                            }
                            if (ActiveID.getID() != 'noIDisChoosen' && ActiveID.getID() == tricklist.id) {
                              setState(() {
                                _isDisabled = false;                                
                              });
                            }

                            if(_isDisabled == false)  {
                            if (!snapshot.data['isActive']) {

                              await DatabaseService().trickListCollection.doc(tricklist.id).update({
                                'isActive': true,
                              });

                              await ActiveID.setID(tricklist.id);

                            } else {

                              await DatabaseService().trickListCollection.doc(tricklist.id).update({
                                'isActive': false,
                              });

                              await ActiveID.setID('noIDisChoosen');

                            }

                            } else {
                              return null;
                            }
                            
                          },
                        );
                        } else {
                          print(snapshot.data);
                          return IconButton(
                            icon: Icon(Icons.check_circle_outline_sharp),
                            color: Colors.grey[700],
                            onPressed: () {},
                          );
                          
                        }
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

