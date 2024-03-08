import 'package:street_vendors/src/features/authentication/views/signup/signup.dart';

import '../features/authentication/views/forgot_password/forgot_password.dart';
import '../features/authentication/views/login/login.dart';
import '../features/authentication/views/signup/success_verification.dart';
import '../features/authentication/views/signup/verify_email.dart';

class Routes{
  static final routes = {
    '/login': (context) => const LoginScreen(),
    '/signup': (context) => const SignupScreen(),
    '/verify-email': (context) => const VerifyEmailScreen(),
/*    '/success-verification': (context) => const SuccessVerificationScreen(),*/
    '/forgot-password': (context) => const ForgotPasswordScreen(),
  };
}