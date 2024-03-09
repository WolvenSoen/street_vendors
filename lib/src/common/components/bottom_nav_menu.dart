import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/profile/views/profile.dart';
import '../../features/streeter/views/radar/radar.dart';
import '../../utils/helpers/helpers.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});



  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    final dark = Helpers.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          backgroundColor: dark ? Colors.black : Colors.white,
          indicatorColor: dark ? Colors.red.withOpacity(1) : Colors.black.withOpacity(0.1),
          onDestinationSelected: (index) => controller.selectedIndex.value = index,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.radar),label: 'Radar',),
            NavigationDestination(icon: Icon(Icons.favorite),label: 'Favorite',),
            NavigationDestination(icon: Icon(Icons.person),label: 'Profile',),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController{
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    Container(
      child: const RadarScreen(),
    ),
    Container(color: Colors.blue),
    Container(
      child: const ProfileScreen(),
    ),
  ];
}
