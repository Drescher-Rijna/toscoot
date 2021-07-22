import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toscoot/models/alertShow.dart';
import 'package:toscoot/models/tricklist.dart';
import 'package:toscoot/models/user.dart';
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

  //dont ask again
  bool yesorno = false;
  bool isChecked = false;
  

  @override
  Widget build(BuildContext context) {  

    final UserData user = Provider.of<UserData>(context) ?? [];

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
                tricklist.title,
                style: TextStyle(
                  color: Color(0xff1a1a1a),
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TrickListDetails(tricklistid: tricklist.id, tricklisttitle: tricklist.title,)));
                    },
                    icon: Icon(
                      Icons.read_more,
                      color: Color(0xff1a1a1a),
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TricklistStatsCurrent(tricklist.id)));
                    },
                    icon: Icon(
                      Icons.leaderboard,
                      color: Color(0xff1a1a1a),
                    ),
                  ),

                  IconButton(
                    onPressed: () async {
                      if (user.showAlerts == false) {
                        showDialog( 
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              
                              return StatefulBuilder(
                                builder: (context, setState) {
                                
                                return AlertDialog(
                                  backgroundColor: Color(0xfff2f2f2),
                                  title: Text(
                                    "You sure you want to delete this",
                                    style: TextStyle(color: Color(0xff1a1a1a)),
                                  ),
                                  content: Text(
                                    "*Be aware: Deleting this will make it lost forever",
                                    style: TextStyle(color: Color(0xff1a1a1a)),
                                  ),
                                  actions: <Widget>[
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              TextButton(
                                        child: const Text(
                                          'Yes',
                                          style: TextStyle(color: Color(0xff006837), fontSize: 18),
                                        ),
                                        onPressed: () async {
                                          if (tricklist.id == user.activeID) {
                                            await DatabaseService().updateUserActiveID('noIDisChoosen');
                                            DatabaseService.ActiveID = 'noIDisChoosen';
                                          }
                                          await DatabaseService().deleteFromTricklist(tricklist.id);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text(
                                          'No',
                                          style: TextStyle(color: Color(0xffad0000), fontSize: 18),
                                          
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                            ],
                                          ),
                                          SizedBox(height: 20,),
                                          Row(
                                            children: [
                                              Text(
                                                "Don't ask me again",
                                                style: TextStyle(
                                                  color: Color(0xff1a1a1a),
                                                  fontSize: 18,
                                                ),
                                              ),
                                              Checkbox(
                                                checkColor: Colors.white,
                                                fillColor: MaterialStateProperty.all(Color(0xff006837)),
                                                value: isChecked, 
                                                onChanged: (val) {
                                                    setState(() {
                                                      isChecked = val;                                                
                                                    });

                                                    DatabaseService().updateUserAlerts(isChecked);

                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                  ],
                                );
                                }
                              );
                            });
                            
                      } else {
                        if (tricklist.id == user.activeID) {
                          await DatabaseService().updateUserActiveID('noIDisChoosen');
                          DatabaseService.ActiveID = 'noIDisChoosen';
                        }

                        await DatabaseService().deleteFromTricklist(tricklist.id);
                      }
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Color(0xff1a1a1a),
                    ),
                    highlightColor: Colors.orange[900],
                  ),

                  FutureBuilder(
                      future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).collection('tricklists').doc(tricklist.id).get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return IconButton(
                          icon: Icon(Icons.check_circle_outline_sharp),
                          color: snapshot.data['isActive'] ? Color(0xff006837) : Colors.grey[600],
                          disabledColor: Color(0xff1a1a1a),
                          onPressed: () async {
                            if (user.activeID == 'noIDisChoosen') {
                              setState(() {
                                _isDisabled = false;                                
                              });
                            } 
                            if (user.activeID != 'noIDisChoosen' && user.activeID != tricklist.id) {
                              setState(() {
                                _isDisabled = true;                                
                              });
                            }
                            if (user.activeID != 'noIDisChoosen' && user.activeID == tricklist.id) {
                              setState(() {
                                _isDisabled = false;                                
                              });
                            }

                            if(_isDisabled == false)  {
                            if (!snapshot.data['isActive']) {

                              await DatabaseService().trickListCollection.doc(tricklist.id).update({
                                'isActive': true,
                              });

                              await DatabaseService().updateUserActiveID(tricklist.id);

                              DatabaseService.ActiveID = tricklist.id;


                            } else {

                              await DatabaseService().trickListCollection.doc(tricklist.id).update({
                                'isActive': false,
                              });

                              await DatabaseService().updateUserActiveID('noIDisChoosen');

                              DatabaseService.ActiveID = 'noIDisChoosen';
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

