import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:toscoot/models/results.dart';
import 'package:toscoot/models/session.dart';
import 'package:toscoot/screens/sessions/session_active_sets.dart';
import 'package:toscoot/services/database.dart';

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
      ],
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: Text('Session'),
          centerTitle: true,
          backgroundColor: Colors.orange[900],
          elevation: 0.0,
        ),

        body: Column(
          children: [
            TotalSessionTimer(),
            Expanded(child: SessionActiveSets()),
          ],
        ),
        
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.orange[900],
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'Tricklists',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_time_rounded),
              label: 'Sessions',
              
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.linear_scale),
              label: 'Lines',
            ),
          ],
          selectedItemColor: Colors.grey[100],
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
                    color: Colors.grey[100],
                    fontSize: 50.0,
                  ),
                ),


                // buttons
                SessionState.getStartedState() == true ?
                Row(
                  children: [
                    IconButton(
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
                    IconButton(
                      icon: Icon(Icons.pause), 
                      onPressed: () {
                        if (isRunning == false) {
                          return null;
                        } else {
                          _stopwatchTimer.onExecute.add(StopWatchExecute.stop);

                          //DatabaseService().updateResultsData(displayTime);

                          setState(() {
                            isRunning = false;
                          });
                          SessionState.setRunningState(isRunning);

                        }
                      }
                    ),
                    TextButton(
                      onPressed: () {
                        
                        //DatabaseService().updateResultsData(displayTime);

                        _stopwatchTimer.onExecute.add(StopWatchExecute.reset);

                        setState(() {
                          isStarted = false;
                        });

                        SessionState.setStartedState(isStarted);
                      }, 
                      child: Text(
                        'End Session',
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
                        fontSize: 20.0,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.orange[900],
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
