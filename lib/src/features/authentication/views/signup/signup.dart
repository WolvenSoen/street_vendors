import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helpers.dart';
import '../../../../utils/validators/validators.dart';
import '../../controllers/signup/signup_controller.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Helpers.isDarkMode(context);

    final controller = Get.put(SignupController());

    /// SIGNUP SCREEN FORM
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              /// Logo
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                      image: AssetImage(dark
                          ? TextStrings.LogoDarkXL
                          : TextStrings.LogoLightXL),
                      height: 300),
                ],
              ),
              /// Form
              Form(
                  key: controller.signUpFormKey,
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
                                prefixIcon: Icon(Icons.person),
                                labelText: 'Nombre',
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: controller.lastName,
                              validator: (value) => Validators.validateEmptyField(
                                  value, 'Apellido'),
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                labelText: 'Apellido',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      /// Phone Number
                      TextFormField(
                        validator: (value) => Validators.phoneValidator(value),
                        controller: controller.phoneNumber,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.phone),
                          labelText: 'Número de Teléfono',
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// Email
                      TextFormField(
                        validator: (value) => Validators.emailValidator(value),
                        controller: controller.email,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: 'Correo Electrónico',
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// Password
                      Obx(
                        () => TextFormField(
                          validator: (value) =>
                              Validators.passwordValidator(value),
                          controller: controller.password,
                          obscureText: controller.hidePassword.value,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(controller.hidePassword.value
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () => controller.hidePassword.value =
                                  !controller.hidePassword.value,
                            ),
                            labelText: 'Contraseña',
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// Signup Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => controller.signup(),
                          child: const Text('Registrarse'),
                        ),
                      ),

                      /// Login Button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child:
                              const Text('¿Ya tienes una cuenta? Inicia sesión'),
                        ),
                      ),
                    ],
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
