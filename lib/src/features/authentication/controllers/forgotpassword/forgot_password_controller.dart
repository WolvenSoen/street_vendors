import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/network/network_manager.dart';
import '../../../../common/components/fullscreen_loader_screen.dart';
import '../../../../common/components/loaders/loaders.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../views/login/login.dart';

class ForgotPasswordController extends GetxController{
  static ForgotPasswordController get instance => Get.find();

  final verifEmail = TextEditingController();
  GlobalKey<FormState> forgotPasswordFormKey = GlobalKey<FormState>();

  void forgotPassword() async{
    try{
      // LOADER INIT
      FullScreenLoader.openLoadingDialog('Enviando correo de recuperación');

      // INTERNET CONNECTION
      if(!await NetworkManager.instance.isConnected()){
        FullScreenLoader.stopLoading();
        Loaders.errorSnackBar(title: 'Oops!', message: 'No tienes conexión a internet');
        return;
      }

      // VALIDATE FORM
      if(!forgotPasswordFormKey.currentState!.validate()){
        FullScreenLoader.stopLoading();
        return;
      }

      // FORGOT PASSWORD LOGIC
      await AuthenticationRepository.instance.forgotPassword(verifEmail.text);

      // SUCCESS
      FullScreenLoader.stopLoading();
      Loaders.successSnackBar(title: 'Listo!', message: 'Correo de recuperación enviado');

      // REDIRECTO TO LOGIN
      Get.offAll(() => const LoginScreen());

    }catch(e){
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Oops!', message: 'Algo salió mal');
    }
  }


}