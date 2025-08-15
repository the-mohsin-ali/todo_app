import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/models/user_model.dart';

class SharedPrefs {
  static const String userName = 'userName';
  static const String userId = 'userId';
  static const String userEmail = 'userEmail';
  // static const String userPassword = 'userPassword';
  static const String phoneNumber = 'phoneNumber';
  static const String isLoggedIn = 'isLoggedIn';


  static Future<void> saveUserData(UserModel userModel) async {

    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString(userName, userModel.userName??'');
    await sp.setString(userId, userModel.uid??'');
    await sp.setString(userEmail, userModel.email??'');
    await sp.setString(phoneNumber, userModel.phoneNumber??'');
    await sp.setBool(isLoggedIn, true);
 
 
  }

  static Future<String?> getUserId() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(userId);
  }

  static Future<String?> getEmail() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(userEmail);
  }

  static Future<String?> getUsername() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(userName);
  
  }
  static Future<String?> getPhoneNumber() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(phoneNumber);
  }

  static Future<bool?> getIsLoggedIn() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getBool(isLoggedIn);
  }

  static Future<void> clearUserData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
  }

}