import 'package:get/get.dart';
import 'package:todo_app/view/bottom_tab.dart';
import 'package:todo_app/view/login_screen.dart';
import 'package:todo_app/view/onboarding_screen.dart';
import 'package:todo_app/view/signup_screen.dart';
import 'package:todo_app/view/splash_screen.dart';
import 'package:todo_app/view_models/bindings/task_controller_binding.dart';

class AppRoutes {
  static List<GetPage> appRoutes() => [
    GetPage(
      name: '/',
      page: () => const SplashScreen(),
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade,
    ),
    GetPage(
      name: '/onboarding',
      page: () => const OnboardingScreen(),
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade,
    ),
    GetPage(
      name: '/login',
      page: () => const LoginScreen(),
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade,
    ),
    GetPage(
      name: '/signup',
      page: () =>  SignupScreen(),
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade,
    ),
    GetPage(
      name: '/homeScreen',
      binding: TaskControllerBinding(),
      page: () => const BottomTab(),
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade,
    ),
  ];
}
