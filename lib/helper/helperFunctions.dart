import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String loggedInKey = "ISLOGGEDIN";
  static String usernameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";

  static Future<bool> saveLoggedInInfo(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(loggedInKey, isLoggedIn);
  }

  static Future<bool> saveUsernameInfo(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(usernameKey, username);
  }

  static Future<bool> saveUserEmailInfo(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userEmailKey, email);
  }

  static Future<bool> getLoggedInInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(loggedInKey);
  }

  static Future<String> getUsernameInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(usernameKey);
  }

  static Future<String> getUserEmailInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  static Future<bool> logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }

  getChatName(String chatRoomId, String myname) {
    List<String> names = chatRoomId.split("_");
    if (names[0].compareTo(myname) == 0) {
      return names[1];
    } else {
      return names[0];
    }
  }
}
