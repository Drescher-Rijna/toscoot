import 'package:flutter/material.dart';
import 'package:toscoot/models/results.dart';

class SessionActiveSetTile extends StatefulWidget {

  final SetResults setResults;

  SessionActiveSetTile( this.setResults );

  @override
  _SessionActiveSetTileState createState() => _SessionActiveSetTileState(setResults);
}

class _SessionActiveSetTileState extends State<SessionActiveSetTile> {

  final setResults;
  _SessionActiveSetTileState( this.setResults );

  

  @override
  Widget build(BuildContext context) {
      int _currentLand = 0;
      int _currentFail = 0;

      void _incrementLand() {
        setState(() {
          _currentLand++;
        });
      }

      void _incrementFail() {
        setState(() {
          _currentFail++;
        });
      }


    void showSettingsPanel() {
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          color: Colors.grey[900],
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    setResults.trick,
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.grey[100]
                    ),
                  ),
                  SizedBox(height: 25.0,),
                  Text(
                    '00:00:00',
                    style: TextStyle(
                      fontSize: 40.0,
                      color: Colors.grey[100]
                    ),
                  ),
                  SizedBox(height: 5.0,),
                  Text(
                    'start',
                    style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.grey[100]
                        ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    _currentLand.toString() + '/10',
                    style: TextStyle(
                      fontSize: 40.0,
                      color: Colors.grey[100]
                    ),
                  ),
                  SizedBox(height: 5.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        child: Text(
                          'Land',
                          style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.grey[100]
                          ),
                        ),
                        onPressed: () {_incrementLand();}
                        ),
                      SizedBox(width: 20.0,),
                      Text(
                        'fail',
                        style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.grey[100]
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      });
    }

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
                setResults.trick,
                style: TextStyle(
                  color: Colors.grey[100],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => showSettingsPanel(),
                    icon: Icon(
                      Icons.remove_red_eye,
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

