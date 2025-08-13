import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String userId = 'userId';
  static const String userEmail = 'userEmail';
  static const String userPassword = 'userPassword';
  static const String isLoggedIn = 'isLoggedIn';


  static Future<void> saveUserData(String userID, String email) async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString(userId, userID);
    await sp.setString(userEmail, email);
    await sp.setBool(isLoggedIn, true);
    if(kDebugMode){
      print('User Data Saved: ');
      print('User ID: $userID');
      print('Email: $email'); 
      print('Is Logged In: ${sp.getBool(isLoggedIn)}');
    }
  }

  static Future<String?> getUserId() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    if(kDebugMode){
      print('User ID fetched: ${sp.getString(userId)}');
    }
    return sp.getString(userId);
  }

  static Future<String?> getEmail() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    if(kDebugMode){
      print('Email fetched: ${sp.getString(userEmail)}');
    }
    return sp.getString(userEmail);
  }
  static Future<bool?> getIsLoggedIn() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    if(kDebugMode){
      print('Is Logged In fetched: ${sp.getBool(isLoggedIn)}');
    }
    return sp.getBool(isLoggedIn);
  }

  static Future<void> clearUserData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
  }

}