import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:street_vendors/src/features/authentication/views/signup/success_verification.dart';
import 'package:street_vendors/src/utils/constants/text_strings.dart';

import '../../../../common/components/loaders/loaders.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();

  @override
  void onInit() {
    sendEmailVerification();
    setTimerForAutoRedirect();
    super.onInit();
  }

  Future<void> sendEmailVerification() async {
    try {
      return await AuthenticationRepository.instance.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      return Loaders.errorSnackBar(
          title: 'Oops!', message: e.message ?? 'Error');
    } on FirebaseException catch (e) {
      return Loaders.errorSnackBar(
          title: 'Oops!', message: e.message ?? 'Error');
    } on FormatException catch (e) {
      return Loaders.errorSnackBar(
          title: 'Oops!', message: e.message ?? 'Error');
    } catch (e) {
      throw 'Error: $e';
    }
  }

  void setTimerForAutoRedirect() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified ?? false) {
        timer.cancel();
        Get.off(() => SuccessVerificationScreen(
              image: TextStrings.OnboardingImageDark3,
              title: '¡Bienvenido!',
              message: 'Tu correo ha sido verificado',
              onPressed: () {
                AuthenticationRepository.instance.screenRedirect();
              },
            ));
      }
    });
  }

  // Manually check if Email Verified
  checkEmailVerificationStatus() async{
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.emailVerified){
      Get.off(() => SuccessVerificationScreen(
        image: 'assets/images/verified_email.png',
        title: '¡Listo!',
        message: 'Tu correo ha sido verificado',
        onPressed: () {
          AuthenticationRepository.instance.screenRedirect();
        },
      ));
    }
}
}
