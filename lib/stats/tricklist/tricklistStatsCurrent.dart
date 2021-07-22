import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toscoot/models/results.dart';
import 'package:toscoot/models/tricklist.dart';
import 'package:toscoot/services/database.dart';
import 'package:toscoot/stats/tricklist/tricklistOverallStats.dart';
import 'package:toscoot/stats/tricklist/tricklistRatioStatList.dart';

class TricklistStatsCurrent extends StatefulWidget {

  final String tricklistID;
  TricklistStatsCurrent(this.tricklistID);

  @override
  _TricklistStatsCurrentState createState() => _TricklistStatsCurrentState(tricklistID);
}

class _TricklistStatsCurrentState extends State<TricklistStatsCurrent> {

  final String tricklistID;
  _TricklistStatsCurrentState(this.tricklistID);

  @override
  Widget build(BuildContext context) {
    print('tricklist id er: ' );
    print(tricklistID);
    return MultiProvider(
      providers: [
        StreamProvider<List<Totals>>.value(value: DatabaseService(tricklistID: tricklistID).totals,),
        StreamProvider<List<TricklistRatio>>.value(value: DatabaseService(tricklistID: tricklistID).tricklistRatios,),
        StreamProvider<List<SetResults>>.value(value: DatabaseService(tricklistID: tricklistID).tricklistSetResults),
        StreamProvider<List<SetResultsOld>>.value(value: DatabaseService(tricklistID: tricklistID).tricklistWeekAgoSetResults),
      ],
      child: Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        appBar: new AppBar(
          title: Text('ToScoot'),
          centerTitle: true,
          backgroundColor: Color(0xffad0000),
          elevation: 0.0,

        ),
        body: Column(
          children: [
            SizedBox(height: 20,),
            Text(
              'Tricklist Stats',
              style: TextStyle(
                color: Color(0xff1a1a1a),
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20,),
            TricklistOverallStats(),
            SizedBox(height: 20,),
            Expanded(child: TricklistRatioStatList(tricklistID)),
          ],
        ),
      ),
    );
  }
}