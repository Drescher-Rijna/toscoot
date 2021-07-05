import 'package:flutter/material.dart';
import 'package:toscoot/models/results.dart';

class TricklistRatioTile extends StatefulWidget {

  final totals;
  TricklistRatioTile(this.totals);

  @override
  _TricklistRatioTileState createState() => _TricklistRatioTileState(totals);
}

class _TricklistRatioTileState extends State<TricklistRatioTile> {

  final Totals totals;
  _TricklistRatioTileState(this.totals);

  landingRatio() {
      var lands = totals.lands;
      var fails = totals.fails;
      double ratio;

      if (lands == 0 && fails == 0 || lands == 0) {
        ratio = 0;
        return ratio.toString();
      } else {
        ratio = lands/(lands+fails);
        return ratio.toStringAsFixed(2);
      }

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
                  totals.trick,
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