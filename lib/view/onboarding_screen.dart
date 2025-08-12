import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:todo_app/res/colors/app_colors.dart';
import 'package:todo_app/res/components/round_button.dart';
import 'package:todo_app/res/routes/routes_name.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 50,
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Create tasks  •  Set reminders  •  Track progress',
                    style: TextStyle(fontSize: 15, color: AppColors.subtitle),
                  ),
                ],
              ),
              SizedBox(height: 50),
              Image.asset('images/login-screen.png'),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Get.toNamed(RoutesName.login);
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: AppColors.secondary,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              RoundButton(
                loading: false,
                onPress: () {
                  Get.toNamed(RoutesName.signup);
                },
                title: 'Signup',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
