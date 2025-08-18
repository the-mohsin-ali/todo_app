import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/res/colors/app_colors.dart';
import 'package:todo_app/res/components/round_button.dart';
import 'package:todo_app/res/routes/routes_name.dart';
import 'package:todo_app/utils/utils.dart';
import 'package:todo_app/view_models/controller/auth_controller.dart';

class SignupScreen extends GetResponsiveWidget<AuthController> {
  SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Create new account',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Username', style: TextStyle(fontSize: 15)),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: controller.usernameController,
                  decoration: Utils.inputDecoration(title: 'eg emmanuelogah'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Email', style: TextStyle(fontSize: 15)),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: controller.emailController,
                  decoration: Utils.inputDecoration(
                    title: 'eg emmanuel@gmail.com',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Password', style: TextStyle(fontSize: 15)),
                ),
                TextFormField(
                  controller: controller.passwordController,
                  obscureText: true,
                  decoration: Utils.inputDecoration(title: '********'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Phone Number', style: TextStyle(fontSize: 15)),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: controller.phoneController,
                  decoration: Utils.inputDecoration(title: 'eg 08012345678'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 50),
                RoundButton(
                  loading: false,
                  title: 'Signup',
                  onPress: () {
                    if (controller.formKey.currentState!.validate()) {
                      controller.register(
                        controller.emailController.text.trim(),
                        controller.passwordController.text.trim(),
                        controller.usernameController.text.trim(),
                        controller.phoneController.text.trim(),
                      );
                    }
                  },
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(fontSize: 15),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.offNamed(RoutesName.login);
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
