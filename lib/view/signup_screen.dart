import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/res/colors/app_colors.dart';
import 'package:todo_app/res/components/round_button.dart';
import 'package:todo_app/res/routes/routes_name.dart';
import 'package:todo_app/utils/utils.dart';
import 'package:todo_app/view_models/controller/auth_controller.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    // final controller = Get.find<AuthController>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.all(20),
          child: Form(
            key: formKey,
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
                // Align(
                //   alignment: Alignment.centerLeft,
                //   child: Text('Username', style: TextStyle(fontSize: 15)),
                // ),
                // const SizedBox(height: 20),
                // TextFormField(
                //   controller: usernameController,
                //   decoration: Utils.inputDecoration(title: 'eg emmanuelogah'),
                //   validator: (value) {
                //     if (value!.isEmpty) {
                //       return 'Please enter your username';
                //     }
                //   },
                // ),
                // const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Email', style: TextStyle(fontSize: 15)),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: Utils.inputDecoration(
                    title: 'eg emmanuel@gmail.com',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                  },
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Password', style: TextStyle(fontSize: 15)),
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: Utils.inputDecoration(title: '********'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    }
                  },
                ),
                const SizedBox(height: 50),
                RoundButton(
                  loading: false,
                  title: 'Signup',
                  onPress: () {
                    if (formKey.currentState!.validate()) {
                      AuthController.to.register(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );
                    }
                  },
                ),
                const Spacer(),
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
