import 'package:todo_app/view_models/services/shared_prefs.dart';

class GlobalVariable {

  static String userName = '';  
  static String userEmail = '';
  static String userNumber = '';

  static Future<void> init() async {
    userName = await SharedPrefs.getUsername() ?? '';
    print('userName: $userName');
    userEmail = await SharedPrefs.getEmail() ?? '';
    print('userEmail: $userEmail');
    userNumber = await SharedPrefs.getPhoneNumber() ?? '';
    print('userNumber: $userNumber');
  }
}