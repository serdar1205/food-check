import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/di.dart';
import '../../../app/widgets/partner_card.dart';
import '../../../core/application/request_status.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/partner_theme.dart';
import '../application/partner_dashboard_cubit.dart';
import 'widgets/partner_metric_card.dart';

class PartnerDashboardPage extends StatefulWidget {
  const PartnerDashboardPage({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  State<PartnerDashboardPage> createState() => _PartnerDashboardPageState();
}

class _PartnerDashboardPageState extends State<PartnerDashboardPage> {
  late final PartnerDashboardCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = widget.dependencies.createPartnerDashboardCubit()..load();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PartnerDashboardCubit>.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.splashBackground,
        body: BlocBuilder<PartnerDashboardCubit, PartnerDashboardState>(
          builder: (context, state) {
            if (state.status == RequestStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == RequestStatus.failure) {
              return Center(child: Text(state.message ?? 'Ошибка'));
            }
            final s = state.snapshot;
            if (s == null) {
              return const SizedBox.shrink();
            }
            return ListView(
              padding: const EdgeInsets.all(PartnerTheme.pagePadding),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFF2C6), Color(0xFFFFD86B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Text(
                    'Сводка по сети\nпоследние 30 дней',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.splashTitle,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                PartnerMetricCard(
                  title: 'Общие показатели',
                  value: '${s.totalReviews} отзывов',
                  icon: Icons.rate_review_outlined,
                ),
                const SizedBox(height: 12),
                PartnerMetricCard(
                  title: 'Средняя оценка',
                  value: s.averageRating.toStringAsFixed(1),
                  icon: Icons.star_outline_rounded,
                ),
                const SizedBox(height: 12),
                PartnerMetricCard(
                  title: 'Динамика',
                  value:
                      '${s.dynamicChangePercent > 0 ? '+' : ''}${s.dynamicChangePercent.toStringAsFixed(1)}%',
                  icon: Icons.trending_up_rounded,
                ),
                const SizedBox(height: 12),
                PartnerMetricCard(
                  title: 'KPI',
                  value: s.kpiSummary,
                  icon: Icons.insights_outlined,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 120,
                  child: PartnerCard(
                    child: Center(
                      child: Text(
                        'График динамики (demo)',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
