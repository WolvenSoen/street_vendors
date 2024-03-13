import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:street_vendors/src/features/streeter/controllers/radar_controller.dart';

import '../../../../utils/constants/colors.dart';
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

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text('Bienvenido ${userController.user.value.firstName}! ', style: TextStyle(fontSize: 25),),
          centerTitle: true,
          backgroundColor: dark ? Colors.black : Colors.white,
        ),
        body: GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            radarController.mapController.complete(controller);
          },
          initialCameraPosition: CameraPosition(
            target: radarController.currentPosition.value,
            zoom: 11.0,
          ),
          markers: Set<Marker>.of(radarController.markers),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        floatingActionButton: userController.user.value.isVendor
            ? Padding(
                padding: const EdgeInsets.all(20.0),
                child: FloatingActionButton(
                    onPressed: () {
                      radarController.toggleSelling();
                    },
                    backgroundColor: dark ? Colors.black : Colors.white,
                    child: Obx(
                      ()=> Icon(
                        radarController.sellingStatus.value
                            ? Iconsax.shopping_cart5
                            : Iconsax.shopping_cart,
                        color: radarController.sellingStatus.value? AppColors.primaryColor : Colors.grey,
                      ),
                    ),
                  ),
              )
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: FloatingActionButton(
                  onPressed: () {
                    radarController.getVendors();
                  },
                  backgroundColor: dark ? Colors.black : Colors.white,
                  child: const Icon(Icons.settings_input_antenna_rounded,
                      color: AppColors.primaryColor),
                ),
              ),
      ),
    );
  }
}
