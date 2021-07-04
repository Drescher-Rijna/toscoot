import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toscoot/models/results.dart';

class SeshStatsOverall extends StatefulWidget {

  @override
  _SeshStatsOverallState createState() => _SeshStatsOverallState();
}

class _SeshStatsOverallState extends State<SeshStatsOverall> {

  @override
  Widget build(BuildContext context) {

    final Results overallResults = Provider.of<Results>(context);
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

      ratio = 1 - ((sumFails/given_list.length)/(sumLands/given_list.length));
      
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
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Column(
        children: [
          Column(
            children: [
              Text(
                'Session completion',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[100],
                ),
              ),
              SizedBox(height: 10,),
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
                    child: SizedBox(
                      height: 40,
                      child: LinearProgressIndicator(
                        value: completionRate(),
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent[700]),
                        
                      ),
                    ),
                  ),
                  Align(
                    child: Text(
                      completionRate().round().toString() + '%',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[100],
                      ),
                    ), 
                    alignment: Alignment.bottomCenter,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    'Landing Ratio',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[100],
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    landingRatio(),
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellowAccent[400],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'Overall Time',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[100],
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    overallResults.completeTime.substring(0,8),
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent[400],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}