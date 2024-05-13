import 'dart:async';
import 'dart:ui' as ui;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:street_vendors/src/data/repositories/favorites/favorites_repository.dart';
import 'package:street_vendors/src/features/streeter/controllers/favorites_controller.dart';
import 'package:street_vendors/src/utils/constants/colors.dart';
import 'package:street_vendors/src/utils/constants/text_strings.dart';

import '../../../common/components/fullscreen_loader_screen.dart';
import '../../../common/components/loaders/loaders.dart';
import '../../../data/repositories/radar/radar_repository.dart';
import '../../../data/repositories/user/user_repository.dart';
import '../../../utils/network/network_manager.dart';
import '../../profile/controllers/user_controller.dart';
import '../views/inventory/vendor_inventory.dart';

class RadarController extends GetxController {
  static RadarController get instance => Get.find();

  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();
  UserController userController = Get.put(UserController());
  FavoritesController favoritesController = Get.put(FavoritesController());
  final Location location = Location();

  RxList<Marker> markers = <Marker>[].obs;
  Rx<LatLng> currentPosition = const LatLng(23.521563, -122.677433).obs;

  RxBool refreshData = true.obs;
  RxBool sellingStatus = false.obs;

  var moveCameraControl = false;

  // CUSTOM MARKER ICON
  BitmapDescriptor testIcon = BitmapDescriptor.defaultMarker;

  // OBX LIST OF FAVORITES
  RxList<dynamic> favorites = <dynamic>[].obs;

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

    // COMPARE PREVIOUS FCFM TOKEN WITH NEW ONE IN CASE OF APP DELETION
    FirebaseMessaging.instance.getToken().then((token) {
      if (userController.user.value.fcmtoken != token) {
        final userRepository = Get.put(UserRepository());

        print('°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°');
        print('TOKEN DIFERENTE: ACTUALIZANDO...');
        print('°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°');

        userRepository.singleModify(
          {'fcmtoken': token},
        );

        // SUBSCRIBE USER TO TOPICS AGAIN
        for (var vendor in favoritesController.favorites) {
          FirebaseMessaging.instance.subscribeToTopic(vendor.vendorId);
          print('SUBSCRIBED TO: ${vendor.vendorId}');
        }
      }
    });

    // GET FAVORITES LIST

    Future.delayed(
      const Duration(milliseconds: 500),
      () => getFavoritesList(),
    );

    super.onInit();
  }

  Future<void> getFavoritesList() async {
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

      // GET FAVORITES LIST
      final favoritesRepository = Get.put(FavoritesRepository());
      favorites.assignAll(await favoritesRepository.fetchFavorites());

      // LOADER STOP
      FullScreenLoader.stopLoading();
    } catch (e) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Oops!', message: e.toString());
    }
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
    CameraPosition newCameraPosition = CameraPosition(target: pos, zoom: 15);

    // DO THIS JUST ONCE
    if (moveCameraControl == false) {
      controller.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
      moveCameraControl = true;
    }
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

        // GET DATA TO SAVE TO FAVORITES
        final vendorId = vendor['id'];
        final fcmToken = vendor['fcmtoken'];
        final category = vendor['category'];

        markers.add(
          Marker(
            markerId: MarkerId(vendor['id']),
            position: LatLng(double.parse(lat), double.parse(lng)),
            icon: testIcon,
            infoWindow: InfoWindow(
              title: vendorName,
              snippet: category,
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
                        Text(vendorName, textAlign: TextAlign.center, style: const TextStyle(fontSize: 25),),
                        Text(category, style: const TextStyle(fontSize: 15),),
                      ],
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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

                        // BUTTON TO ADD TO FAVORITES (CHANGE TO REMOVE IF ALREADY IN FAVORITES) (DISABLE IF USER IS THE SAME AS VENDOR)
                        Obx(
                              () => ElevatedButton(
                            onPressed: () {
                              if(favorites.any((favorite) => favorite['vendorId'] == vendorId)) {
                                //REMOVE FROM FAVORITES
                                favorites.removeWhere((favorite) => favorite['vendorId'] == vendorId);
                                favoritesController.deleteFavorite(vendorId);
                              } else {
                                //ADD TO FAVORITES
                                favorites.add({
                                  'vendorId': vendorId,
                                  'fcmToken': fcmToken,
                                  'vendorName': vendorName,
                                  'vendorPicture': vendorPicture
                                });
                                addToFavorites(vendorId, fcmToken, vendorName, vendorPicture);
                              }
                            },
                            child: favorites.any((favorite) => favorite['vendorId'] == vendorId) ? const Text('Eliminar de favoritos') : const Text('Añadir a favoritos'),
                          ),
                        )
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

  void addToFavorites(String vendorId, String fcmToken, String vendorName, String vendorPic) async{
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

      // CODE TO ADD TO FAVORITES
      final favoritesRepository = Get.put(FavoritesRepository());
      await favoritesRepository.saveFavorite(vendorId, fcmToken, vendorName, vendorPic);

      // CODE TO SUBSCRIBE TO VENDOR AS A TOPIC IN FIREBASE MESSAGING SERVICE
      await FirebaseMessaging.instance.subscribeToTopic(vendorId);

      // LOADER STOP
      FullScreenLoader.stopLoading();
      Loaders.successSnackBar(
          title: 'Añadido a favoritos!',
          message: 'Puedes ver tus vendedores favoritos en tu perfil.');
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

      final vendorName = userController.user.value.firstName;

      if (sellingStatus.value) {
        //  CODE TO SEND NOTIFICATION TO ALL USERS THAT ARE SUBSCRIBED TO THE TOPIC
        final favoritesRepository = Get.put(FavoritesRepository());
        await favoritesRepository.sendFcmNotification(userController.user.value.id, '¡$vendorName está vendiendo ahora!', '¡Ven a ver los productos que tiene para ti!');

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
