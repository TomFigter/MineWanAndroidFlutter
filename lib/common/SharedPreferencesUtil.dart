import 'package:shared_preferences/shared_preferences.dart';

/**
 * SharedPreferences工具类
 */
class SharedPreferencesUtil {
  static put(String key, String value) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(key, value);
  }

  static getString(String key, Function callback) async {
    SharedPreferences.getInstance().then((sharedPreferences) {
      callback(sharedPreferences.getString(key));
    });
  }

  static putUserName(String value) {
    put("username", value);
  }

  static putPassword(String value) {
    put("password", value);
  }

  static putCookie(String value) {
    put("cookie", value);
  }

  static putCookieExpires(String value) {
    put("expires", value);
  }

  static getUserName(Function callback) {
    getString("username", callback);
  }

  static getPassword(Function callback) {
    getString("password", callback);
  }

  static getCookie(Function callback) {
    getString("cookie", callback);
  }

  static getCookieExpires(Function callback) {
    getString("expires", callback);
  }
}
