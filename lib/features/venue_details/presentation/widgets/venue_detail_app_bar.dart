import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/venue_theme.dart';

class VenueDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  const VenueDetailAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                color: VenueChromeColors.foreground,
                iconSize: 20,
              ),
              Expanded(
                child: Text(
                  'КАРТОЧКА ЗАВЕДЕНИЯ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    color: VenueChromeColors.foreground,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Меню — в разработке')),
                  );
                },
                icon: const Icon(Icons.more_vert_rounded),
                color: VenueChromeColors.foreground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
