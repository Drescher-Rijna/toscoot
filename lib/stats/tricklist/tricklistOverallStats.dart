import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toscoot/models/results.dart';


class TricklistOverallStats extends StatefulWidget {

  @override
  _TricklistOverallStatsState createState() => _TricklistOverallStatsState();
}

class _TricklistOverallStatsState extends State<TricklistOverallStats> {

  @override
  Widget build(BuildContext context) {

    final List<Totals> totals= Provider.of<List<Totals>>(context) ?? [];
    final List<SetResults> setResults = Provider.of<List<SetResults>>(context) ?? [];
    final List<SetResultsOld> setResultsOld = Provider.of<List<SetResultsOld>>(context) ?? [];

    compareRatios() {
      var sumLands = 0;
      var sumFails = 0;
      var sumLandsOld = 0;
      var sumFailsOld = 0;
      double ratio;
      double ratioOld;
      double comparing;
      var given_list = totals;
      var given_list_old = setResultsOld;

      for (var i = 0; i < given_list.length; i++) {
        sumLands += given_list[i].lands;
        sumFails += given_list[i].fails;
      }

      for (var i = 0; i < given_list_old.length; i++) {
        sumLandsOld += given_list_old[i].lands;
        sumFailsOld += given_list_old[i].fails;
      }

      ratio = ((sumLands/given_list.length)/((sumLands/given_list.length)+(sumFails/given_list.length)));
      ratioOld = ((sumLandsOld/given_list_old.length)/((sumLandsOld/given_list_old.length)+(sumFailsOld/given_list_old.length)));
      
      comparing = ratio - ratioOld;

      if (given_list.isEmpty || comparing.isNaN) {
        comparing = 0;
        return comparing;
      } else {
        return comparing;
      }
      
    }

    landingRatio() {
      var sumLands = 0;
      var sumFails = 0;
      double ratio;
      var given_list = totals;

      for (var i = 0; i < given_list.length; i++) {
        sumLands += given_list[i].lands;
        sumFails += given_list[i].fails;
      }

      ratio = ((sumLands/given_list.length)/((sumLands/given_list.length)+(sumFails/given_list.length)));
      
      if (ratio.isNaN) {
        ratio = 0;
        return ratio;
      } else {
        return ratio;
      }
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


    Color getColor() {
      Color color;
      if (compareRatios() == 0) {
        color = Color(0xffd4145a);
      }

      if (compareRatios().isNegative) {
        color = Color(0xffdb0707);
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

   
    return setResults.isEmpty || setResults == [] ? Center(child: Text('No activity has been detected', style: TextStyle(color: Colors.grey[100], fontSize: 25),)) : Container(
      child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sesh completion',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1a1a1a),
                ),
              ),
              SizedBox(height: 20,),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    child: SizedBox(
                      height: 135,
                      width: 135,
                      child: CircularProgressIndicator(
                        strokeWidth: 20.0,
                        
                        value: (completionRate()/100),
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xff006837)),
                        
                      ),
                    ),
                  ),
                  Align(
                    child: Text(
                      completionRate().round().toString() + '%',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1a1a1a),
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
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1a1a1a),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      Text(
                        landingRatio().toStringAsFixed(2),
                        style: TextStyle(
                            fontSize: 34,
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
            ],
          ),
      );
  }
}