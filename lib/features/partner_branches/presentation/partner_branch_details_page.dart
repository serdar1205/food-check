import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/di.dart';
import '../../../app/widgets/fake_line_chart.dart';
import '../../../core/application/request_status.dart';
import '../../../core/theme/partner_theme.dart';
import '../application/partner_branch_details_cubit.dart';

class PartnerBranchDetailsPage extends StatefulWidget {
  const PartnerBranchDetailsPage({
    super.key,
    required this.dependencies,
    required this.branchId,
  });

  final AppDependencies dependencies;
  final String branchId;

  @override
  State<PartnerBranchDetailsPage> createState() =>
      _PartnerBranchDetailsPageState();
}

class _PartnerBranchDetailsPageState extends State<PartnerBranchDetailsPage> {
  late final PartnerBranchDetailsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = widget.dependencies.createPartnerBranchDetailsCubit()
      ..load(widget.branchId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PartnerBranchDetailsCubit>.value(
      value: _cubit,
      child: Scaffold(
        body: BlocBuilder<PartnerBranchDetailsCubit, PartnerBranchDetailsState>(
          builder: (context, state) {
            if (state.status == RequestStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == RequestStatus.failure) {
              return Center(child: Text(state.message ?? 'Ошибка'));
            }
            final d = state.details;
            if (d == null) {
              return const SizedBox.shrink();
            }
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  d.branchName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              body: ListView(
                padding: const EdgeInsets.all(PartnerTheme.pagePadding),
                children: [
                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('7 дней'),
                        selected: state.period == '7d',
                        onSelected: (_) => context
                            .read<PartnerBranchDetailsCubit>()
                            .setPeriod('7d'),
                      ),
                      ChoiceChip(
                        label: const Text('30 дней'),
                        selected: state.period == '30d',
                        onSelected: (_) => context
                            .read<PartnerBranchDetailsCubit>()
                            .setPeriod('30d'),
                      ),
                      ChoiceChip(
                        label: const Text('90 дней'),
                        selected: state.period == '90d',
                        onSelected: (_) => context
                            .read<PartnerBranchDetailsCubit>()
                            .setPeriod('90d'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: PartnerTheme.cardDecoration(),
                    child: Column(
                      children: [
                        _ScoreTile(label: 'Еда', value: d.food),
                        _ScoreTile(label: 'Сервис', value: d.service),
                        _ScoreTile(label: 'Чистота', value: d.cleanliness),
                        _ScoreTile(label: 'Персонал', value: d.staff),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 120,
                    decoration: PartnerTheme.cardDecoration(),
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: FakeLineChart(
                        points: [7.2, 7.6, 7.4, 7.8, 7.7, 8.0, 8.1],
                        xLabels: ['D1', 'D2', 'D3', 'D4', 'D5', 'D6', 'D7'],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Отзывы по филиалу',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  ...d.reviews.map(
                    (r) => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(r),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ScoreTile extends StatelessWidget {
  const _ScoreTile({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(label),
      trailing: Text(
        '$value/10',
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}
