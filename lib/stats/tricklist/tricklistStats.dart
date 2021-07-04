import 'package:flutter/material.dart';
import 'package:toscoot/stats/tricklist/tricklistStatsCurrent.dart';
import 'package:toscoot/stats/tricklist/tricklistStatsWeekAgo.dart';

class AllTimeStats extends StatefulWidget {

  @override
  _AllTimeStatsState createState() => _AllTimeStatsState();
}

class _AllTimeStatsState extends State<AllTimeStats> {

  bool showCurrent = true;
  void toggleView() {
    setState(() => showCurrent = !showCurrent);
  }

  @override
  Widget build(BuildContext context) {
    if (showCurrent) {
      return TricklistStatsCurrent(toggleView: toggleView);
    } else {
      return TricklistStatsWeekAgo(toggleView: toggleView);
    }
  }
}