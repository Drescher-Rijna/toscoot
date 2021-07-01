import 'dart:async';
import 'package:flutter/material.dart';
import 'package:toscoot/models/results.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:toscoot/services/database.dart';

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
      int _currentLand = setResults.lands;
      int _currentFail = setResults.fails;
      
      final StopWatchTimer _stopwatchTimer = StopWatchTimer();
      final _isHours = true;

    void showSettingsPanel() {
      showModalBottomSheet(context: context, builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
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

                      StreamBuilder<int>(
                        stream: _stopwatchTimer.rawTime,
                        initialData: _stopwatchTimer.rawTime.value,
                        builder: (context, snapshot,) {

                        final value = snapshot.data;
                        final displayTime = StopWatchTimer.getDisplayTime(value, hours: _isHours);

                        return Column(
                          children: [
                            Text(
                              displayTime,
                              style: TextStyle(
                                fontSize: 40.0,
                                color: Colors.grey[100]
                              ),
                            ),
                            SizedBox(height: 5.0,),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.play_arrow), 
                                  onPressed: () {
                                    _stopwatchTimer.onExecute.add(StopWatchExecute.start);
                                    DatabaseService().updateSetResultsData(setResults.id, _currentLand, _currentFail, displayTime);
                                  }
                                ),
                                IconButton(
                                  icon: Icon(Icons.pause), 
                                  onPressed: () {
                                    _stopwatchTimer.onExecute.add(StopWatchExecute.stop);
                                    DatabaseService().updateSetResultsData(setResults.id, _currentLand, _currentFail, displayTime,);
                                  }
                                ),
                                IconButton(
                                  icon: Icon(Icons.stop), 
                                  onPressed: () async {
                                    await DatabaseService().endSet(setResults.id, _currentLand, _currentFail, displayTime, setResults.isDone);
                                    
                                    _stopwatchTimer.onExecute.add(StopWatchExecute.reset);
                                    
                                    setState(() {
                                      _currentLand = 0;
                                      _currentFail = 0;
                                    });

                                    Navigator.pop(context);
                                  }
                                ),
                              ],
                            ),

                            // COUNTERS
                            Column(
                              children: [
                                Text(
                                  _currentLand.toString() + '/10',
                                  style: TextStyle(
                                    fontSize: 40.0,
                                    color: Colors.grey[100]
                                  ),
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      color: Colors.greenAccent[700],
                                      padding: EdgeInsets.fromLTRB(7, 0, 7, 0),
                                      child: TextButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.greenAccent[700]),
                                        ),
                                        child: Text(
                                          'Land',
                                          style: TextStyle(
                                            fontSize: 25.0,
                                            color: Colors.grey[100]
                                          ),
                                        ),
                                        onPressed: () async {
                                          setState(() {
                                            _currentLand++;
                                          });

                                          if (_currentLand == setResults.goal) {
                                            await DatabaseService().endSet(setResults.id, _currentLand, _currentFail, displayTime, true);
                                            
                                            _stopwatchTimer.onExecute.add(StopWatchExecute.reset);

                                            setState(() {
                                              _currentLand = 0;
                                              _currentFail = 0;
                                            });

                                            Navigator.pop(context);
                                          } else {
                                            await DatabaseService().updateSetResultsData(setResults.id, _currentLand, _currentFail, displayTime,);
                                          }
                                          

                                        }
                                      ),
                                    ),
                                    SizedBox(width: 20.0,),
                                    Container(
                                      color: Colors.redAccent[700],
                                      padding: EdgeInsets.fromLTRB(0, 0, 12, 0),
                                      
                                      child: Row(
                                        children: [
                                          TextButton(
                                            child: Text(
                                              'Fail',
                                              style: TextStyle(
                                                fontSize: 25.0,
                                                color: Colors.grey[100]
                                              ),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _currentFail++;
                                              });

                                              DatabaseService().updateSetResultsData(setResults.id, _currentLand, _currentFail, displayTime,);
                                            }
                                          ),
                                          Text(
                                            _currentFail.toString(),
                                            style: TextStyle(
                                              fontSize: 25.0,
                                              color: Colors.grey[100]
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ],
              ),
            );
          }
          
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


Stream<int> stopWatchStream() {
    StreamController<int> streamController;
    Timer timer;
    Duration timerInterval = Duration(seconds: 1);
    int counter = 0;

    void stopTimer() {
      if (timer != null) {
        timer.cancel();
        timer = null;
        counter = 0;
        streamController.close();
      }
    }

    void tick(_) {
      counter++;
      streamController.add(counter);
    }

    void startTimer() {
      timer = Timer.periodic(timerInterval, tick);
    }

    streamController = StreamController<int>(
      onListen: startTimer,
      onCancel: stopTimer,
      onResume: startTimer,
      onPause: stopTimer,
    );

    return streamController.stream;
  }

