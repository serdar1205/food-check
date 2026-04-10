import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class PartnerAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PartnerAppBar({super.key, required this.title});

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
    );
  }
}
