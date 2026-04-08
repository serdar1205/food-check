import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/di.dart';
import '../../../app/router.dart';
import '../../../core/application/request_status.dart';
import '../../../core/theme/app_colors.dart';
import '../application/splash_cubit.dart';
import '../application/splash_destination.dart';
import 'splash_content.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final SplashCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = widget.dependencies.createSplashCubit()..initialize();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashCubit>.value(
      value: _cubit,
      child: BlocListener<SplashCubit, SplashState>(
        listenWhen: (previous, current) =>
            current.status == RequestStatus.success &&
            current.destination != null,
        listener: (context, state) {
          final destination = state.destination;
          if (destination == null) {
            return;
          }
          final route = destination == SplashDestination.authorized
              ? AppRoutes.main
              : AppRoutes.auth;
          Navigator.of(context).pushReplacementNamed(route);
        },
        child: Scaffold(
          backgroundColor: AppColors.splashBackground,
          body: Stack(
            fit: StackFit.expand,
            children: [
              const SplashContent(),
              BlocBuilder<SplashCubit, SplashState>(
                buildWhen: (previous, current) =>
                    previous.status != current.status,
                builder: (context, state) {
                  if (state.status != RequestStatus.loading) {
                    return const SizedBox.shrink();
                  }
                  return const Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 56),
                      child: SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: AppColors.brandYellow,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
