import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../features/authentication/models/user_model.dart';
import '../../../features/profile/controllers/user_controller.dart';
import '../../../features/streeter/models/item_model.dart';

class InventoryRepository extends GetxController{
  static InventoryRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  UserController controller = Get.find();


  Future<void> saveItem(ItemModel item) async {
    try {
      // STORE ITEM IN A NEW DOCUMENT ON A LIST OF ITEMS IN THE USER'S INVENTORY
      await _db.collection('users').doc(controller.user.value.id).collection('inventory').add(item.toJson());
    } on FirebaseException catch (e){
      throw 'Error: $e';
    } on FormatException catch (e){
      throw 'Error: $e';
    } catch (e){
      throw 'Error: $e';
    }
  }

  Future<void> updateItem(Map<String, dynamic> item)async{
    try {
      await _db.collection('users').doc(controller.user.value.id).collection('inventory').doc(item['id']).update(item);
    } on FirebaseException catch (e){
      throw 'Error: $e';
    } on FormatException catch (e){
      throw 'Error: $e';
    } catch (e){
      throw 'Error: $e';
    }
  }

  Future<List<ItemModel>> fetchInventory() async {
    try {

      // GET USER'S INVENTORY ITEMS
      final snapshot = await _db.collection('users').doc(controller.user.value.id).collection('inventory').get();
      return snapshot.docs.map((e) => ItemModel.fromSnapshot(e)).toList();

    } on FirebaseException catch (e){
      throw 'Error: $e';
    } on FormatException catch (e){
      throw 'Error: $e';
    } catch (e){
      throw 'Error: $e';
    }
  }

  Future<void> modifyItem(UserModel updatedUser) async{
    try {
      /*await _db.collection('users').doc(updatedUser.id).update(updatedUser.toJson());*/
    } on FirebaseException catch (e){
      throw 'Error: $e';
    } on FormatException catch (e){
      throw 'Error: $e';
    } catch (e){
      throw 'Error: $e';
    }
  }

  Future<void> singleModifyItem(Map<String, dynamic> data) async{
    try {
      /*await _db.collection('users').doc(AuthenticationRepository.instance.authUser?.uid).update(data);*/
    } on FirebaseException catch (e){
      throw 'Error: $e';
    } on FormatException catch (e){
      throw 'Error: $e';
    } catch (e){
      throw 'Error: $e';
    }
  }

  Future<void> deleteItem(String userId) async{
    try {
      /*await _db.collection('inventories').doc(userId).delete();*/
    } on FirebaseException catch (e){
      throw 'Error: $e';
    } on FormatException catch (e){
      throw 'Error: $e';
    } catch (e){
      throw 'Error: $e';
    }
  }

  // UPLOAD PROFILE PICTURE
  Future<String> uploadImage(String path, XFile image) async {
    try {

      final ref = FirebaseStorage.instance.ref(path).child(image.name);
      await ref.putFile(File (image.path));
      final url = await ref.getDownloadURL();

      return url;

    } on FirebaseException catch (e){
      print(e);
      throw 'Error: $e';
    } on FormatException catch (e){
      print(e);
      throw 'Error: $e';
    } catch (e){
      print(e);
      throw 'Error: $e';
    }
  }


}