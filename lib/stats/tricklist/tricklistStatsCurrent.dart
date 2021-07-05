import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toscoot/models/results.dart';
import 'package:toscoot/models/tricklist.dart';
import 'package:toscoot/services/database.dart';
import 'package:toscoot/stats/tricklist/tricklistOverallStats.dart';
import 'package:toscoot/stats/tricklist/tricklistRatioStatList.dart';

class TricklistStatsCurrent extends StatefulWidget {

  final Function toggleView;
  TricklistStatsCurrent({ this.toggleView });

  @override
  _TricklistStatsCurrentState createState() => _TricklistStatsCurrentState();
}

class _TricklistStatsCurrentState extends State<TricklistStatsCurrent> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<Results>>.value(value: DatabaseService().statsTricklistResults,),
        StreamProvider<List<SetResults>>.value(value: DatabaseService().statsTricklistSetResults,),
        StreamProvider<ActiveTricklist>.value(value: DatabaseService().activeTricklist,),
      ],
      child: Column(
        children: [
          SizedBox(height: 20,),
          Text(
            'All-Time Stats',
            style: TextStyle(
              color: Colors.grey[100],
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20,),
          TricklistOverallStats(),
          Row(
            children: [
              TricklistRatioStatList(),
            ],
          ),
        ],
      ),
    );
  }
}