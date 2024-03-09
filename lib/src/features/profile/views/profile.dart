import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:street_vendors/src/utils/constants/text_strings.dart';

import '../controllers/user_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // USER PROFILE SETTINGS
  @override
  Widget build(BuildContext context) {

    final controller = Get.put(UserController());

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            /// HEADER
            children: [
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Nombre'),
                  subtitle: Text('Nombre de usuario'),
                  leading: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(TextStrings.OnboardingImageDark3),
                  ),
                  trailing: Icon(Icons.edit),
                ),
              ),

            ],
            /// BODY
          ),
        ),
      )
    );
  }
}
