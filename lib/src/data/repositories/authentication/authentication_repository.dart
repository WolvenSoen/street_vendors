import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:street_vendors/src/common/components/loaders/loaders.dart';
import 'package:street_vendors/src/features/authentication/views/login/login.dart';
import 'package:street_vendors/src/features/authentication/views/onboarding/onboarding.dart';

class AuthenticationRepository extends GetxController{
  static AuthenticationRepository get instance => Get.find();

  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

  @override
  void onReady(){
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  screenRedirect() async{
    deviceStorage.writeIfNull('onboarding', true);
    deviceStorage.read('onboarding') != true ? Get.offAll(() => const LoginScreen()) : Get.offAll(() => const OnBoardingScreen());
  }


  /// EMAIL & PASSWORD SIGN-IN

  Future<UserCredential> registerWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e){
      return Loaders.errorSnackBar(title: 'Oops!', message: e.message ?? 'Error');
    } on FirebaseException catch (e){
      return Loaders.errorSnackBar(title: 'Oops!', message: e.message ?? 'Error');
    } on FormatException catch (e){
      return Loaders.errorSnackBar(title: 'Oops!', message: e.message ?? 'Error');
    } catch (e) {
      throw 'Error: $e';
    }
  }
}