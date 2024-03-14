import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:street_vendors/src/utils/constants/colors.dart';
import 'package:street_vendors/src/utils/constants/text_strings.dart';

import '../../../common/components/fullscreen_loader_screen.dart';
import '../../../common/components/loaders/loaders.dart';
import '../../../data/repositories/radar/radar_repository.dart';
import '../../../utils/network/network_manager.dart';
import '../../profile/controllers/user_controller.dart';
import '../views/inventory/vendor_inventory.dart';

class RadarController extends GetxController {
  static RadarController get instance => Get.find();

  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();
  UserController userController = Get.put(UserController());
  final Location location = Location();

  RxList<Marker> markers = <Marker>[].obs;
  Rx<LatLng> currentPosition = const LatLng(23.521563, -122.677433).obs;

  RxBool refreshData = true.obs;
  RxBool sellingStatus = false.obs;

  // CUSTOM MARKER ICON
  BitmapDescriptor testIcon = BitmapDescriptor.defaultMarker;

  @override
  void onInit() {
    getLocationUpdates();

    // SET CUSTOM MARKER ICON
    setCustomMarkerIcon();

    // LISTEN TO USER CONTROLLER TO REFRESH DATA TO KNOW IF USER IS SELLING
    ever(userController.user, (_) {
      refreshData.value = !refreshData.value;
      sellingStatus.value = userController.user.value.isSelling;
      getVendors();
    });

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

        final vendorName = vendor['fullName'];
        final vendorPicture = vendor['profilePicture'];
        final vendorPhone = vendor['phoneNumber'];

        markers.add(
          Marker(
            markerId: MarkerId(vendor['id']),
            position: LatLng(double.parse(lat), double.parse(lng)),
            icon: testIcon,
            infoWindow: InfoWindow(
              title: vendorName,
              snippet: 'CATEGORY',
            ),
            onTap: () {
              //TRIGER DIALOG WITH VENDOR INFO
              showDialog(
                context: Get.context!,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: vendorPicture != ''
                              ? NetworkImage(vendorPicture)
                              : AssetImage(TextStrings.AvatarDark) as ImageProvider,
                        ),
                        const SizedBox(height: 10,),
                        Text(vendorName, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20),),
                      ],
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Categoría: [POR DEFINIR]'),
                        const SizedBox(height: 10,),
                        // TAPABLE TEXT TO COPY TO CLIPBOARD VENDOR PHONE
                        InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: vendorPhone));
                            Loaders.infoSnackBar(
                                title: 'Número copiado!',
                                message: 'Puedes pegarlo en tu app de mensajería.');
                          },
                          child: Text(
                            vendorPhone,
                            style: const TextStyle(
                              fontSize: 20,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cerrar'),
                      ),
                      //BUTTON TO REDIRECT TO VENDOR INVENTORY SCREEN
                      ElevatedButton(
                        onPressed: () {
                          //REDIRECT TO VENDOR INVENTORY SCREEN
                          Get.to(() => VendorInventoryScreen(
                              vendorId: vendor['id'], vendorName: vendorName));
                        },
                        child: Text('Ver productos'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      }
    } catch (e) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Oops!', message: e.toString());
    }
  }

  void toggleSelling() async {
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
      sellingStatus.value = !sellingStatus.value;
      await radarRepository.toggleVendorStatus(
          userController.user.value.id!, currentPosition.value);

      getVendors();

      if (sellingStatus.value) {
        Loaders.warningSnackBar(
            title: 'Estás vendiendo!',
            message: 'Ahora aparecerás en el radar de compradores.');
      } else {
        Loaders.infoSnackBar(
            title: 'Ya no estás vendiendo!',
            message: 'Te ocultarás del radar de compradores.');
      }

      // LOADER STOP
      FullScreenLoader.stopLoading();
    } catch (e) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Oops!', message: e.toString());
    }
  }

  Future<Uint8List?> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        ?.buffer
        .asUint8List();
  }

  void setCustomMarkerIcon() async {
    // CHANGE ICON SIZE
    final Uint8List? markerIcon =
        await getBytesFromAsset(TextStrings.testMarker, 75);
    testIcon = BitmapDescriptor.fromBytes(markerIcon!);
  }
}
