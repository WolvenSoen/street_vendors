import 'package:flutter/cupertino.dart';

import '../../../../../utils/helpers/helpers.dart';
import '../../../../../utils/theme/text_theme.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  final String image, title, subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image(
            width: Helpers.getScreenWidth(),
            height: Helpers.getScreenHeight() * 0.8,
            image: AssetImage(image)),
        SizedBox(
            height: 50,
            child: Text(title,
                textAlign: TextAlign.center,
                style: WolvenTextTheme.lightTextTheme.titleLarge)),
        Text(subtitle, textAlign: TextAlign.center),
      ],
    );
  }
}