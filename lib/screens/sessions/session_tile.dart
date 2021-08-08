import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toscoot/models/session.dart';
import 'package:toscoot/models/user.dart';
import 'package:toscoot/screens/sessions/session_details.dart';
import 'package:toscoot/services/database.dart';
import 'package:toscoot/stats/sesh/seshStats.dart';

class SessionTile extends StatefulWidget {

  final Session session;
  SessionTile({ this.session });

  @override
  _SessionTileState createState() => _SessionTileState(session);
}

class _SessionTileState extends State<SessionTile> {

  Session session;
  _SessionTileState( this.session );

  //dont ask again
  bool yesorno = false;
  bool isChecked = true;

  @override
  void didUpdateWidget(SessionTile oldWidget) {
      if(session != widget.session) {
          setState((){
              session = widget.session;
          });
      }
      super.didUpdateWidget(oldWidget);

  }


  @override
  Widget build(BuildContext context) {

    final UserData user = Provider.of<UserData>(context) ?? [];

    @override
    void initState() {
      super.initState();
      setState(() {
        isChecked = user.showAlerts;      
      });
    }

    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        color: Color(0xfff2f2f2),
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5)),
        elevation: 1,
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                session.title,
                style: TextStyle(
                  color: Color(0xff1a1a1a),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      await DatabaseService().getSeshID(session.id);
                        if (session.isComplete) {
                          print('session is complete');
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SeshStats(session.resultsID)));
                        } else {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SessionDetails(session: session, sessionTitle: session.title,)));
                        }
                      },
                    icon: Icon(
                      session.isComplete ? Icons.leaderboard : Icons.read_more,
                      color: Color(0xff1a1a1a),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      setState(() {
                        isChecked = user.showAlerts;                        
                      });
                      if (user.showAlerts == false) {
                        showDialog( 
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              
                              return StatefulBuilder(
                                builder: (context, setState) {
                                
                                return AlertDialog(
                                  backgroundColor: Colors.grey[100],
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
                                          await DatabaseService().deleteFromSession(session.id);
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
                        await DatabaseService().deleteFromSession(session.id);
                      }
                      
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Color(0xff1a1a1a),
                    ),
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

