import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/di.dart';
import '../../../app/router.dart';
import '../../reviews/domain/review_draft.dart';
import '../application/receipt_flow_cubit.dart';
import 'receipt_camera_screen.dart';
import 'receipt_error_screen.dart';
import 'receipt_preview_screen.dart';
import 'receipt_processing_screen.dart';

class ReceiptFlowPage extends StatelessWidget {
  const ReceiptFlowPage({
    super.key,
    required this.dependencies,
    required this.draft,
  });

  final AppDependencies dependencies;
  final ReviewDraft draft;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => dependencies.createReceiptFlowCubit(),
      child: BlocListener<ReceiptFlowCubit, ReceiptFlowState>(
        listenWhen: (previous, current) =>
            current.pendingResult != null &&
            previous.pendingResult != current.pendingResult,
        listener: (context, state) {
          final result = state.pendingResult;
          if (result == null) {
            return;
          }
          context.read<ReceiptFlowCubit>().clearPendingResult();
          Navigator.of(
            context,
          ).pushReplacementNamed(AppRoutes.result, arguments: result);
        },
        child: BlocBuilder<ReceiptFlowCubit, ReceiptFlowState>(
          builder: (context, state) {
            switch (state.step) {
              case ReceiptFlowStep.camera:
                return const ReceiptCameraScreen();
              case ReceiptFlowStep.preview:
                final path = state.imagePath;
                if (path == null || path.isEmpty) {
                  return const ReceiptCameraScreen();
                }
                return ReceiptPreviewScreen(draft: draft, imagePath: path);
              case ReceiptFlowStep.processing:
                return const ReceiptProcessingScreen();
              case ReceiptFlowStep.error:
                return const ReceiptErrorScreen();
            }
          },
        ),
      ),
    );
  }
}
