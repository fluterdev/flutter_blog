import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefConstant {
  static SharedPreferences? sharedPreferences;
  static bool? get isUserLogin => SharedPrefConstant.sharedPreferences?.getBool(isLoginKey);
}

const String isLoginKey = 'login';
