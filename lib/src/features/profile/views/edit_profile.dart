import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:street_vendors/src/features/profile/controllers/edit_profile_controller.dart';
import 'package:street_vendors/src/utils/constants/text_strings.dart';

import '../../../utils/validators/validators.dart';
import '../controllers/user_controller.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final userController = UserController.instance;
  final controller = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Profile Picture
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    userController.uploadUserProfilePicture();
                  },
                  child: Obx(
                    ()=> CircleAvatar(
                      radius: 100,
                      backgroundImage: userController.user.value.profilePicture.isNotEmpty
                          ? NetworkImage(userController.user.value.profilePicture)
                          : const AssetImage(TextStrings.AvatarDark) as ImageProvider,
                    ),
                  ),
                ),
              ),
            ),
            /// PERSONAL INFO
            Form(
              key: controller.editProfileFormKey,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: controller.firstName,
                            validator: (value) =>
                                Validators.validateEmptyField(value, 'Nombre'),
                            decoration: const InputDecoration(
                              labelText: 'Nombre',
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: TextFormField(
                            validator: (value) => Validators.validateEmptyField(
                                value, 'Apellido'),
                            controller: controller.lastName,
                            decoration: const InputDecoration(
                              labelText: 'Apellido',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: controller.phoneNumber,
                      validator: (value) => Validators.validateEmptyField(
                          value, 'Teléfono'),
                      decoration: const InputDecoration(
                        labelText: 'Teléfono',
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        controller.updateProfile();
                      },
                      child: const Text('Guardar'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
