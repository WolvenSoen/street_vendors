import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../features/profile/controllers/user_controller.dart';
import '../../../features/streeter/controllers/radar_controller.dart';

class RadarRepository extends GetxController {
  static RadarRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  UserController controller = Get.find();

  RadarController radarController = Get.put(RadarController());

  Future<List> getVendors() async {
    try {
      final documentSnapshot = await _db.collection('users').where('isSelling', isEqualTo: true).get();

      return documentSnapshot.docs.map((e) => e.data()).toList();


    } on FirebaseException catch (e){
      throw 'Error: $e';
    } on FormatException catch (e){
      throw 'Error: $e';
    } catch (e){
      throw 'Error: $e';
    }
  }

  Future<void> toggleVendorStatus(String vendorId, LatLng location) async{
    try {
      // TOGGLE VENDOR STATUS
      final user = await _db.collection('users').doc(vendorId).get();
      final isSelling = user['isSelling'];
      await _db.collection('users').doc(vendorId).update({
        'isSelling': !isSelling,
        'location': location.latitude.toString() + ',' + location.longitude.toString()
      });
    } on FirebaseException catch (e){
      throw 'Error: $e';
    } on FormatException catch (e){
      throw 'Error: $e';
    } catch (e){
      throw 'Error: $e';
    }
  }

}