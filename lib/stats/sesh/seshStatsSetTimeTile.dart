import 'dart:async';
import 'package:flutter/material.dart';
import 'package:toscoot/models/results.dart';

class SeshStatsSetTimeTile extends StatefulWidget {

  final setResults;
  SeshStatsSetTimeTile(this.setResults);

  @override
  _SeshStatsSetTimeTileState createState() => _SeshStatsSetTimeTileState(setResults);
}

class _SeshStatsSetTimeTileState extends State<SeshStatsSetTimeTile> {

  final SetResults setResults;
  _SeshStatsSetTimeTileState(this.setResults);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5, 8, 5, 0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.orange[900]))
        ),
        child: Card(
          color: Colors.grey[900],
          margin: EdgeInsets.fromLTRB(0, 0.0, 0, 0.0),
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  setResults.trick,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[100]
                  ),
                ),
                Text(
                  setResults.setTime.substring(0, 8),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent[400],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}