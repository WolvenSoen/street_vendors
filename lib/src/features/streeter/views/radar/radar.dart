import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../profile/controllers/user_controller.dart';

class RadarScreen extends StatelessWidget {
  const RadarScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final userController = Get.put(UserController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ListTile(
                title: Text('Nombre'),
                subtitle: Obx(() => Text(userController.user.value.id)),
              ),
            ),
          ],
        ),
      )
    );
  }
}
