import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/partner_theme.dart';
import 'widgets/partner_app_bar.dart';
import '../features/partner_analytics/presentation/partner_dashboard_page.dart';
import '../features/partner_branches/presentation/partner_branches_page.dart';
import '../features/partner_quality_alerts/presentation/partner_quality_alerts_page.dart';
import '../features/partner_reports/presentation/partner_reports_page.dart';
import 'di.dart';

class PartnerShellPage extends StatefulWidget {
  const PartnerShellPage({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  State<PartnerShellPage> createState() => _PartnerShellPageState();
}

class _PartnerShellPageState extends State<PartnerShellPage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      PartnerDashboardPage(dependencies: widget.dependencies),
      PartnerBranchesPage(dependencies: widget.dependencies),
      const PartnerReportsPage(),
      PartnerQualityAlertsPage(dependencies: widget.dependencies),
    ];
    return Scaffold(
      appBar: const PartnerAppBar(title: 'Партнёрский кабинет'),
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        backgroundColor: AppColors.surface,
        indicatorColor: PartnerTheme.accentLight,
        onDestinationSelected: (v) => setState(() => _index = v),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            label: 'Аналитика',
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            label: 'Филиалы',
          ),
          NavigationDestination(
            icon: Icon(Icons.file_download_outlined),
            label: 'Экспорт',
          ),
          NavigationDestination(
            icon: Icon(Icons.warning_amber_outlined),
            label: 'Алерты',
          ),
        ],
      ),
    );
  }
}
