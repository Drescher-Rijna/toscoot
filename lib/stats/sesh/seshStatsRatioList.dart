import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toscoot/models/results.dart';
import 'package:toscoot/stats/sesh/seshStatsRatioTile.dart';

class SeshStatsRatioList extends StatefulWidget {

  @override
  _SeshStatsRatioListState createState() => _SeshStatsRatioListState();
}

class _SeshStatsRatioListState extends State<SeshStatsRatioList> {
  @override
  Widget build(BuildContext context) {
    final List<SetResults> setResults = Provider.of<List<SetResults>>(context) ?? [];

    return setResults.isEmpty || setResults == [] ? Text('Loading...', style: TextStyle(color: Colors.grey[100], fontSize: 25),) : ListView.builder(
      itemCount: setResults.length,
      itemBuilder: (context, index) {
        return SeshStatsRatioTile(setResults[index]);
      },
    );
  }
}