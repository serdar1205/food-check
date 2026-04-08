import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/di.dart';
import '../../../app/router.dart';
import '../../../core/application/request_status.dart';
import '../../../core/constants/auth_ui_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../application/auth_cubit.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final TapGestureRecognizer _termsTapRecognizer;

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _termsTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Условия использования — в разработке')),
        );
      };
  }

  @override
  void dispose() {
    _termsTapRecognizer.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  InputBorder _inputBorder({Color? color, double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AuthUiConstants.inputRadius),
      borderSide: BorderSide(
        color: color ?? AppColors.borderLight,
        width: width,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = TextStyle(
      fontSize: AuthUiConstants.labelSize,
      color: AppColors.textSecondary,
      fontWeight: FontWeight.w500,
    );

    final hintStyle = TextStyle(
      color: AppColors.textSecondary.withValues(alpha: 0.75),
      fontSize: 16,
    );

    return BlocProvider(
      create: (_) => widget.dependencies.createAuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listenWhen: (previous, current) =>
            current.status == RequestStatus.success,
        listener: (context, state) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.main);
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.splashBackground,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AuthUiConstants.paddingH,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    const _AuthBranding(),
                    const SizedBox(height: AuthUiConstants.logoToFormGap),
                    Text(
                      'Авторизация',
                      style: TextStyle(
                        fontSize: AuthUiConstants.sectionTitleSize,
                        fontWeight: FontWeight.bold,
                        color: AppColors.splashTitle,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Войдите в свой аккаунт',
                      style: TextStyle(
                        fontSize: AuthUiConstants.subtitleSize,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('Email', style: labelStyle),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      decoration: InputDecoration(
                        hintText: 'user@example.com',
                        hintStyle: hintStyle,
                        prefixIcon: Icon(
                          Icons.mail_outline_rounded,
                          color: AppColors.textSecondary,
                          size: 22,
                        ),
                        filled: true,
                        fillColor: AppColors.surface,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        border: _inputBorder(),
                        enabledBorder: _inputBorder(),
                        focusedBorder: _inputBorder(
                          color: AppColors.authAccentYellow,
                          width: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: AuthUiConstants.fieldGap),
                    Text('Пароль', style: labelStyle),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _tryLogin(context, state),
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        hintStyle: hintStyle,
                        prefixIcon: Icon(
                          Icons.lock_outline_rounded,
                          color: AppColors.textSecondary,
                          size: 22,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AppColors.textSecondary,
                            size: 22,
                          ),
                        ),
                        filled: true,
                        fillColor: AppColors.surface,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 16,
                        ),
                        border: _inputBorder(),
                        enabledBorder: _inputBorder(),
                        focusedBorder: _inputBorder(
                          color: AppColors.authAccentYellow,
                          width: 1.5,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Восстановление пароля — в разработке',
                              ),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.authAccentYellow,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          textStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: const Text('Забыли пароль?'),
                      ),
                    ),
                    const SizedBox(height: AuthUiConstants.buttonTopMargin - 8),
                    SizedBox(
                      height: AuthUiConstants.buttonHeight,
                      child: FilledButton(
                        onPressed: state.status == RequestStatus.loading
                            ? null
                            : () => _tryLogin(context, state),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.authAccentYellow,
                          foregroundColor: AppColors.splashTitle,
                          disabledBackgroundColor: AppColors.authAccentYellow
                              .withValues(alpha: 0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AuthUiConstants.buttonRadius,
                            ),
                          ),
                          elevation: 0,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: state.status == RequestStatus.loading
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: AppColors.splashTitle.withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                              )
                            : const Text('Войти'),
                      ),
                    ),
                    if (state.message != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        state.message!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 14,
                        ),
                      ),
                    ],
                    const SizedBox(
                      height: AuthUiConstants.dividerVerticalMargin,
                    ),
                    const _OrDivider(),
                    const SizedBox(
                      height: AuthUiConstants.dividerVerticalMargin,
                    ),
                    SizedBox(
                      height: AuthUiConstants.buttonHeight,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Регистрация — в разработке'),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.splashTitle,
                          side: const BorderSide(color: AppColors.borderLight),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AuthUiConstants.buttonRadius,
                            ),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        icon: Icon(
                          Icons.person_add_outlined,
                          color: AppColors.splashTitle,
                          size: 22,
                        ),
                        label: const Text('Создать аккаунт'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: AuthUiConstants.footerTopPadding,
                        bottom: 24,
                      ),
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.4,
                            color: AppColors.textSecondary,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Продолжая, вы соглашаетесь с ',
                            ),
                            TextSpan(
                              text: 'условиями использования',
                              style: const TextStyle(
                                color: AppColors.authAccentYellow,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: _termsTapRecognizer,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _tryLogin(BuildContext context, AuthState state) {
    if (state.status == RequestStatus.loading) {
      return;
    }
    context.read<AuthCubit>().login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
  }
}

class _AuthBranding extends StatelessWidget {
  const _AuthBranding();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: AuthUiConstants.logoDiameter,
          height: AuthUiConstants.logoDiameter,
          decoration: const BoxDecoration(
            color: AppColors.authAccentYellow,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.campaign_outlined,
            color: AppColors.splashTitle,
            size: AuthUiConstants.logoDiameter * 0.45,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'FoodCheck',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AuthUiConstants.foodCheckTitleSize,
            fontWeight: FontWeight.bold,
            color: AppColors.splashTitle,
          ),
        ),
      ],
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    final lineColor = AppColors.borderLight;
    return Row(
      children: [
        Expanded(child: Divider(height: 1, thickness: 1, color: lineColor)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'или',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Divider(height: 1, thickness: 1, color: lineColor)),
      ],
    );
  }
}
