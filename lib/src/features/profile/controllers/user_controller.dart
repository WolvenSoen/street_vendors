import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:street_vendors/src/common/components/loaders/loaders.dart';
import 'package:street_vendors/src/data/repositories/user/user_repository.dart';
import 'package:street_vendors/src/features/authentication/models/user_model.dart';

class UserController extends GetxController{
  static UserController get instance => Get.find();

  Rx<UserModel> user = UserModel.empty().obs;
  final userRepository = Get.put(UserRepository());

  @override
  void onInit() {
    super.onInit();
    fetchUser();
  }

  Future<void> save(UserCredential? userCredentials) async {
    try{

      if(userCredentials != null){

        final lastName = userCredentials.user?.displayName?.split(' ').last ?? '';
        final user = userCredentials.user;

        final userModel = UserModel(
          id: user!.uid,
          firstName: user.displayName ?? '',
          lastName: lastName,
          email: user.email ?? '',
          phoneNumber: user.phoneNumber ?? '',
          profilePicture: user.photoURL ?? '',
        );

        // SAVE USER TO FIRESTORE
        await UserRepository.instance.saveUser(userModel);
      }

    } catch(e){
      Loaders.errorSnackBar(
        title: 'Oops!',
        message: e.toString()
      );
    }
  }


  Future<void> fetchUser() async {
    try{
      final user = await userRepository.fetch();
      this.user(user);
    } catch(e){
      user(UserModel.empty());
      Loaders.errorSnackBar(
        title: 'Oops!',
        message: e.toString()
      );
    }
  }

}