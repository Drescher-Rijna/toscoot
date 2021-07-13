import 'package:shared_preferences/shared_preferences.dart';

class AlertShow {

  static SharedPreferences _preferences;

  static const _keyShowAlert = 'showAlert';

  static Future init() async =>
    _preferences = await SharedPreferences.getInstance();

  static Future setAlert(bool show) async =>
    await _preferences.setBool(_keyShowAlert, show);

  static bool getAlert() => _preferences.getBool(_keyShowAlert);

}