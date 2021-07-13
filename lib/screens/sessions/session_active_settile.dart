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

   SetResults setResults;
  _SessionActiveSetTileState( this.setResults );

  @override
  void didUpdateWidget(SessionActiveSetTile oldWidget) {
      if(setResults != widget.setResults) {
          setState((){
              setResults = widget.setResults;
          });
      }
      super.didUpdateWidget(oldWidget);
  }

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
            return !setResults.isDone ? Container(
              color: Color(0xff121212),
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        setResults.trick,
                        style: TextStyle(
                          fontSize: 24.0,
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
                            SizedBox(height: 10.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 45,
                                  height: 45,
                                  color: Color(0xff00e000),
                                  child: IconButton(
                                    color: Colors.grey[100],
                                    icon: Icon(Icons.play_arrow), 
                                    onPressed: () {
                                      _stopwatchTimer.onExecute.add(StopWatchExecute.start);
                                      DatabaseService().updateSetResultsData(setResults.id, _currentLand, _currentFail, displayTime);
                                    }
                                  ),
                                ),
                                SizedBox(width: 25.0,),
                                Container(
                                  width: 45,
                                  height: 45,
                                  color: Colors.blueAccent[700],
                                  child: IconButton(
                                    color: Colors.grey[100],
                                    icon: Icon(Icons.pause), 
                                    onPressed: () {
                                      _stopwatchTimer.onExecute.add(StopWatchExecute.stop);
                                      DatabaseService().updateSetResultsData(setResults.id, _currentLand, _currentFail, displayTime,);
                                    }
                                  ),
                                ),
                                SizedBox(width: 25.0,),
                                Container(
                                  padding: EdgeInsets.fromLTRB(7, 0, 7, 0),
                                  color: Color(0xffe00000),
                                  child: TextButton(
                                    child: Text('End set', style: TextStyle(color: Colors.grey[100], fontSize: 16.0,),),
                                    onPressed: () async {
                                      await DatabaseService().endSet(setResults.id, _currentLand, _currentFail, displayTime, setResults.isDone);
                                      await DatabaseService().updateTotalsData(_currentLand, _currentFail, setResults.trick);
                                      await DatabaseService().updateTricklistTotalsData(_currentLand, _currentFail, setResults.trick);
                                      
                                      _stopwatchTimer.onExecute.add(StopWatchExecute.reset);
                                      
                                      setState(() {
                                        _currentLand = 0;
                                        _currentFail = 0;
                                      });

                                      Navigator.pop(context);
                                    }
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30,),
                            // COUNTERS
                            Column(
                              children: [
                                Text(
                                  _currentLand.toString() + '/' + setResults.goal.toString(),
                                  style: TextStyle(
                                    fontSize: 34.0,
                                    color: Colors.grey[100]
                                  ),
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      color: Color(0xff00e000),
                                      padding: EdgeInsets.fromLTRB(7, 0, 7, 0),
                                      child: TextButton(
                                        child: Text(
                                          'Land',
                                          style: TextStyle(
                                            fontSize: 24.0,
                                            color: Colors.grey[100]
                                          ),
                                        ),
                                        onPressed: () async {
                                          if (_currentLand < setResults.goal) {
                                            setState(() {
                                              _currentLand++;
                                            });

                                            await DatabaseService().updateSetResultsData(setResults.id, _currentLand, _currentFail, displayTime,);
                                          }

                                          if (_currentLand == setResults.goal) {
                                            await DatabaseService().endSet(setResults.id, _currentLand, _currentFail, displayTime, true);
                                            await DatabaseService().updateTotalsData(_currentLand, _currentFail, setResults.trick);
                                            await DatabaseService().updateTricklistTotalsData(_currentLand, _currentFail, setResults.trick);
                                            
                                            _stopwatchTimer.onExecute.add(StopWatchExecute.reset);

                                            setState(() {
                                              _currentLand = 0;
                                              _currentFail = 0;
                                            });

                                            Navigator.pop(context);
                                          }
                                          
                                        }
                                      ),
                                    ),
                                    SizedBox(width: 20.0,),
                                    Container(
                                      color: Color(0xffe00000),
                                      padding: EdgeInsets.fromLTRB(0, 0, 12, 0),
                                      
                                      child: Row(
                                        children: [
                                          TextButton(
                                            child: Text(
                                              'Fail',
                                              style: TextStyle(
                                                fontSize: 24.0,
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
                                              fontSize: 24.0,
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
            ) 
            
            :

            Container(
              color: Color(0xff121212),
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        setResults.trick,
                        style: TextStyle(
                          fontSize: 34.0,
                          color: Colors.grey[100]
                        ),
                      ),
                      SizedBox(height: 30.0,),
                      Column(
                          children: [
                            Text(
                              'Time: ' + setResults.setTime,
                              style: TextStyle(
                                fontSize: 24.0,
                                color: Colors.grey[100]
                              ),
                            ),
                            SizedBox(height: 30,),
                            // COUNTERS
                            Column(
                              children: [
                                Text(
                                  'Lands: ' + setResults.lands.toString()+ '/' + setResults.goal.toString(),
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    color: Colors.grey[100]
                                  ),
                                ),
                                SizedBox(height: 30.0,),
                                Text(
                                  'Fails: ' + setResults.fails.toString(),
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    color: Colors.grey[100]
                                  ),
                                ),
                              ],
                            ),
                                    
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );

          });
      });
    }

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
                      Icons.arrow_drop_down,
                      size: 30,
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

