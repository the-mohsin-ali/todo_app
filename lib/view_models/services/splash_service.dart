import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:todo_app/utils/global_variable.dart';
import 'package:todo_app/view_models/controller/auth_controller.dart';
import 'package:todo_app/view_models/services/shared_prefs.dart';

class SplashService {
  void isLogin() async {
    final authController = Get.find<AuthController>();

    authController.isLoading.value = true;

    bool loggedIn = await SharedPrefs.getIsLoggedIn() ?? false;
    User? currentUser = FirebaseAuth.instance.currentUser;

    await Future.delayed(Duration(seconds: 3));

    if (loggedIn && currentUser != null) {
      await GlobalVariable.init();
      Get.offAllNamed('/homeScreen');
    } else {
      await SharedPrefs.clearUserData();
      Get.offAllNamed('/onboarding');
    }

    authController.isLoading.value = false;
  }
}
