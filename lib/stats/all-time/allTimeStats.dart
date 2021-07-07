import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toscoot/models/results.dart';
import 'package:toscoot/services/database.dart';
import 'package:toscoot/stats/all-time/allTimeOverallStats.dart';
import 'package:toscoot/stats/all-time/allTimeRatioList.dart';

class AllTimeStats extends StatefulWidget {

  @override
  _AllTimeStatsState createState() => _AllTimeStatsState();
}

class _AllTimeStatsState extends State<AllTimeStats> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ 
        StreamProvider<List<AllTimeTotals>>.value(value: DatabaseService().allTimeTotals,),
        StreamProvider<List<SetResults>>.value(value: DatabaseService().allTimeSetResults),
        StreamProvider<List<SetResultsOld>>.value(value: DatabaseService().allTimeWeekAgoSetResults,),
      ],
      child: Column(
        children: [
          SizedBox(height: 20,),
          Text(
            'All-Time Stats',
            style: TextStyle(
              color: Colors.grey[100],
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20,),
          AllTimeOverallStats(),
          SizedBox(height: 20,),
          Expanded(child: AllTimeRatioList()),
        ],
      ),
    );
  }
}