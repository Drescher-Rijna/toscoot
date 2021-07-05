import 'package:shared_preferences/shared_preferences.dart';

class Results {

  String id;
  String sessionID;
  String completeTime;
  dynamic completionDate;

  Results({ this.id, this.sessionID, this.completeTime, this.completionDate });

}

class SetResults {

  String id;
  String trick;
  int lands;
  int fails;
  int goal;
  String setTime;
  bool isDone;

  SetResults({ this.id, this.trick, this.lands, this.fails, this.goal, this.setTime, this.isDone });

}

class Totals {
  int fails;
  int lands;
  String listID;
  String trick;

  Totals({ this.fails, this.trick, this.lands, this.listID});
}

class SessionState {
  static SharedPreferences _preferences;

  static const _startedID = 'isStarted';
  static const _runningID = 'isRunning';

  static Future initSession() async =>
    _preferences = await SharedPreferences.getInstance();


  static Future setStartedState(bool isStarted) async =>
    await _preferences.setBool(_startedID, isStarted);

  static Future setRunningState(bool isRunning) async =>
    await _preferences.setBool(_runningID, isRunning);

  static bool getStartedState() => _preferences.getBool(_startedID)  ?? false;
  static bool getRunningState() => _preferences.getBool(_runningID) ?? false;
}