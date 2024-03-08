import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:street_vendors/src/utils/constants/colors.dart';
import 'package:street_vendors/src/utils/helpers/helpers.dart';

class FullScreenLoader {
  static openLoadingDialog(String text) {
    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Container(
          color: Helpers.isDarkMode(Get.context!) ? Colors.black : Colors.white,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 250),
              const CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
              const SizedBox(height: 20),
              Text(
                text,
                style: TextStyle(
                  color: Helpers.isDarkMode(Get.context!) ? Colors.white : Colors.black,
                  fontSize: 18,
                ),
              ),
            ],
          )
        )
      )
    );
  }

  static stopLoading(){
    Navigator.pop(Get.overlayContext!);
  }
}
