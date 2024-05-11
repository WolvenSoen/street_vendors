import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/helpers/helpers.dart';
import '../../../../utils/validators/validators.dart';
import '../../controllers/forgotpassword/forgot_password_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final dark = Helpers.isDarkMode(context);

    final controller = Get.put(ForgotPasswordController());

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: controller.forgotPasswordFormKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Forgot Password',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Enter your email address and we will send you a link to your E-mail to reset your password',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextFormField(
                      controller: controller.verifEmail,
                      validator: (value) =>
                          Validators.emailValidator(value),
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      controller.forgotPassword();
                    },
                    child: const Text('Send Email'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
