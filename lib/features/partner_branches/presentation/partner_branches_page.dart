import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/di.dart';
import '../../../core/application/request_status.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/partner_theme.dart';
import '../application/partner_branches_cubit.dart';
import 'partner_branch_details_page.dart';

class PartnerBranchesPage extends StatefulWidget {
  const PartnerBranchesPage({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  State<PartnerBranchesPage> createState() => _PartnerBranchesPageState();
}

class _PartnerBranchesPageState extends State<PartnerBranchesPage> {
  late final PartnerBranchesCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = widget.dependencies.createPartnerBranchesCubit()..load();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PartnerBranchesCubit>.value(
      value: _cubit,
      child: Scaffold(
        body: BlocBuilder<PartnerBranchesCubit, PartnerBranchesState>(
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
                final b = state.items[index];
                return Material(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(PartnerTheme.cardRadius),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        PartnerTheme.cardRadius,
                      ),
                      side: const BorderSide(color: AppColors.borderLight),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: PartnerTheme.accentLight,
                      child: const Icon(
                        Icons.storefront_outlined,
                        color: PartnerTheme.accent,
                      ),
                    ),
                    title: Text(b.name),
                    subtitle: Text(
                      '${b.shortStat} · Рейтинг ${b.rating.toStringAsFixed(1)}',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(
                          builder: (_) => PartnerBranchDetailsPage(
                            dependencies: widget.dependencies,
                            branchId: b.id,
                          ),
                        ),
                      );
                    },
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
