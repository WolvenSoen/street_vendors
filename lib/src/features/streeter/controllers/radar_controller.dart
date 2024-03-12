import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';


class RadarController extends GetxController{
  static RadarController get instance => Get.find();

  final Completer<GoogleMapController> mapController = Completer<GoogleMapController>();

  final Location location = Location();

  Rx<LatLng> currentPosition = LatLng(23.521563, -122.677433).obs;

  RxBool refreshData = true.obs;

  @override
  void onInit() {
    getLocationUpdates();
    super.onInit();
  }

  Future<void> getLocationUpdates() async{
    bool _serviceEnabled;

    PermissionStatus _permissionGranted;

    // CHECK IF LOCATION SERVICE IS AVAILABLE FOR IT TO REQUEST LATER
    _serviceEnabled = await location.serviceEnabled();
    if(_serviceEnabled) {
      _serviceEnabled = await location.requestService();
    } else{
      return;
    }

    // REQUESTS PERMISSION TO USE LOCATION SERVICE
    _permissionGranted = await location.hasPermission();
    if(_permissionGranted == PermissionStatus.denied){
      _permissionGranted = await location.requestPermission();
      if(_permissionGranted != PermissionStatus.granted){
        return;
      }
    }

    location.onLocationChanged.listen((LocationData currentLocation) {
      if(currentLocation.latitude != null && currentLocation.longitude != null){
        currentPosition.value = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        cameraToPosition(currentPosition.value);
        refreshData.toggle();
      }
    });

  }

  Future<void> cameraToPosition(LatLng pos) async{
    final GoogleMapController controller = await mapController.future;
    CameraPosition newCameraPosition = CameraPosition(target: pos, zoom: 13);
    await controller.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

}