import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../../common/components/fullscreen_loader_screen.dart';
import '../../../common/components/loaders/loaders.dart';
import '../../../data/repositories/radar/radar_repository.dart';
import '../../../utils/network/network_manager.dart';
import '../../profile/controllers/user_controller.dart';

class RadarController extends GetxController {
  static RadarController get instance => Get.find();

  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();

  UserController userController = Get.put(UserController());

  final Location location = Location();

  RxBool isSelling = false.obs;

  RxList<Marker> markers = <Marker>[].obs;

  Rx<LatLng> currentPosition = const LatLng(23.521563, -122.677433).obs;

  RxBool refreshData = true.obs;

  @override
  void onInit() {
    /*getLocationUpdates();*/
    super.onInit();
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;

    PermissionStatus _permissionGranted;

    // CHECK IF LOCATION SERVICE IS AVAILABLE FOR IT TO REQUEST LATER
    _serviceEnabled = await location.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await location.requestService();
    } else {
      return;
    }

    // REQUESTS PERMISSION TO USE LOCATION SERVICE
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    location.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        currentPosition.value =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
        cameraToPosition(currentPosition.value);
      }
    });


  }

  Future<void> cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await mapController.future;
    CameraPosition newCameraPosition = CameraPosition(target: pos, zoom: 18);
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

  void getVendors() async {
    try {

      // LOADER INIT
      FullScreenLoader.openLoadingDialog('');

      // CLEARS MARKERS
      markers.clear();

      // INTERNET CONNECTION
      if (!await NetworkManager.instance.isConnected()) {
        FullScreenLoader.stopLoading();
        Loaders.errorSnackBar(
            title: 'Oops!', message: 'No tienes conexión a internet');
        return;
      }

      final radarRepository = Get.put(RadarRepository());
      final vendors = await radarRepository.getVendors();


      // LOADER STOP
      FullScreenLoader.stopLoading();

      // GET DATA FROM VENDORS LIST TO EXTRACT MARKERS AND ADD TO MAP
      for (var vendor in vendors) {

        //SPLIT GEOPOINT INTO LAT AND LNG
        final lat = vendor['location'].split(',')[0];
        final lng = vendor['location'].split(',')[1];

        markers.add(
          Marker(
            markerId: MarkerId(vendor['id']),
            position: LatLng(double.parse(lat), double.parse(lng)),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed),
            infoWindow: InfoWindow(
              title: vendor['name'],
              snippet: vendor['email'],
            ),
            onTap: () {
              //TRIGER DIALOG WITH VENDOR INFO

              try{
                Loaders.infoSnackBar(
                    title: 'Vendedor',
                    message: 'Nombre: ${vendor['name']} \nEmail: ${vendor['email']}');
              } catch(e){

                Loaders.errorSnackBar(title: 'Oops!', message: e.toString());
              }


            },
          ),
        );
      }


    } catch (e) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Oops!', message: e.toString());
    }
  }

  void toggleSelling() async{
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

      // TOGGLE VENDOR STATUS
      final radarRepository = Get.put(RadarRepository());
      await radarRepository.toggleVendorStatus(userController.user.value.id!, currentPosition.value);

      isSelling.toggle();

      if(!isSelling.value){
        Loaders.warningSnackBar(
            title: 'Estás vendiendo!', message: 'Ahora aparecerás en el radar de compradores.');
      } else {
        Loaders.infoSnackBar(
            title: 'Ya no estás vendiendo!', message: 'Te ocultarás del radar de compradores.');
      }

      // LOADER STOP
      FullScreenLoader.stopLoading();
    } catch (e) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Oops!', message: e.toString());
    }
  }
}
