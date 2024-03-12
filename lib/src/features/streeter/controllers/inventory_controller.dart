import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
  final itemPictures = <String>[].obs;
  final itemId = ''.obs;
  final itemName = TextEditingController();
  final itemDescription = TextEditingController();
  final itemStock = TextEditingController();
  final itemPrice = TextEditingController();
  GlobalKey<FormState> manageItemFormKey = GlobalKey<FormState>();

  RxBool refreshData = true.obs;

  final inventoryRepository = Get.put(InventoryRepository());

  RxList<ItemModel> items = <ItemModel>[].obs;

  @override
  void onInit() {
    /*getInventory();*/
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
      refreshData.toggle();
      resetFormFieldValues();

      // LOADER STOP
      FullScreenLoader.stopLoading();
      Loaders.successSnackBar(
          title: '¡Listo!', message: 'El item se guardó correctamente');

      Navigator.of(Get.context!).pop();

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

      // EDIT ITEM LOGIC

      double price = double.tryParse(itemPrice.text) ?? 0.0;
      int stock = int.tryParse(itemStock.text) ?? 0;

      print(itemId.value);

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
      resetFormFieldValues();
      refreshData.toggle();

      // LOADER STOP
      FullScreenLoader.stopLoading();
      Loaders.successSnackBar(
          title: '¡Listo!', message: 'El item se actualizó correctamente');

      Navigator.of(Get.context!).pop();

    } catch (e) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(
          title: 'Oops!', message: e.toString());
    }
  }

  Future<List<ItemModel>> getInventory() async {
    try {
      final items = await inventoryRepository.fetchInventory();

      this.items.value = items;

      return items;

    } catch (e) {
      Loaders.errorSnackBar(
          title: 'Oops!',
          message: e.toString()
      );
      return [];
    }
  }

  void deleteItem() async{
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

      inventoryRepository.deleteItem(itemId.value);
      refreshData.toggle();

      // LOADER STOP
      FullScreenLoader.stopLoading();

      Loaders.successSnackBar(
          title: '¡Listo!',
          message: 'El item se eliminó correctamente'
      );

      Navigator.of(Get.context!).pop();

    } catch (e){
      Loaders.errorSnackBar(
          title: 'Oops!',
          message: e.toString()
      );
    }
  }

  void removePicture(int index) async{
    try{
      itemPictures.removeAt(index);
    } catch (e){
      Loaders.errorSnackBar(
          title: 'Oops!',
          message: e.toString()
      );
    }
  }

  void addPicture() async {
    try{
      final image = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 70, maxWidth: 512, maxHeight: 512);
      if(image != null){

        final inventoryRepository = Get.put(InventoryRepository());

        final imageUrl = await inventoryRepository.uploadImage('users/images/items', image);

        itemPictures.add(imageUrl);
      }
    } catch (e){
      Loaders.errorSnackBar(
          title: 'Oops!',
          message: e.toString()
      );
    }
  }

  resetFormFieldValues(){
    itemName.clear();
    itemDescription.clear();
    itemStock.clear();
    itemPrice.clear();
    isActive.value = false;
    itemPictures.value = [];
    manageItemFormKey.currentState?.reset();
  }

}