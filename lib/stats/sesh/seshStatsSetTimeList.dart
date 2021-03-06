import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toscoot/models/results.dart';
import 'package:toscoot/stats/sesh/seshStatsSetTimeTile.dart';

class SeshStatsSetTimeList extends StatefulWidget {

  @override
  _SeshStatsSetTimeListState createState() => _SeshStatsSetTimeListState();
}

class _SeshStatsSetTimeListState extends State<SeshStatsSetTimeList> {

  @override
  Widget build(BuildContext context) {

    final List<SetResults> setResults = Provider.of<List<SetResults>>(context) ?? [];

    return setResults.isEmpty || setResults == [] ? Text('Loading...', style: TextStyle(color: Colors.grey[100], fontSize: 25)) : ListView.builder(
      itemCount: setResults.length,
      itemBuilder: (context, index) {
        return SeshStatsSetTimeTile(setResults[index]);
      },
    );
  }
}