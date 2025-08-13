import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:todo_app/utils/utils.dart';
import 'package:todo_app/view_models/services/shared_prefs.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  final FirebaseAuth auth = FirebaseAuth.instance;
  RxBool isLoading = true.obs;
  Rxn<User> user = Rxn<User>();

  @override
  void onInit() async {
    super.onInit();
    isLoading.value = true;
    bool loggedIn = await SharedPrefs.getIsLoggedIn() ?? false;
    if (loggedIn && auth.currentUser != null) {
      Get.offAllNamed('/homeScreen');
    } else {
      await SharedPrefs.clearUserData();
      Get.offAllNamed('/onboarding');
    }
    isLoading.value = false;
  }

  // void _authStateChange(User? user){
  //   if(user == null){
  //     Get.offAllNamed('/onboarding');
  //   }else{
  //     Get.offAllNamed('/homeScreen');
  //   }
  // }

  Future<void> register(String email, String password) async {
    try {
      isLoading.value = true;

      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? userData = userCredential.user;
      if (userData != null) {
        await SharedPrefs.saveUserData(userData.uid, userData.email ?? '');
      }
      Get.offAllNamed('/login');
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      Utils.snackBar('Error', 'Failed to register: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;

      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? userData = userCredential.user;
      print('User Data: $userData');
      if (userData != null) {
        await SharedPrefs.saveUserData(userData.uid, userData.email ?? '');
      }
      Get.offAllNamed('/homeScreen');
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      Utils.snackBar('Error', 'Failed to login: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;

      await auth.signOut();
      await SharedPrefs.clearUserData();
      Get.offAllNamed('/onboarding');
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      Utils.snackBar('Error', 'Failed to logout: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future get isLoggedIn async => SharedPrefs.getIsLoggedIn();
}
