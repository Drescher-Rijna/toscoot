import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toscoot/models/results.dart';
import 'package:toscoot/stats/all-time/allTimeRatioTile.dart';

class AllTimeRatioList extends StatefulWidget {

  @override
  _AllTimeRatioListState createState() => _AllTimeRatioListState();
}

class _AllTimeRatioListState extends State<AllTimeRatioList> {
  @override
  Widget build(BuildContext context) {
    final totals = Provider.of<List<AllTimeTotals>>(context) ?? [];

    return ListView.builder(
      itemCount: totals.length,
      itemBuilder: (context, index) {
        return AllTimeRatioTile(totals[index]);
      },
    );
  }
}