import 'package:street_vendors/src/features/authentication/views/signup/signup.dart';

import '../features/authentication/views/login/login.dart';

class Routes{
  static final routes = {
    '/login': (context) => const LoginScreen(),
    '/signup': (context) => const SignupScreen(),
  };
}