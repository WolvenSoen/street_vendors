import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/helpers/helpers.dart';
import '../../../controllers/onboarding/onboarding_controller.dart';

class OnBoardingIndicator extends StatelessWidget {
  const OnBoardingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final controller = OnBoardingController.instance;


    return Positioned(
      left: Helpers.getScreenWidth() * 0.40,
      bottom: 50,
      child: SmoothPageIndicator(
        controller: controller.pageController,
        onDotClicked: controller.dotNavigationClick,
        count: 3,
        effect: const ExpandingDotsEffect(
            activeDotColor: AppColors.primaryColor,
            dotHeight: 6,
            dotWidth: 10,
            spacing: 8),
      ),

    );
  }
}
