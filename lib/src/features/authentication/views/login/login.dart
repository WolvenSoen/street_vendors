import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:street_vendors/src/utils/constants/text_strings.dart';
import 'package:street_vendors/src/utils/helpers/helpers.dart';
import 'package:street_vendors/src/utils/validators/validators.dart';

import '../../controllers/login/login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final dark = Helpers.isDarkMode(context);

    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 50),

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
              key: controller.loginFormKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(children: [
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
                          controller: controller.password,
                          validator: (value) => Validators.validateEmptyField(value, 'Contraseña'),
                          obscureText: controller.hidePassword.value,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(controller.hidePassword.value ? Icons.visibility_off : Icons.visibility),
                              onPressed: () {
                                controller.hidePassword.value = !controller.hidePassword.value;
                              },
                            ),
                            labelText: 'Contraseña',
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgot-password');
                          },
                          child: const Text('¿Olvidó su contraseña?'),
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// Remember Me
                      Row(
                        children: [
                          Obx(() => Checkbox(
                              value: controller.rememberMe.value,
                              onChanged: (value) {
                                controller.rememberMe.value = !controller.rememberMe.value;
                              })),
                          const Text('Recordarme'),
                        ],
                      ),

                      /// Login Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => controller.login(),
                          child: const Text('Iniciar sesión'),
                        ),
                      ),

                      /// Register Button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: const Text('¿No tienes una cuenta? Regístrate aquí'),
                        ),
                      ),
                    ]),
                  )
            ),

            /// Divider
            /*const Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text('Ó'),
                ),
                Expanded(child: Divider()),
              ],
            ),

            /// Social Media Buttons
            Column(
              children: [
                IconButton(
                    onPressed: () {
                      controller.loginWithGoogle();
                    },
                    icon: Icon(Icons.g_mobiledata_rounded),
                    iconSize: 70),
              ],
            ),*/
          ],
        ),
      ),
    ));
  }
}
