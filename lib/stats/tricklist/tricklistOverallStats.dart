import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toscoot/models/results.dart';
import 'package:toscoot/models/tricklist.dart';
import 'package:toscoot/services/database.dart';

class TricklistOverallStats extends StatefulWidget {

  @override
  _TricklistOverallStatsState createState() => _TricklistOverallStatsState();
}

class _TricklistOverallStatsState extends State<TricklistOverallStats> {

  @override
  Widget build(BuildContext context) {

    final List<Results> overallResults = Provider.of<List<Results>>(context);
    final List<SetResults> setResults = Provider.of<List<SetResults>>(context);

    landingRatio() {
      var sumLands = 0;
      var sumFails = 0;
      double ratio;
      var given_list = setResults;

      for (var i = 0; i < given_list.length; i++) {
        sumLands += given_list[i].lands;
        sumFails += given_list[i].fails;
      }

      ratio = ((sumLands/given_list.length)/((sumLands/given_list.length)+(sumFails/given_list.length)));
      
      return ratio.toStringAsFixed(2);
    }

    completionRate() {
      double completion;
      var sumGoals = 0;
      var sumLands = 0;
      var given_list = setResults;

      for (var i = 0; i < given_list.length; i++) {
        sumLands += given_list[i].lands;
        sumGoals += given_list[i].goal;
      }
      
      completion = 100 * ((sumLands/given_list.length)/(sumGoals/given_list.length));

      return completion;

    }

   
    return Container(
      child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
            children: [
              Text(
                'Completion rate',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[100],
                ),
              ),
              SizedBox(height: 15,),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    child: SizedBox(
                      height: 135,
                      width: 135,
                      child: CircularProgressIndicator(
                        strokeWidth: 20.0,
                        
                        value: completionRate(),
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent[700]),
                        
                      ),
                    ),
                  ),
                  Align(
                    child: Text(
                      completionRate().round().toString() + '%',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[100],
                      ),
                    ), 
                    alignment: Alignment.center,
                  ),
                ],
              ),
            ],
          ),
              Column(
                children: [
                  Text(
                    'Landing Ratio',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[100],
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    landingRatio(),
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellowAccent[400],
                    ),
                  ),
                ],
              ),
            ],
          ),
      );
  }
}