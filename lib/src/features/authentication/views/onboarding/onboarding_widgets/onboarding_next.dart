import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:street_vendors/src/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:street_vendors/src/utils/helpers/helpers.dart';

class OnBoardingNext extends StatelessWidget {
  const OnBoardingNext({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Helpers.isDarkMode(context);

    return Positioned(
        bottom: 30,
        right: 20,
        child: ElevatedButton(
          onPressed: () {
            OnBoardingController.instance.nextPage();
          },
          style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: dark ? Colors.white : Colors.black),
          child: const Icon(Iconsax.arrow_right_3),
        ));
  }
}
