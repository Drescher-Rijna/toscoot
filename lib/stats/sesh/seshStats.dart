import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toscoot/models/results.dart';
import 'package:toscoot/screens/home/home.dart';
import 'package:toscoot/screens/sessions/sessions.dart';
import 'package:toscoot/screens/tricklists/tricklists.dart';
import 'package:toscoot/services/auth.dart';
import 'package:toscoot/services/database.dart';
import 'package:toscoot/stats/sesh/seshStatsOverall.dart';
import 'package:toscoot/stats/sesh/seshStatsRatioList.dart';
import 'package:toscoot/stats/sesh/seshStatsSetTimeList.dart';

class SeshStats extends StatefulWidget {

  final String resultsID;
  SeshStats(this.resultsID);

  @override
  _SeshStatsState createState() => _SeshStatsState(resultsID);
}

class _SeshStatsState extends State<SeshStats> {

  final String resultsID;
  _SeshStatsState(this.resultsID); 
  

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    print('resultID');
    print(resultsID);
    return MultiProvider(
      providers: [
        StreamProvider<Results>.value(value: DatabaseService(statsResultsID: resultsID).statsResults),
        StreamProvider<List<SetResults>>.value(value: DatabaseService(statsResultsID: resultsID).statsSetResults),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: Text('Stats'),
          centerTitle: true,
          backgroundColor: Colors.orange[900],
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(
                Icons.person,
                color: Colors.grey[100],
              ),
              label: Text(
                'logout',
                style: TextStyle(
                  color: Colors.grey[100],
                ),
              ),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),

        body: Column(
          children: [
            SeshStatsOverall(),
            SizedBox(height: 25,),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: SeshStatsRatioList()),
                  Expanded(child: SeshStatsSetTimeList()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}