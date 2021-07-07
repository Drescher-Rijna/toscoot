import 'package:flutter/material.dart';
import 'package:toscoot/models/results.dart';

class AllTimeRatioTile extends StatefulWidget {

  final AllTimeTotals totals;
  AllTimeRatioTile(this.totals);

  @override
  _AllTimeRatioTileState createState() => _AllTimeRatioTileState(totals);
}

class _AllTimeRatioTileState extends State<AllTimeRatioTile> {
  final AllTimeTotals totals;
    _AllTimeRatioTileState (this.totals);

  @override
  Widget build(BuildContext context) {
    
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

    return Padding(
      padding: EdgeInsets.fromLTRB(5, 8, 5, 0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 2, color: Colors.grey[900]))
        ),
        child: Card(
          color: Color(0xff121212),
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
                    color: Color(0xffff008b),
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