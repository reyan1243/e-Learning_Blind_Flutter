import 'package:shared_preferences/shared_preferences.dart';

class LogoutService {
  static Future<void> logOut() async {
    // note
    // the auth key will be deleted from local storage so the user
    // will be redirected to log in instead of already logged in

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth');
  }
}
