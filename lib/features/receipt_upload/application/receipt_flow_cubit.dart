import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/errors/app_failures.dart';
import '../platform/receipt_file_exists.dart';
import '../../review_result/domain/review_result.dart';
import '../../reviews/domain/review_draft.dart';
import 'submit_review_with_receipt_use_case.dart';

enum ReceiptFlowStep { camera, preview, processing, error }

class ReceiptFlowState {
  const ReceiptFlowState({
    required this.step,
    this.imagePath,
    this.flashLabel = 'AUTO',
    this.pendingResult,
    this.errorTitle,
    this.errorDescription,
    this.isDuplicateReceipt = false,
    this.pickErrorMessage,
  });

  final ReceiptFlowStep step;
  final String? imagePath;
  final String flashLabel;
  final ReviewResultEntity? pendingResult;
  final String? errorTitle;
  final String? errorDescription;
  final bool isDuplicateReceipt;

  /// One-shot message when gallery/camera fails (shown as SnackBar on camera screen).
  final String? pickErrorMessage;

  ReceiptFlowState copyWith({
    ReceiptFlowStep? step,
    String? imagePath,
    bool clearImagePath = false,
    String? flashLabel,
    ReviewResultEntity? pendingResult,
    bool clearPendingResult = false,
    String? errorTitle,
    String? errorDescription,
    bool? isDuplicateReceipt,
    bool clearError = false,
    String? pickErrorMessage,
    bool clearPickError = false,
  }) {
    return ReceiptFlowState(
      step: step ?? this.step,
      imagePath: clearImagePath ? null : (imagePath ?? this.imagePath),
      flashLabel: flashLabel ?? this.flashLabel,
      pendingResult: clearPendingResult
          ? null
          : (pendingResult ?? this.pendingResult),
      errorTitle: clearError ? null : (errorTitle ?? this.errorTitle),
      errorDescription: clearError
          ? null
          : (errorDescription ?? this.errorDescription),
      isDuplicateReceipt: isDuplicateReceipt ?? this.isDuplicateReceipt,
      pickErrorMessage: clearPickError
          ? null
          : (pickErrorMessage ?? this.pickErrorMessage),
    );
  }
}

class ReceiptFlowCubit extends Cubit<ReceiptFlowState> {
  ReceiptFlowCubit(this._submitReview)
    : super(const ReceiptFlowState(step: ReceiptFlowStep.camera));

  final SubmitReviewWithReceiptUseCase _submitReview;
  final ImagePicker _picker = ImagePicker();

  static const List<String> _flashLabels = <String>['AUTO', 'OFF', 'ON'];
  int _flashIndex = 0;

  void cycleFlash() {
    _flashIndex = (_flashIndex + 1) % _flashLabels.length;
    emit(state.copyWith(flashLabel: _flashLabels[_flashIndex]));
  }

  Future<void> pickFromGallery() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (file == null) {
        return;
      }
      emit(
        state.copyWith(
          step: ReceiptFlowStep.preview,
          imagePath: file.path,
          clearError: true,
          clearPickError: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          pickErrorMessage:
              'Не удалось открыть галерею. Проверьте доступ к файлам.',
        ),
      );
    }
  }

  Future<void> captureWithCamera() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (file == null) {
        return;
      }
      emit(
        state.copyWith(
          step: ReceiptFlowStep.preview,
          imagePath: file.path,
          clearError: true,
          clearPickError: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          pickErrorMessage:
              'Не удалось открыть камеру. Попробуйте галерею или проверьте разрешения.',
        ),
      );
    }
  }

  void clearPickError() {
    emit(state.copyWith(clearPickError: true));
  }

  /// Empty string if [raw] is not a readable file path (avoids fake paths).
  Future<String> _existingFilePathOrEmpty(String raw) async {
    if (raw.isEmpty) {
      return '';
    }
    if (kIsWeb || raw.startsWith('http')) {
      return raw;
    }
    return receiptFileExistsSync(raw) ? raw : '';
  }

  void retake() {
    emit(
      ReceiptFlowState(
        step: ReceiptFlowStep.camera,
        flashLabel: state.flashLabel,
      ),
    );
  }

  void retryFromError() {
    emit(
      ReceiptFlowState(
        step: ReceiptFlowStep.camera,
        flashLabel: state.flashLabel,
      ),
    );
  }

  Future<void> submitReview(ReviewDraft draft) async {
    final raw = state.imagePath ?? '';
    final path = await _existingFilePathOrEmpty(raw);
    emit(state.copyWith(step: ReceiptFlowStep.processing, clearError: true));
    final result = await _submitReview(draft, path);
    result.when(
      success: (ReviewResultEntity value) {
        emit(
          state.copyWith(
            step: ReceiptFlowStep.processing,
            pendingResult: value,
          ),
        );
      },
      failure: (ReviewFailure error) {
        emit(
          ReceiptFlowState(
            step: ReceiptFlowStep.error,
            imagePath: state.imagePath,
            flashLabel: state.flashLabel,
            errorTitle: _errorTitle(error),
            errorDescription: _errorDescription(error),
            isDuplicateReceipt: error == ReviewFailure.receiptAlreadyUsed,
          ),
        );
      },
    );
  }

  void clearPendingResult() {
    emit(state.copyWith(clearPendingResult: true));
  }

  String _errorTitle(ReviewFailure error) {
    switch (error) {
      case ReviewFailure.receiptAlreadyUsed:
        return 'Чек уже использован';
      case ReviewFailure.invalidDraft:
        return 'Неполный отзыв';
      case ReviewFailure.uploadFailed:
        return 'Ошибка загрузки';
      case ReviewFailure.unknown:
        return 'Ошибка';
    }
  }

  String _errorDescription(ReviewFailure error) {
    switch (error) {
      case ReviewFailure.receiptAlreadyUsed:
        return 'К сожалению, этот чек был загружен ранее. Если вы считаете, '
            'что это ошибка, обратитесь в поддержку.';
      case ReviewFailure.invalidDraft:
        return 'Заполните все поля оценки перед отправкой чека.';
      case ReviewFailure.uploadFailed:
        return 'Не удалось загрузить файл. Проверьте соединение и попробуйте снова.';
      case ReviewFailure.unknown:
        return 'Произошла непредвиденная ошибка. Попробуйте позже.';
    }
  }
}
