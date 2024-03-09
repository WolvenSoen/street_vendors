import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:street_vendors/src/common/components/fullscreen_loader_screen.dart';
import 'package:street_vendors/src/data/repositories/authentication/authentication_repository.dart';

import '../../../../common/components/loaders/loaders.dart';
import '../../../../utils/network/network_manager.dart';
import '../../../profile/controllers/user_controller.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  // Variables
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final userController = Get.put(UserController());


  @override
  void onInit() {
    email.text = localStorage.read('remember_me_email') ?? '';
    password.text = localStorage.read('remember_me_password') ?? '';
    super.onInit();
  }

  Future<void> login() async {
    try {
      // LOADER INIT
      FullScreenLoader.openLoadingDialog('Iniciando sesión');

      // INTERNET CONNECTION
      if (!await NetworkManager.instance.isConnected()) {
        FullScreenLoader.stopLoading();
        Loaders.errorSnackBar(
            title: 'Oops!', message: 'No tienes conexión a internet');
        return;
      }

      // VALIDATE FORM
      if (!loginFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        return;
      }

      // SAVE DATA ON LOCAL STORAGE IF REMEMBER ME IS TRUE
      if (rememberMe.value) {
        localStorage.write('remember_me_email', email.text.trim());
        localStorage.write('remember_me_password', password.text.trim());
      }

      // LOGIN LOGIC
      final userCredentials = await AuthenticationRepository.instance.login(email.text.trim(), password.text.trim());

      // LOADER STOP
      FullScreenLoader.stopLoading();

      // REDIRECT TO HOME
      AuthenticationRepository.instance.screenRedirect();

    } catch (e) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(
          title: 'Oops!', message: 'Ocurrió un error al iniciar sesión');
    }
  }

  Future<void> loginWithGoogle() async{
    try {
      // LOADER INIT
      FullScreenLoader.openLoadingDialog('Iniciando sesión');

      // INTERNET CONNECTION
      if (!await NetworkManager.instance.isConnected()) {
        FullScreenLoader.stopLoading();
        Loaders.errorSnackBar(
            title: 'Oops!', message: 'No tienes conexión a internet');
        return;
      }

      // LOGIN LOGIC
      final userCredentials = await AuthenticationRepository.instance.signInWithGoogle();

      // SAVE USER TO FIRESTORE
      await userController.save(userCredentials);

      // LOADER STOP
      FullScreenLoader.stopLoading();

      // REDIRECT TO HOME
      AuthenticationRepository.instance.screenRedirect();

    } catch (e) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(
          title: 'Oops!', message: 'Ocurrió un error al iniciar sesión');
    }
  }
}
