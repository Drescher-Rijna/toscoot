import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toscoot/models/results.dart';
import 'package:toscoot/services/database.dart';
import 'package:toscoot/stats/all-time/allTimeRatioTile.dart';

class AllTimeRatioList extends StatefulWidget {

  @override
  _AllTimeRatioListState createState() => _AllTimeRatioListState();
}

class _AllTimeRatioListState extends State<AllTimeRatioList> {
  @override
  Widget build(BuildContext context) {
    final ratios = Provider.of<List<AllTimeRatio>>(context) ?? [];
    print(ratios.length);
    return StreamProvider<List<SetResultsOld>>.value(
      value: DatabaseService().allTimeWeekAgoSetResults,
      child: ListView.builder(
        itemCount: ratios.length,
        itemBuilder: (context, index) {
          return AllTimeRatioTile(ratios[index]);
        },
      ),
    );
  }
}