import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/models/user_model.dart';
import 'package:todo_app/utils/global_variable.dart';
import 'package:todo_app/utils/utils.dart';
import 'package:todo_app/view_models/services/shared_prefs.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;
  RxBool isLoading = true.obs;
  Rxn<User> user = Rxn<User>();

  // var userName = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    isLoading.value = true;
    await GlobalVariable.init();
    bool loggedIn = await SharedPrefs.getIsLoggedIn() ?? false;
    if (loggedIn && auth.currentUser != null) {
      Get.offAllNamed('/homeScreen');
    } else {
      await SharedPrefs.clearUserData();
      Get.offAllNamed('/onboarding');
    }
    isLoading.value = false;
  }

  Future<void> register(String email, String password, String userName, String phoneNumber) async {
    try {
      isLoading.value = true;

      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('User Data at: $userCredential');

      if (userCredential.user != null) {

        final userModel = UserModel(
          uid: userCredential.user!.uid,
          email: userCredential.user!.email,
          userName: userName,
          phoneNumber: phoneNumber,
        );

        try{
          await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(userModel.toMap());
          print('userModel Data stored successfully');
        }catch(e){
          print('Error storing userModel data: $e');
        }
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
      print('User Data at login: $userData');
      if (userData != null) {
        String uid = userData.uid;

        DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
        if(userDoc.exists){
          print('value in userDoc: ${userDoc.data()}');

          UserModel user = UserModel.fromMap(userDoc.data()!);
        
          await SharedPrefs.saveUserData(user);

          print('User Data saved in login: ');
          print('User ID: ${await SharedPrefs.getUserId()}');
          print('Email: ${await SharedPrefs.getEmail()}'); 
          print('User Name: ${await SharedPrefs.getUsername()}');
          print('Phone Number: ${await SharedPrefs.getPhoneNumber()}');

        }else{
          print('User document does not exist');
          return;
        }
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


  // void loadUsername() async{
  //   userName.value = await SharedPrefs.getUsername() ?? '';
  //   print('userName fetched in loadUsername() : $userName');
  // }

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
