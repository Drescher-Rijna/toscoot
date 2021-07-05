import 'package:flutter/material.dart';
import 'package:toscoot/models/results.dart';

class SeshStatsRatioTile extends StatefulWidget {

  final setResults;
  SeshStatsRatioTile(this.setResults);

  @override
  _SeshStatsRatioTileState createState() => _SeshStatsRatioTileState(setResults);
}

class _SeshStatsRatioTileState extends State<SeshStatsRatioTile> {

  final SetResults setResults;
  _SeshStatsRatioTileState(this.setResults);

  landingRatio() {
      var lands = setResults.lands;
      var fails = setResults.fails;
      double ratio;

      ratio = lands/(lands+fails);
      
      return ratio.toStringAsFixed(2);
  }

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
                  landingRatio(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellowAccent[400],
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