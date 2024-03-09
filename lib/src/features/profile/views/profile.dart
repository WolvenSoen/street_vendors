import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:street_vendors/src/data/repositories/authentication/authentication_repository.dart';
import 'package:street_vendors/src/utils/constants/text_strings.dart';
import 'package:street_vendors/src/utils/helpers/helpers.dart';

import '../../../utils/constants/colors.dart';
import '../controllers/user_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // USER PROFILE SETTINGS
  @override
  Widget build(BuildContext context) {

    final controller = UserController.instance;
    final authController = AuthenticationRepository.instance;

    final dark = Helpers.isDarkMode(context);

    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          /// HEADER
          children: [
            const SizedBox(height: 40),
            Container(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Obx(() => RichText(
                        text: TextSpan(
                          text: controller.user.value.fullName,
                          style: TextStyle(
                            color: dark? AppColors.light: Colors.black,
                            fontSize: 22,
                          ),
                        ),
                  )),
                  subtitle: Obx(() => RichText(
                        text: TextSpan(
                          text: controller.user.value.email,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      )),
                  leading: Obx(
                    ()=> CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          controller.user.value.profilePicture.isNotEmpty
                              ? NetworkImage(controller.user.value.profilePicture)
                              : const AssetImage(TextStrings.AvatarDark) as ImageProvider,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {

                    },
                    icon: Icon(
                      Icons.edit,
                      color: dark? AppColors.light: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            const Divider(
              color: AppColors.lightGrey,
              thickness: 0.5,
            ),
            const SizedBox(height: 20),
            /// BODY
            /// FOOTER
            // LOGOUT BUTTON
            ElevatedButton(
              onPressed: () {
                authController.logout();
              },
              child: const Text('Cerrar sesión'),
            ),
          ],
        ),
      ),
    ));
  }
}
