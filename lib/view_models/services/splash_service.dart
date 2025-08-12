import 'dart:async';

import 'package:get/get.dart';
import 'package:todo_app/res/routes/routes_name.dart';

class SplashService {
  void isLogin() {
    Timer(const Duration(seconds: 3), () => Get.toNamed(RoutesName.onboarding));
  }
}
