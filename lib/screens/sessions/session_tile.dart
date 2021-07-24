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
                        
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SessionDetails(sessionTitle: session.title, session: session,)));
                      }
                      
                    },
                    icon: Icon(
                      session.isComplete ? Icons.leaderboard : Icons.read_more,
                      color: Color(0xff1a1a1a),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await DatabaseService().deleteFromSession(session.id);
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

