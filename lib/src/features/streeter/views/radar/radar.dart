import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:street_vendors/src/features/streeter/controllers/radar_controller.dart';

import '../../../../utils/helpers/helpers.dart';
import '../../../profile/controllers/user_controller.dart';

class RadarScreen extends StatelessWidget {
  const RadarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final radarController = Get.put(RadarController());
    final dark = Helpers.isDarkMode(context);
    final userController = Get.put(UserController());

    const LatLng _center = LatLng(45.521563, -122.677433);

    return Scaffold(
        body: Obx (
              () => GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              radarController.mapController.complete(controller);
            },
          initialCameraPosition: CameraPosition(
            target: radarController.currentPosition.value,
            zoom: 11.0,
          ), markers: {
            Marker(
              markerId: MarkerId('1'),
              position: radarController.currentPosition.value,
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
              infoWindow: InfoWindow(
                title: 'Wolven',
                snippet: 'just me',
              ),
            ),
            Marker(
              markerId: MarkerId('2'),
              position: LatLng(45.524563, -122.674433),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
              infoWindow: InfoWindow(
                title: 'Clazy',
                snippet: 'Accesorios y Joyería',
              ),
            ),
          },
              ),
        ));
  }
}
