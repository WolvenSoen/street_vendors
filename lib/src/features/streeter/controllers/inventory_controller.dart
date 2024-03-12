import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:street_vendors/src/common/components/fullscreen_loader_screen.dart';
import 'package:street_vendors/src/common/components/loaders/loaders.dart';
import 'package:street_vendors/src/features/streeter/models/item_model.dart';

import '../../../data/repositories/inventory/inventory_repository.dart';
import '../../../utils/network/network_manager.dart';

class InventoryController extends GetxController {
  static InventoryController get instance => Get.find();


  // Variables
  final isActive = false.obs;

  //INIT PLACEHOLDER FOR ITEM PICTURES
  final loading = false.obs;
  final itemPictures = <String>[].obs;
  final itemId = ''.obs;
  final itemName = TextEditingController();
  final itemDescription = TextEditingController();
  final itemStock = TextEditingController();
  final itemPrice = TextEditingController();
  GlobalKey<FormState> manageItemFormKey = GlobalKey<FormState>();

  final inventoryRepository = Get.put(InventoryRepository());

  RxList<ItemModel> items = <ItemModel>[].obs;

  @override
  void onInit() {
    getInventory();
    super.onInit();
  }

  void saveItem() async {
    try {
      // LOADER INIT
      FullScreenLoader.openLoadingDialog('');

      // INTERNET CONNECTION
      if (!await NetworkManager.instance.isConnected()) {
        FullScreenLoader.stopLoading();
        Loaders.errorSnackBar(
            title: 'Oops!', message: 'No tienes conexión a internet');
        return;
      }

      // VALIDATE FORM
      if (!manageItemFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        Loaders.errorSnackBar(
            title: 'Oops!', message: 'Por favor, llena todos los campos');
        return;
      }

      // SAVE ITEM LOGIC

      double price = double.tryParse(itemPrice.text) ?? 0.0;
      int stock = int.tryParse(itemStock.text) ?? 0;


      final savingItem = ItemModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          itemName: itemName.text,
          itemPictures: itemPictures.toList(),
          itemDescription: itemDescription.text,
          itemPrice: price,
          itemStock: stock,
          isActive: isActive.value);

      final inventoryRepository = Get.put(InventoryRepository());
      await inventoryRepository.saveItem(savingItem);

      // UPDATE RX VALUES
      itemName.clear();
      itemDescription.clear();
      itemStock.clear();
      itemPrice.clear();
      isActive.value = false;
      itemPictures.value = [];

      // UPDATES THE LIST OF ITEMS
      getInventory();

      // LOADER STOP
      FullScreenLoader.stopLoading();
      Loaders.successSnackBar(
          title: '¡Listo!', message: 'El item se guardó correctamente');

      Get.back();

    } catch (e) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(
          title: 'Oops!', message: e.toString());
    }
  }

  void updateItem() async{
    try {
      // LOADER INIT
      FullScreenLoader.openLoadingDialog('');

      // INTERNET CONNECTION
      if (!await NetworkManager.instance.isConnected()) {
        FullScreenLoader.stopLoading();
        Loaders.errorSnackBar(
            title: 'Oops!', message: 'No tienes conexión a internet');
        return;
      }

      // VALIDATE FORM
      if (!manageItemFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        Loaders.errorSnackBar(
            title: 'Oops!', message: 'Por favor, llena todos los campos');
        return;
      }

      // SAVE ITEM LOGIC

      double price = double.tryParse(itemPrice.text) ?? 0.0;
      int stock = int.tryParse(itemStock.text) ?? 0;

      Map<String, dynamic> savingItem = {
          'id': itemId.value,
          'itemName': itemName.text,
          'itemPictures': itemPictures.toList(),
          'itemDescription': itemDescription.text,
          'itemPrice': price,
          'itemStock': stock,
          'isActive': isActive.value
      };

      final inventoryRepository = Get.put(InventoryRepository());
      await inventoryRepository.updateItem(savingItem);

      // UPDATE RX VALUES
      itemName.clear();
      itemDescription.clear();
      itemStock.clear();
      itemPrice.clear();
      isActive.value = false;
      itemPictures.value = [];

      // LOADER STOP
      FullScreenLoader.stopLoading();
      Loaders.successSnackBar(
          title: '¡Listo!', message: 'El item se actualizó correctamente');

      Get.back();

    } catch (e) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(
          title: 'Oops!', message: e.toString());
    }
  }

  void getInventory() async {
    try {

      loading.value = true;

      final items = await inventoryRepository.fetchInventory();

      this.items.assignAll(items);

    } catch (e) {
      loading.value = false;
      Loaders.errorSnackBar(
          title: 'Oops!',
          message: e.toString()
      );
    } finally{
      loading.value = false;
    }
  }

  void addPicture() async {
    try{
      final image = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 70, maxWidth: 512, maxHeight: 512);
      if(image != null){

        final inventoryRepository = Get.put(InventoryRepository());

        final imageUrl = await inventoryRepository.uploadImage('users/images/items', image);

        itemPictures.add(imageUrl);

        // UPDATE RX VALUES
        itemPictures.refresh();
      }
    } catch (e){
      Loaders.errorSnackBar(
          title: 'Oops!',
          message: e.toString()
      );
    }
  }

}