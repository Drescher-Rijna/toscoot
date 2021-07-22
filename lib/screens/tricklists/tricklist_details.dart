import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toscoot/models/tricklist.dart';
import 'package:toscoot/screens/tricklists/tricklist_details_list.dart';
import 'package:toscoot/services/database.dart';

class TrickListDetails extends StatelessWidget {

  String tricklistid;
  String tricklisttitle;
  TrickListDetails({this.tricklisttitle, this.tricklistid});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<ActiveTricklist>.value(
      value: DatabaseService(tricklistID: tricklistid).clickedTricklist,
      child: Scaffold(
        backgroundColor: Color(0xfff2f2f2),
          appBar: AppBar(
            title: Text(tricklisttitle),
            centerTitle: true,
            backgroundColor: Color(0xffad0000),
            elevation: 0.0,
          ),
          body: TricklistDetailsList(),
      ),
    );
  }
}