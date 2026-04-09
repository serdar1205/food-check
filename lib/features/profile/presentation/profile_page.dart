import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/di.dart';
import '../../../app/router.dart';
import '../../../core/application/request_status.dart';
import '../../../core/constants/profile_ui_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/profile_screen_colors.dart';
import '../application/profile_cubit.dart';
import 'widgets/profile_bonus_card.dart';
import 'widgets/profile_menu_tile.dart';
import '../../gamification/presentation/gamification_page.dart';
import '../../rewards/presentation/rewards_list_page.dart';
import '../../settings/presentation/settings_page.dart';
import '../../wallet/presentation/bonus_wallet_page.dart';
import 'review_history_page.dart';
import 'widgets/profile_user_identity_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.dependencies, this.profileCubit});

  final AppDependencies dependencies;

  /// When non-null (e.g. from [MainShellPage]), shell owns lifecycle and refresh.
  final ProfileCubit? profileCubit;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ProfileCubit _cubit;
  late final bool _ownsCubit;

  @override
  void initState() {
    super.initState();
    if (widget.profileCubit != null) {
      _cubit = widget.profileCubit!;
      _ownsCubit = false;
    } else {
      _cubit = widget.dependencies.createProfileCubit()..load();
      _ownsCubit = true;
    }
  }

  @override
  void dispose() {
    if (_ownsCubit) {
      _cubit.close();
    }
    super.dispose();
  }

  void _showPlaceholder(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _openSettings() async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => BlocProvider<ProfileCubit>.value(
          value: _cubit,
          child: SettingsPage(dependencies: widget.dependencies),
        ),
      ),
    );
    if (!mounted) {
      return;
    }
    if (changed == true) {
      await _cubit.load();
    }
  }

  Future<void> _logout() async {
    await _cubit.logout();
    if (!mounted) {
      return;
    }
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamedAndRemoveUntil(AppRoutes.auth, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        leading: Navigator.of(context).canPop()
            ? IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                color: ProfileScreenColors.olive,
              )
            : null,
        title: Text(
          'Профиль',
          style: TextStyle(
           // fontFamily: 'serif',
            fontSize: 22,
            fontWeight: FontWeight.w600,
          //  color: ProfileScreenColors.olive,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _openSettings,
            icon: const Icon(Icons.settings_outlined),
            color: ProfileScreenColors.olive,
          ),
        ],
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.status == RequestStatus.loading) {
            return Center(
              child: CircularProgressIndicator(
                color: ProfileScreenColors.bonusYellowDeep,
              ),
            );
          }
          final profile = state.profile;
          if (profile == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Не удалось загрузить профиль',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => context.read<ProfileCubit>().load(),
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              ),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              ProfileUiConstants.horizontalPadding,
              8,
              ProfileUiConstants.horizontalPadding,
              24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProfileUserIdentityCard(profile: profile),
                const SizedBox(height: 16),
                ProfileBonusCard(
                  bonusPoints: profile.bonusBalance,
                  onTap: () {
                    Navigator.of(context).push<void>(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            BonusWalletPage(dependencies: widget.dependencies),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 28),
                Text(
                  'АККАУНТ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: ProfileScreenColors.sectionLabel,
                  ),
                ),
                const SizedBox(height: 12),
                ProfileMenuTile(
                  icon: Icons.card_giftcard_rounded,
                  title: 'Купоны / награды',
                  onTap: () {
                    Navigator.of(context).push<void>(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            RewardsListPage(dependencies: widget.dependencies),
                      ),
                    );
                  },
                ),
                ProfileMenuTile(
                  icon: Icons.history_rounded,
                  title: 'История отзывов',
                  onTap: () {
                    Navigator.of(context).push<void>(
                      MaterialPageRoute<void>(
                        builder: (_) => ReviewHistoryPage(
                          dependencies: widget.dependencies,
                        ),
                      ),
                    );
                  },
                ),
                ProfileMenuTile(
                  icon: Icons.military_tech_outlined,
                  title: 'Уровни / достижения',
                  onTap: () {
                    Navigator.of(context).push<void>(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            GamificationPage(dependencies: widget.dependencies),
                      ),
                    );
                  },
                ),
                ProfileMenuTile(
                  icon: Icons.tune_rounded,
                  title: 'Настройки',
                  onTap: _openSettings,
                ),
                ProfileMenuTile(
                  icon: Icons.help_outline_rounded,
                  title: 'Помощь',
                  onTap: () => _showPlaceholder('Помощь — в разработке'),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: _logout,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout_rounded,
                          color: ProfileScreenColors.logoutRed,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Выйти',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: ProfileScreenColors.logoutRed,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
    if (widget.profileCubit != null) {
      return scaffold;
    }
    return BlocProvider<ProfileCubit>.value(value: _cubit, child: scaffold);
  }
}
