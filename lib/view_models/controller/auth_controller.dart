import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:todo_app/utils/utils.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  final FirebaseAuth auth = FirebaseAuth.instance;
  Rxn<User> user = Rxn<User>();

  @override
  void onInit() {
    user.bindStream(auth.authStateChanges());
    super.onInit();
  }

  Future<void> register(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.offAllNamed('/login');
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      Utils.snackBar('Error', 'Failed to register: $e');
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      Get.offAllNamed('/homeScreen');
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      Utils.snackBar('Error', 'Failed to login: $e');
    }
  }

  Future<void> logout() async {
    await auth.signOut();
    Get.offAllNamed('/onboarding');
  }

  bool get isLoggedIn => user.value != null;
}
