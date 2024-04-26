import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../features/profile/controllers/user_controller.dart';

class FavoritesRepository extends GetxController {
  static FavoritesRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  UserController controller = Get.find();

  Future<void> saveFavorite(String vendorId, String fcmToken) async {
    try {
      // STORE ITEM IN A NEW DOCUMENT ON A LIST OF ITEMS IN THE USER'S FAVORITES
      await _db.collection('users').doc(controller.user.value.id).collection('favorites').doc(vendorId).set({
        'vendorId': vendorId,
        'fcmtoken': fcmToken,
      });
    } on FirebaseException catch (e){
      throw 'Error: $e';
    } on FormatException catch (e){
      throw 'Error: $e';
    } catch (e){
      throw 'Error: $e';
    }
  }

  Future<http.Response> sendFcmNotification(
      String topic, String title, String body) async {
    final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    final token = "AAAAnMYMmfc:APA91bGtSaCV9RMN-INGmfGoAsVchiu7HkrPpj_HLAVJMfIRUtMhsypOE5C3UiBAnVpZ00A37Ka81n9cSfY7nDN5LVjieWYW469wAeWh9WVCGfIv0LHb-Qi_Gmo9sh56g3pUF3CrjMYM";

    // Ensure token is retrieved before proceeding
    if (token == null || token.isEmpty) {
      throw Exception('Failed to retrieve Bearer token');
    }

    final data = jsonEncode({
      'to': '/topics/$topic', // Replace with your actual topic
      'notification': {
        'title': title,
        'body': body,
      },
    });

    final response = await http.post(
      url,
      body: data,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return response;
  }


  Future<void> deleteItem(String vendorId) async{
    try {
      await _db.collection('users').doc(controller.user.value.id).collection('favorites').doc(vendorId).delete();
    } on FirebaseException catch (e){
      throw 'Error: $e';
    } on FormatException catch (e){
      throw 'Error: $e';
    } catch (e){
      print(e);
      throw 'Error: $e';
    }
  }
}