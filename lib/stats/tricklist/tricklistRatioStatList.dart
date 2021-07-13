import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toscoot/models/results.dart';
import 'package:toscoot/services/database.dart';
import 'package:toscoot/stats/tricklist/tricklistRatioTile.dart';

class TricklistRatioStatList extends StatefulWidget {

  final String id;
  TricklistRatioStatList(this.id);

  @override
  _TricklistRatioStatListState createState() => _TricklistRatioStatListState(id);
}

class _TricklistRatioStatListState extends State<TricklistRatioStatList> {

  final String id;
  _TricklistRatioStatListState(this.id);

  @override
  Widget build(BuildContext context) {
    print('trick list id');
    print(id);
  
    final ratios = Provider.of<List<TricklistRatio>>(context) ?? [];
    print('ratios length');
    print(ratios.length);

    return StreamProvider<List<SetResultsOld>>.value(
      value: DatabaseService(tricklistID: id).tricklistWeekAgoSetResults,
      child: ListView.builder(
        itemCount: ratios.length,
        itemBuilder: (context, index) {
          return TricklistRatioTile(ratios[index]);
        },
      ),
    );
  }
}