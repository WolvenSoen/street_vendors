import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:street_vendors/src/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:street_vendors/src/utils/constants/text_strings.dart';
import 'package:street_vendors/src/utils/helpers/helpers.dart';
import 'onboarding_widgets/onboarding_indicator.dart';
import 'onboarding_widgets/onboarding_next.dart';
import 'onboarding_widgets/onboarding_page.dart';
import 'onboarding_widgets/skip_onboarding.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());

    final dark = Helpers.isDarkMode(context);

    return Scaffold(
        body: Stack(children: [
      PageView(
          controller: controller.pageController,
          onPageChanged: controller.updatePageIndicator,
          children: [
            OnBoardingPage(
                image: dark? TextStrings.OnboardingImageDark : TextStrings.OnboardingImageLight,
                title: 'Bienvenido a Streeter!',
                subtitle: 'Encuentra a tus vendedores locales'),
            OnBoardingPage(
                image: dark? TextStrings.OnboardingImageDark2: TextStrings.OnboardingImageLight2,
                title: 'Descubre',
                subtitle: 'Mira los productos que ofrecen'),
            OnBoardingPage(
                image: dark? TextStrings.OnboardingImageDark3 : TextStrings.OnboardingImageLight3,
                title: 'Apoya',
                subtitle: 'Compra y apoya a los vendedores locales'),
          ]),
      const SkipOnBoarding(),
      const OnBoardingIndicator(),
      const OnBoardingNext()
    ]));
  }
}
