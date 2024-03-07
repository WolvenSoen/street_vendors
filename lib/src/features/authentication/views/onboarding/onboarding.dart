import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:street_vendors/src/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:street_vendors/src/utils/constants/text_strings.dart';
import 'onboarding_widgets/onboarding_indicator.dart';
import 'onboarding_widgets/onboarding_next.dart';
import 'onboarding_widgets/onboarding_page.dart';
import 'onboarding_widgets/skip_onboarding.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());

    return Scaffold(
        body: Stack(children: [
      PageView(
          controller: controller.pageController,
          onPageChanged: controller.updatePageIndicator,
          children: const [
            OnBoardingPage(
                image: TextStrings.OnboardingImageDark,
                title: 'Welcome to Streeter',
                subtitle: 'Find the best street vendors in your city'),
            OnBoardingPage(
                image: TextStrings.OnboardingImageDark2,
                title: 'Discover',
                subtitle: 'Look through their products and services'),
            OnBoardingPage(
                image: TextStrings.OnboardingImageDark3,
                title: 'Support',
                subtitle: 'Support your local street vendors'),
          ]),
      const SkipOnBoarding(),
      const OnBoardingIndicator(),
      const OnBoardingNext()
    ]));
  }
}
