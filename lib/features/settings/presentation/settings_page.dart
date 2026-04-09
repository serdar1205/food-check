import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/di.dart';
import '../../../app/router.dart';
import '../../../core/application/request_status.dart';
import '../../../core/constants/profile_ui_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/profile_screen_colors.dart';
import '../../profile/application/profile_cubit.dart';
import '../application/settings_cubit.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final TextEditingController _nameController;
  late final SettingsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = widget.dependencies.createSettingsCubit()..load();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cubit.close();
    super.dispose();
  }

  Future<void> _logout(BuildContext context) async {
    await context.read<ProfileCubit>().logout();
    if (!context.mounted) {
      return;
    }
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamedAndRemoveUntil(AppRoutes.auth, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<SettingsCubit, SettingsState>(
        listener: (context, state) {
          if (state.loadStatus == RequestStatus.success &&
              _nameController.text.isEmpty) {
            _nameController.text = state.displayName;
          }
          final saveErr = state.saveErrorMessage;
          if (saveErr != null && state.saveStatus == RequestStatus.failure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(saveErr)));
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.surface,
            appBar: AppBar(
              title: const Text('Настройки'),
              backgroundColor: AppColors.surface,
              foregroundColor: AppColors.textPrimary,
              elevation: 0,
            ),
            body: state.loadStatus == RequestStatus.loading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.authAccentYellow,
                    ),
                  )
                : state.loadStatus == RequestStatus.failure
                ? Center(
                    child: Text(
                      state.errorMessage ?? 'Ошибка',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(
                      ProfileUiConstants.horizontalPadding,
                      16,
                      ProfileUiConstants.horizontalPadding,
                      24,
                    ),
                    children: [
                      Text(
                        'ПРОФИЛЬ',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: ProfileScreenColors.sectionLabel,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Имя',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: context
                            .read<SettingsCubit>()
                            .setDisplayNameDraft,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.email,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: state.saveStatus == RequestStatus.loading
                            ? null
                            : () async {
                                final ok = await context
                                    .read<SettingsCubit>()
                                    .saveDisplayName();
                                if (!context.mounted) {
                                  return;
                                }
                                if (ok) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Имя сохранено'),
                                    ),
                                  );
                                  Navigator.of(context).pop(true);
                                }
                              },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.authAccentYellow,
                          foregroundColor: AppColors.textPrimary,
                        ),
                        child: const Text('Сохранить имя'),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'ПРИЛОЖЕНИЕ',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: ProfileScreenColors.sectionLabel,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        title: const Text('Уведомления'),
                        subtitle: const Text('Скоро'),
                        value: false,
                        onChanged: (_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Настройка уведомлений — в разработке',
                              ),
                            ),
                          );
                        },
                      ),
                      SwitchListTile(
                        title: const Text('Язык: русский'),
                        subtitle: const Text('Другие языки — в разработке'),
                        value: true,
                        onChanged: (_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Смена языка — в разработке'),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      ListTile(
                        leading: Icon(
                          Icons.logout_rounded,
                          color: ProfileScreenColors.logoutRed,
                        ),
                        title: Text(
                          'Выйти',
                          style: TextStyle(
                            color: ProfileScreenColors.logoutRed,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: () => _logout(context),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.delete_outline_rounded,
                          color: Color(0xFFB71C1C),
                        ),
                        title: const Text(
                          'Удалить аккаунт',
                          style: TextStyle(
                            color: Color(0xFFB71C1C),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: () {
                          showDialog<void>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Удалить аккаунт?'),
                              content: const Text(
                                'Это действие в демо-версии недоступно.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('Отмена'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Удаление аккаунта — в разработке',
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('Удалить'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
