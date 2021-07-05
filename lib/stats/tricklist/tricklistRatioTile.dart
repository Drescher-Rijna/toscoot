import 'package:flutter/material.dart';
import 'package:toscoot/models/results.dart';

class TricklistRatioTile extends StatefulWidget {

  final setResults;
  TricklistRatioTile(this.setResults);

  @override
  _TricklistRatioTileState createState() => _TricklistRatioTileState(setResults);
}

class _TricklistRatioTileState extends State<TricklistRatioTile> {

  final SetResults setResults;
  _TricklistRatioTileState(this.setResults);

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}