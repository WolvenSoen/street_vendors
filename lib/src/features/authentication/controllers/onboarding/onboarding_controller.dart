import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:street_vendors/src/features/authentication/views/login/login.dart';

class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();

  final deviceStorage = GetStorage();
  final pageController = PageController();
  final currentPageIndex = 0.obs;

  void updatePageIndicator(index) => currentPageIndex.value = index;

  void dotNavigationClick(index) {
    currentPageIndex.value = index;
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  void nextPage() {
    if (currentPageIndex.value == 2) {
      final storage = GetStorage();

      storage.write('onboarding', false);

      Get.offAll(const LoginScreen());
    } else{
      currentPageIndex.value++;
      pageController.animateToPage(currentPageIndex.value,
          duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
    }
  }

  void skipPage() {
    currentPageIndex.value = 2;
    pageController.animateToPage(2,
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
  }
}
