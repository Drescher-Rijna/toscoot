import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toscoot/models/results.dart';

class TricklistRatioTile extends StatefulWidget {

  final ratios;
  TricklistRatioTile(this.ratios);

  @override
  _TricklistRatioTileState createState() => _TricklistRatioTileState(ratios);
}

class _TricklistRatioTileState extends State<TricklistRatioTile> {

  final TricklistRatio ratios;
  _TricklistRatioTileState(this.ratios);

  @override
  Widget build(BuildContext context) {

    final List<SetResultsOld> setResultsOld = Provider.of<List<SetResultsOld>>(context) ?? [];
    print('set results from a week ago');
    print(setResultsOld.length);

    compareRatios() {
        double ratio = ratios.ratio;
        var sumLands = 0;
        var sumFails = 0;
        double ratioOld = 0;
        var givenList = setResultsOld;
        double comparedRatio = 0;

        setResultsOld.map((e) => {
          if (e.trick == ratios.trick) {
            sumLands += e.lands,
            sumFails += e.fails
          }
        }).toList();

        ratioOld = sumLands/(sumFails + sumLands);

        if (ratioOld.isNaN || ratioOld == 0 || ratioOld == null) {
          comparedRatio = 0;
        } else {
          comparedRatio = ratio-ratioOld;
        }

        return comparedRatio;
        
      }


      Color getColor() {
        Color color;
        if (compareRatios() == 0) {
          color = Color(0xff1a1a1a);
        }

        if (compareRatios().isNegative) {
          color = Color(0xffad0000);
        } 

        if (compareRatios() > 0) {
          color = Color(0xff006837);
        }

        return color;
      }

      IconData getIcon() {
        IconData icon;
        if (compareRatios() == 0) {
          icon = Icons.arrow_left_outlined;
        }

        if (compareRatios().isNegative) {
          icon = Icons.arrow_drop_down;
        } 

        if (compareRatios() > 0) {
          icon = Icons.arrow_drop_up;
        }

        return icon;
      }


    return Padding(
      padding: EdgeInsets.fromLTRB(5, 8, 5, 0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 2, color: Color(0xfff2f2f2)))
        ),
        child: Card(
          color: Color(0xfff2f2f2),
          margin: EdgeInsets.fromLTRB(0, 0.0, 0, 0.0),
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      ratios.trick,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1a1a1a),
                      ),
                    ),
                  ],
                ),
                Row(
                    children: [
                      Text(
                        ratios.ratio.isNaN ? '0.00' : ratios.ratio.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: getColor(),
                        ),
                      ),
                      Icon(
                        getIcon(),
                        color: getColor(),
                      ),
                      Text(
                        compareRatios().toStringAsFixed(2),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: getColor(),
                        ),
                        
                      ),
                    ],
                  ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}