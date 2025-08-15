import 'package:todo_app/view_models/services/shared_prefs.dart';

class GlobalVariable {

  static String userName = '';  
  static String userEmail = '';
  static String userNumber = '';

  static Future<void> init() async {
    userName = await SharedPrefs.getUsername() ?? '';
    userEmail = await SharedPrefs.getEmail() ?? '';
    userNumber = await SharedPrefs.getPhoneNumber() ?? '';
  }
}