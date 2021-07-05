import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toscoot/models/results.dart';
import 'package:toscoot/models/tricklist.dart';
import 'package:toscoot/services/database.dart';
import 'package:toscoot/stats/tricklist/tricklistRatioTile.dart';

class TricklistRatioStatList extends StatefulWidget {

  @override
  _TricklistRatioStatListState createState() => _TricklistRatioStatListState();
}

class _TricklistRatioStatListState extends State<TricklistRatioStatList> {
  @override
  Widget build(BuildContext context) {

    final totals = Provider.of<List<Totals>>(context) ?? [];

    return ListView.builder(
      itemCount: totals.length,
      itemBuilder: (context, index) {
        return TricklistRatioTile(totals[index]);
      },
    );
  }
}