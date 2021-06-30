import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  @override
  Widget build(BuildContext context) {

    final sets = Provider.of<List<CurrentSets>>(context);

    return Column(
      children: [
        Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                  child: Text(
                    '00:00:00',
                    style: TextStyle(
                      fontSize: 60.0,
                      color: Colors.grey[100],
                    ),
                  ),
                ),
                Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: TextButton.icon(
                onPressed: () {
                  sets.forEach((set) { 
                    return DatabaseService().initSetResults(set.trick, set.reps);
                  });
                  
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
            
  }
}

