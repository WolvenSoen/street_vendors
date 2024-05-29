import 'package:flutter/material.dart';
import 'package:street_vendors/src/features/authentication/controllers/onboarding/onboarding_controller.dart';

class SkipOnBoarding extends StatelessWidget {
  const SkipOnBoarding({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        child: TextButton(onPressed: () {
          OnBoardingController.instance.skipPage();
        }, child: const Text('Omitir')),
        top: 50,
        right: 20);
  }
}
