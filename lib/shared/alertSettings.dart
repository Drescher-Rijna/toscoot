import 'package:flutter/material.dart';
import 'package:toscoot/models/user.dart';
import 'package:toscoot/services/database.dart';

void alertSettings(context) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return StreamBuilder(
          stream: DatabaseService().users,
          builder: (context, snapshot) {
            
            if (snapshot.hasData) {
              UserData user = snapshot.data ?? [];
              return Container(
              height: 100,
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              color: Colors.grey[100],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new Wrap(
                    children: <Widget>[
                      new ListTile(
                        tileColor: Colors.grey[100],
                          leading: !user.showAlerts ? new Icon(Icons.notifications_active, color: Color(0xff1a1a1a),) : new Icon(Icons.notifications_none, color: Color(0xff1a1a1a),),
                          title: !user.showAlerts ? new Text('Disable alerts', style: TextStyle(color: Color(0xff1a1a1a))) : new Text('Enable alerts', style: TextStyle(color: Color(0xff1a1a1a))),
                          onTap: () => {
                            if (!user.showAlerts) {
                              DatabaseService().updateUserAlerts(true)
                            } else {
                              DatabaseService().updateUserAlerts(false)
                            }
                            
                          }
                      ),
                    ],
                  ),
                ],
              ),
            );
            } else {
              return Container(
                child: Text('Loading...', style: TextStyle(color: Colors.grey[100]),),
              );
            }
          }
          
        );
      });
}