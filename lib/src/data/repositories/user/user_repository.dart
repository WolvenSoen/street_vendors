import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../features/authentication/models/user_model.dart';
import '../authentication/authentication_repository.dart';

class UserRepository extends GetxController{
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;


  Future<void> saveUser(UserModel user) async {
    try {
      await _db.collection('users').doc(user.id).set(user.toJson());
    } on FirebaseException catch (e){
      throw 'Error: $e';
    } on FormatException catch (e){
      throw 'Error: $e';
    } catch (e){
      throw 'Error: $e';
    }
  }

  Future<UserModel> fetch() async {
    try {
      final documentSnapshot = await _db.collection('users').doc(AuthenticationRepository.instance.authUser?.uid).get();

      if(documentSnapshot.exists){
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        return UserModel.empty();
      }

    } on FirebaseException catch (e){
      throw 'Error: $e';
    } on FormatException catch (e){
      throw 'Error: $e';
    } catch (e){
      throw 'Error: $e';
    }
  }

  Future<void> modify(UserModel updatedUser) async{
    try {
      await _db.collection('users').doc(updatedUser.id).update(updatedUser.toJson());
    } on FirebaseException catch (e){
      throw 'Error: $e';
    } on FormatException catch (e){
      throw 'Error: $e';
    } catch (e){
      throw 'Error: $e';
    }
  }

  Future<void> singleModify(Map<String, dynamic> data) async{
    try {
      await _db.collection('users').doc(AuthenticationRepository.instance.authUser?.uid).update(data);
    } on FirebaseException catch (e){
      throw 'Error: $e';
    } on FormatException catch (e){
      throw 'Error: $e';
    } catch (e){
      throw 'Error: $e';
    }
  }

  Future<void> delete(String userId) async{
    try {
      await _db.collection('users').doc(userId).delete();
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