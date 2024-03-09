import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:street_vendors/src/data/repositories/user/user_repository.dart';
import 'package:street_vendors/src/features/profile/controllers/user_controller.dart';
import 'package:street_vendors/src/features/profile/views/profile.dart';

import '../../../common/components/fullscreen_loader_screen.dart';
import '../../../common/components/loaders/loaders.dart';
import '../../../utils/network/network_manager.dart';

class EditProfileController extends GetxController {
  static EditProfileController get instance => Get.find();

  final hidePassword = true.obs;
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phoneNumber = TextEditingController();
  final profilePicture = ''.obs;
  GlobalKey<FormState> editProfileFormKey = GlobalKey<FormState>();

  final userRepository = Get.put(UserRepository());

  @override
  void onInit() {
    super.onInit();
    // FILL FORM WITH USER DATA
    firstName.text = UserController.instance.user.value.firstName;
    lastName.text = UserController.instance.user.value.lastName;
    phoneNumber.text = UserController.instance.user.value.phoneNumber;
  }

  void updateProfile() async{

    try{
      // LOADER INIT
      FullScreenLoader.openLoadingDialog('');

      // INTERNET CONNECTION
      if(!await NetworkManager.instance.isConnected()){
        FullScreenLoader.stopLoading();
        Loaders.errorSnackBar(title: 'Oops!', message: 'No tienes conexión a internet');
        return;
      }

      // VALIDATE FORM
      if(!editProfileFormKey.currentState!.validate()){
        FullScreenLoader.stopLoading();
        return;
      }

      // UPDATE PROFILE LOGIC
      Map<String, dynamic> updatedData = {
        'firstName': firstName.text.trim(),
        'lastName': lastName.text.trim(),
        'fullName': '${firstName.text.trim()} ${lastName.text.trim()}',
        'phoneNumber': phoneNumber.text.trim(),
      };
      await userRepository.singleModify(updatedData);

      // UPDATE RX VALUES
      UserController.instance.user.update((val) {
        val!.firstName = firstName.text.trim();
        val.lastName = lastName.text.trim();
        val.fullName = '${firstName.text.trim()} ${lastName.text.trim()}';
        val.phoneNumber = phoneNumber.text.trim();
      });

      FullScreenLoader.stopLoading();

      // SHOW SUCCESS MESSAGE
      Loaders.successSnackBar(title: 'Listo!', message: 'Datos actualizados correctamente');

      // GO BACK
      Get.off(const ProfileScreen());
    } catch (e){
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Oops!', message: e.toString());
    }


  }
}