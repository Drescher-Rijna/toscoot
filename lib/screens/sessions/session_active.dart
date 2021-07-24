import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:toscoot/models/results.dart';
import 'package:toscoot/models/session.dart';
import 'package:toscoot/screens/sessions/session_active_sets.dart';
import 'package:toscoot/services/database.dart';
import 'package:toscoot/stats/sesh/seshStats.dart';

class SessionActive extends StatefulWidget {

  @override
  _SessionActiveState createState() => _SessionActiveState();
}

class _SessionActiveState extends State<SessionActive> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<CurrentSets>>.value(value: DatabaseService().currentSets,),
        StreamProvider<List<SetResults>>.value(value: DatabaseService().setResults,),
        StreamProvider<Results>.value(value: DatabaseService().completeResults,),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text('Session'),
          centerTitle: true,
          backgroundColor: Color(0xffa10a02),
          elevation: 0.0,
        ),

        body: Column(
          children: [
            TotalSessionTimer(),
            SizedBox(height: 15,),
            Expanded(child: SessionActiveSets()),
          ],
        ),
        
      ),
    );
  }
}

class TotalSessionTimer extends StatefulWidget {
  
  @override
  _TotalSessionTimerState createState() => _TotalSessionTimerState();
}

class _TotalSessionTimerState extends State<TotalSessionTimer> {

  final StopWatchTimer _stopwatchTimer = StopWatchTimer();
  final _isHours = true;

  @override
  Widget build(BuildContext context) {

    final sets = Provider.of<List<CurrentSets>>(context);
    final Results results = Provider.of<Results>(context);

    bool isStarted;
    bool isRunning;
    

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
          child: StreamBuilder<int>(
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
                    color: Color(0xff1a1a1a),
                    fontSize: 48.0,
                  ),
                ),

                SizedBox(height: 15,),
                // buttons
                SessionState.getStartedState() == true ?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      color: Color(0xff006837),
                      child: IconButton(
                        color: Colors.grey[100],
                        icon: Icon(Icons.play_arrow), 
                        onPressed: () async {
                          if (isRunning == true) {
                            return null;
                          } else {
                            _stopwatchTimer.onExecute.add(StopWatchExecute.start);
                            setState(() {
                              isRunning = true;
                            });

                            SessionState.setRunningState(isRunning);

                          }
                        }
                      ),
                    ),
                    SizedBox(width: 25,),
                    Container(
                      color: Colors.blue[800],
                      child: IconButton(
                        color: Colors.grey[100],
                        icon: Icon(Icons.pause), 
                        onPressed: () {
                          if (isRunning == false) {
                            return null;
                          } else {
                            _stopwatchTimer.onExecute.add(StopWatchExecute.stop);

                            DatabaseService().updateResultsData(displayTime);

                            setState(() {
                              isRunning = false;
                            });
                            SessionState.setRunningState(isRunning);

                          }
                        }
                      ),
                    ),
                    SizedBox(width: 25,),
                    Container(
                      color: Color(0xffa10a02),
                      padding: EdgeInsets.fromLTRB(7, 0, 7, 0),
                      child: TextButton(
                        
                        onPressed: () async {
                          await DatabaseService().updateResultsData(displayTime);
                          await DatabaseService().completeSession(true, DatabaseService.currentSeshID);
                          await DatabaseService().setRatios();
                          await DatabaseService().setTricklistRatios();

                          _stopwatchTimer.onExecute.add(StopWatchExecute.reset);

                          setState(() {
                            isStarted = false;
                          });

                          SessionState.setStartedState(isStarted);

                          Navigator.pop(context);
                        }, 
                        child: Text(
                          'End Session',
                          style: TextStyle(color: Colors.grey[100], fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                )
                :
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: TextButton.icon(
                    onPressed: () {
                      sets.forEach((set) { 
                        return DatabaseService().initSetResults(set.trick, set.reps);
                      });

                      _stopwatchTimer.onExecute.add(StopWatchExecute.start);

                      setState(() {
                        isStarted = true;
                      });

                      SessionState.setStartedState(isStarted);

                    }, 
                    icon: Icon(
                      Icons.play_arrow,
                      color: Colors.grey[100],
                      size: 24.0,
                    ), 
                    label: Text(
                      'Start session',
                      style: TextStyle(
                        color: Colors.grey[100],
                        fontSize: 24.0,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor:Color(0xffa10a02),
                      padding: EdgeInsets.all(13.0),
                    ),       
                  ),
                ),
              ],
            );
          }),
        ),
        
      ],
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
