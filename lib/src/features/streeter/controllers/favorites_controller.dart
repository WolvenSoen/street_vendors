import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:street_vendors/src/common/components/fullscreen_loader_screen.dart';
import 'package:street_vendors/src/data/repositories/user/user_repository.dart';
import 'package:street_vendors/src/features/streeter/controllers/radar_controller.dart';

import '../../../common/components/loaders/loaders.dart';
import '../../../data/repositories/favorites/favorites_repository.dart';
import '../../../utils/network/network_manager.dart';
import '../../authentication/models/user_model.dart';

class FavoritesController extends GetxController{
  static FavoritesController get instance => Get.find();

  // LIST FOR FAVORITES ITEMS
  RxList favorites = [].obs;

  RxBool refreshData = true.obs;

  final favoritesRepository = Get.put(FavoritesRepository());

  final userRepository = Get.put(UserRepository());

  var userData = UserModel.empty();

  @override
  void onInit() {
    super.onInit();
  }

  Future<List> getFavorites() async {
    try {
      final favorites = await favoritesRepository.fetchFavorites();

      this.favorites.value = favorites;

      return favorites;
    } catch (e) {
      Loaders.errorSnackBar(
          title: 'Oops!',
          message: e.toString()
      );
      return [];
    }
  }

  void deleteFavorite(String vendorId) async{
    try{

      // LOADER INIT
      FullScreenLoader.openLoadingDialog('');

      // INTERNET CONNECTION
      if (!await NetworkManager.instance.isConnected()) {
        FullScreenLoader.stopLoading();
        Loaders.errorSnackBar(
            title: 'Oops!', message: 'No tienes conexión a internet');
        return;
      }

      // CODE TO SUBSCRIBE TO VENDOR AS A TOPIC IN FIREBASE MESSAGING SERVICE
      await FirebaseMessaging.instance.unsubscribeFromTopic(vendorId);

      favoritesRepository.deleteFavorite(vendorId);

      refreshData.toggle();

      // LOADER STOP
      FullScreenLoader.stopLoading();

      Loaders.successSnackBar(
          title: '¡Listo!',
          message: 'El vendedor se eliminó de tu lista de favoritos:('
      );

    } catch (e){
      Loaders.errorSnackBar(
          title: 'Oops!',
          message: e.toString()
      );
    }
  }

}