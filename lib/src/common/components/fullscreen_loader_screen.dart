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
          child: const Column(
            children: [
              SizedBox(height: 250),
              CircularProgressIndicator(
                color: AppColors.primaryColor,
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
