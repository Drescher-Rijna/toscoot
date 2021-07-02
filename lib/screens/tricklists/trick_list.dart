import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toscoot/models/tricklist.dart';
import 'package:toscoot/screens/tricklists/tricklist_tile.dart';
import 'package:toscoot/shared/loading.dart';

class TrickListScreen extends StatefulWidget {

  @override
  _TrickListScreenState createState() => _TrickListScreenState();
}

class _TrickListScreenState extends State<TrickListScreen> {
  @override
  Widget build(BuildContext context) {

    final tricklists = Provider.of<List<TrickList>>(context);

    return ListView.builder(
      itemCount: tricklists.length,
      itemBuilder: (context, index) {
        return TrickListTile(tricklist: tricklists[index]);
      },
    );
  }
}