import 'package:flutter/material.dart';

import '../../core/theme/partner_theme.dart';

class PartnerCard extends StatelessWidget {
  const PartnerCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(12),
      decoration: PartnerTheme.cardDecoration(),
      child: child,
    );
  }
}
