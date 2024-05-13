import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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

      // Refresh user
      await fetchUser();

      if(user.value.id.isEmpty){
        if(userCredentials != null){

          final lastName = userCredentials.user?.displayName?.split(' ').last ?? '';
          final user = userCredentials.user;

          // GET FCM TOKEN
          final fcmToken = await FirebaseMessaging.instance.getToken();

          final userModel = UserModel(
            id: user!.uid,
            fullName: user.displayName ?? '',
            firstName: user.displayName ?? '',
            lastName: lastName,
            isVendor: false,
            email: user.email ?? '',
            phoneNumber: user.phoneNumber ?? '',
            profilePicture: user.photoURL ?? '',
            fcmtoken: fcmToken ?? '',
            isSelling: false,
            bio: '',
            category: 'Otros',
          );

          // SAVE USER TO FIRESTORE
          await UserRepository.instance.saveUser(userModel);
        }
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

  Future<void> uploadUserProfilePicture() async{

    try{
      // CONTROL TO NOT OPEN IMAGE PICKER IF TAPED TOO MANY TIMES

      final image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70, maxWidth: 512, maxHeight: 512);

      if(image != null){

        final imageUrl = await userRepository.uploadImage('users/images/profile', image);

        Map<String, dynamic> data = {
          'profilePicture': imageUrl,
        };

        await userRepository.singleModify(data);

        // UPDATE RX VALUES
        user.update((val) {
          val!.profilePicture = imageUrl;
        });

        Loaders.successSnackBar(title: 'Listo!', message: 'Foto de perfil actualizada correctamente');
      }
    } catch (e){
      Loaders.errorSnackBar(
        title: 'Oops!',
        message: e.toString()
      );
    }


  }


}