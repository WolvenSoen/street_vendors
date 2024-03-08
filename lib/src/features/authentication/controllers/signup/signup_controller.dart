import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/components/fullscreen_loader_screen.dart';
import '../../../../common/components/loaders/loaders.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../data/repositories/user/user_repository.dart';
import '../../../../utils/network/network_manager.dart';
import '../../models/user_model.dart';
import '../../views/signup/verify_email.dart';

class SignupController extends GetxController{
  static SignupController get instance => Get.find();

  // Variables
  final hidePassword = true.obs;
  final email = TextEditingController();
  final password = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phoneNumber = TextEditingController();
  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  void signup() async {
    try{

      // LOADER INIT
      FullScreenLoader.openLoadingDialog('Registrando usuario');

      // INTERNET CONNECTION
      if(!await NetworkManager.instance.isConnected()){
        FullScreenLoader.stopLoading();
        Loaders.errorSnackBar(title: 'Oops!', message: 'No tienes conexión a internet');
        return;
      }

      // VALIDATE FORM
      if(!signUpFormKey.currentState!.validate()){
        FullScreenLoader.stopLoading();
        return;
      }



      // SIGNUP LOGIC
      final userCredential = await AuthenticationRepository.instance.registerWithEmailAndPassword(
        email.text,
        password.text,
      );

      // SAVE ON FIRESTORE
      final savingUser = UserModel(
        id: userCredential.user!.uid,
        email: email.text,
        firstName: firstName.text,
        lastName: lastName.text,
        phoneNumber: phoneNumber.text,
        profilePicture: '',
      );

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUser(savingUser);

      FullScreenLoader.stopLoading();

      // SHOW SUCCESS MESSAGE
      Loaders.successSnackBar(title: '¡Bienvenido!', message: 'Usuario registrado con éxito');

      // MOVE TO VERIFY EMAIL SCREEN
      Get.to(() => const VerifyEmailScreen());

    } catch (e){
      print(e);
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Oops!', message: e.toString());
    }
  }
}