import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:street_vendors/src/utils/constants/text_strings.dart';
import 'package:street_vendors/src/utils/helpers/helpers.dart';
import 'package:street_vendors/src/utils/theme/text_theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

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
                  Image(image: AssetImage(dark? TextStrings.LogoDarkXL : TextStrings.LogoLightXL), height: 300),
                ],
              ),

              /// Form
              Form(child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      /// Email
                      TextFormField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: 'Correo Electrónico',
                        ),
                      ),
                      const SizedBox(height: 20),
                      /// Password
                      TextFormField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          labelText: 'Contraseña',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text('¿Olvidó su contraseña?'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      /// Login Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
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
                    ]
                  ),
                )
              ),

              /// Divider
              const Row(
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
                    IconButton(onPressed: (){}, icon: Icon(Icons.g_mobiledata_rounded), iconSize: 70),
                  ],
              ),
            ],
          ),
        ),
      )
    );
  }
}

