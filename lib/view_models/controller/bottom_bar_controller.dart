import 'package:get/get.dart';

class BottomBarController extends GetxController{
  var selectedIndex = 0.obs;

  void changeTabIndex(int index){
    selectedIndex.value = index;
  }

  void goToHomeTab(){
    selectedIndex.value = 0;
  }
}