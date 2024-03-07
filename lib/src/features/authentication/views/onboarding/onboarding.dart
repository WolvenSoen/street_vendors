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
                title: 'Welcome to Streeter',
                subtitle: 'Find the best street vendors in your city'),
            OnBoardingPage(
                image: dark? TextStrings.OnboardingImageDark2: TextStrings.OnboardingImageLight2,
                title: 'Discover',
                subtitle: 'Look through their products and services'),
            OnBoardingPage(
                image: dark? TextStrings.OnboardingImageDark3 : TextStrings.OnboardingImageLight3,
                title: 'Support',
                subtitle: 'Support your local street vendors'),
          ]),
      const SkipOnBoarding(),
      const OnBoardingIndicator(),
      const OnBoardingNext()
    ]));
  }
}
