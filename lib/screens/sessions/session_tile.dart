import 'package:flutter/material.dart';
import 'package:toscoot/models/session.dart';
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
                session.title,
                style: TextStyle(
                  color: Colors.grey[100],
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
                        
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SessionDetails(sessionTitle: session.title, session: session,)));
                      }
                      
                    },
                    icon: Icon(
                      session.isComplete ? Icons.bar_chart : Icons.remove_red_eye,
                      color: Colors.grey[100],
                    ),
                    highlightColor: Colors.orange[900],
                  ),
                  IconButton(
                    onPressed: () async {
                      await DatabaseService().sessionCollection.doc(session.id).delete();
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.grey[100],
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

