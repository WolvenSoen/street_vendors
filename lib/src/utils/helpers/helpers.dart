import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Helpers {

  static void showSnackBar(String message){
    ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    ));
  }

  static void showAlert(String title, String message){
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }

  static void navigateToScreen(BuildContext context, Widget screen){
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  static bool isDarkMode(BuildContext context){
    return Theme.of(context).brightness == Brightness.dark;
  }

  static List removeDuplicates(List list){
    return list.toSet().toList();
  }

  static double getScreenHeight(){
    return MediaQuery.of(Get.context!).size.height;
  }

  static double getScreenWidth(){
    return MediaQuery.of(Get.context!).size.width;
  }

}