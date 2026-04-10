import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/di.dart';
import '../../../app/widgets/partner_card.dart';
import '../../../core/application/request_status.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/partner_theme.dart';
import '../application/partner_quality_alerts_cubit.dart';

class PartnerQualityAlertsPage extends StatefulWidget {
  const PartnerQualityAlertsPage({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  State<PartnerQualityAlertsPage> createState() =>
      _PartnerQualityAlertsPageState();
}

class _PartnerQualityAlertsPageState extends State<PartnerQualityAlertsPage> {
  late final PartnerQualityAlertsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = widget.dependencies.createPartnerQualityAlertsCubit()..load();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PartnerQualityAlertsCubit>.value(
      value: _cubit,
      child: Scaffold(
        body: BlocBuilder<PartnerQualityAlertsCubit, PartnerQualityAlertsState>(
          builder: (context, state) {
            if (state.status == RequestStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == RequestStatus.failure) {
              return Center(child: Text(state.message ?? 'Ошибка'));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(PartnerTheme.pagePadding),
              itemCount: state.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final a = state.items[index];
                return PartnerCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Icon(
                          Icons.warning_amber_rounded,
                          color: PartnerTheme.warning,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${a.branch} · ${a.criterion}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(a.event),
                            const SizedBox(height: 2),
                            Text(
                              a.dateLabel,
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
