import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:street_vendors/src/features/authentication/controllers/signup/verify_email_controller.dart';
import 'package:street_vendors/src/utils/constants/colors.dart';

import '../../../../data/repositories/authentication/authentication_repository.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key, this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(VerifyEmailController());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              AuthenticationRepository.instance.logout();
            },
            icon: Icon(Icons.close),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Verify your email',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      email ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Te enviamos un correo de verificación a tu email. Por favor, haz click en el link para verificar tu cuenta y regresa a la app:)',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              // Email verification form
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        controller.checkEmailVerificationStatus();
                      },
                      child: Text('Continuar'),
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        controller.sendEmailVerification();
                      },
                      child: Text('Reenviar correo de verificación'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
