import 'package:shared_preferences/shared_preferences.dart';

class TrickList {

  final String title;
  final List tricks;
  final String id;
  final bool isActive;

  TrickList({ this.title, this.tricks, this.id, this.isActive });

}


class ActiveTricklist {
  final String id;
  final List tricks;

  ActiveTricklist({ this.id, this.tricks });

}

class ActiveID {
  static SharedPreferences _preferences;

  static const _keyID = 'activeID';

  static Future init() async =>
    _preferences = await SharedPreferences.getInstance();

  static Future setID(String id) async =>
    await _preferences.setString(_keyID, id);

  static String getID() => _preferences.getString(_keyID);

}