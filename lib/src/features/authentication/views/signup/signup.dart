import 'package:flutter/material.dart';

import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helpers.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final dark = Helpers.isDarkMode(context);

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
                  Image(image: AssetImage(dark? TextStrings.LogoDarkXL : TextStrings.LogoLightXL), height: 300),
                ],
              ),

              /// Form
              Form(child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                labelText: 'Nombre',
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
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
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.phone),
                          labelText: 'Número de Teléfono',
                        ),
                      ),
                      const SizedBox(height: 20),
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
                      const SizedBox(height: 20),
                      /// Signup Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/verify-email');
                          },
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
                          child: const Text('¿Ya tienes una cuenta? Inicia sesión'),
                        ),
                      ),
                    ],
                  ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
