import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toscoot/models/results.dart';

class AllTimeRatioTile extends StatefulWidget {

  final AllTimeRatio ratios;
  AllTimeRatioTile(this.ratios);

  @override
  _AllTimeRatioTileState createState() => _AllTimeRatioTileState(ratios);
}

class _AllTimeRatioTileState extends State<AllTimeRatioTile> {
    final AllTimeRatio ratios;
    _AllTimeRatioTileState (this.ratios);

  @override
  Widget build(BuildContext context) {

  final List<SetResultsOld> setResultsOld = Provider.of<List<SetResultsOld>>(context) ?? [];

  bool yesorno;

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
                    SizedBox(width: 10,),
                    
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
                      IconButton(
                      onPressed: () async {
                          await showDialog( 
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.grey[100],
                                title: Text(
                                  "You sure you want to delete this",
                                  style: TextStyle(color: Color(0xff1a1a1a)),
                                ),
                                content: Text(
                                  "*Be aware: Deleting this will make it lost forever",
                                  style: TextStyle(color: Color(0xff1a1a1a)),
                                ),
                                actions: [
                                    TextButton(
                                      child: Text(
                                        'Yes',
                                        style: TextStyle(color: Color(0xff006837), fontSize: 18),
                                      ),
                                      onPressed: () {
                                        
                                        Navigator.pop(context);
                                        setState(() {
                                          yesorno = true;                
                                        });
                                      },
                                    ),
                                    TextButton(
                                      child: const Text(
                                        'No',
                                        style: TextStyle(color: Color(0xffad0000), fontSize: 18),
                                        
                                      ),
                                      onPressed: () {
                                        
                                        Navigator.pop(context, 'No');
                                        setState(() {
                                          yesorno = false;                
                                        });
                                        print(yesorno);
                                      },
                                    ),
                                ],
                              );
                          }
                          
                        );
                        
                        if (yesorno == true) {
                          await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).collection('ratios').doc(ratios.trick).delete();
                          await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).collection('totals').doc(ratios.trick).delete();
                        }
                      
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Color(0xff1a1a1a),
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


