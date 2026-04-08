import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Splash / onboarding layout: logo, title, tagline, pagination dots.
class SplashContent extends StatelessWidget {
  const SplashContent({super.key});

  /// Logo diameter ≈ 1/4–1/3 of screen width (clamped for small/large devices).
  static double logoDiameterForWidth(double screenWidth) {
    return (screenWidth * 0.28).clamp(120.0, 168.0);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final logoDiameter = logoDiameterForWidth(screenWidth);
    final iconSize = logoDiameter * 0.48;

    final titleStyle = Theme.of(context).textTheme.headlineMedium?.copyWith(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.splashTitle,
      height: 1.2,
    );

    final taglineStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.45,
      color: AppColors.splashSubtitle,
    );

    return ColoredBox(
      color: AppColors.splashBackground,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              _LogoCircle(diameter: logoDiameter, iconSize: iconSize),
              const SizedBox(height: 24),
              Text('FoodCheck', textAlign: TextAlign.center, style: titleStyle),
              const SizedBox(height: 18),
              Text(
                'Проверяйте рестораны, оценивайте\n'
                'сервис и делитесь впечатлениями',
                textAlign: TextAlign.center,
                style: taglineStyle,
              ),
              const Spacer(flex: 3),
              const _OnboardingDots(),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoCircle extends StatelessWidget {
  const _LogoCircle({required this.diameter, required this.iconSize});

  final double diameter;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: const BoxDecoration(
        color: AppColors.brandYellow,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          Icons.campaign_outlined,
          color: Colors.white,
          size: iconSize,
        ),
      ),
    );
  }
}

/// First two dots: brand yellow; third: faded yellow (reference layout).
class _OnboardingDots extends StatelessWidget {
  const _OnboardingDots();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(3, (int index) {
        final Color color = index < 2
            ? AppColors.brandYellow
            : AppColors.onboardingDotFaded;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
        );
      }),
    );
  }
}
