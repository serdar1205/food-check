import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/application/request_status.dart';
import '../domain/review_history_entry.dart';
import '../domain/review_history_repository.dart';

class ReviewHistoryState {
  const ReviewHistoryState({
    required this.status,
    this.entries = const <ReviewHistoryEntry>[],
    this.errorMessage,
  });

  final RequestStatus status;
  final List<ReviewHistoryEntry> entries;
  final String? errorMessage;

  ReviewHistoryState copyWith({
    RequestStatus? status,
    List<ReviewHistoryEntry>? entries,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return ReviewHistoryState(
      status: status ?? this.status,
      entries: entries ?? this.entries,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
}

class ReviewHistoryCubit extends Cubit<ReviewHistoryState> {
  ReviewHistoryCubit(this._repository)
    : super(const ReviewHistoryState(status: RequestStatus.idle));

  final ReviewHistoryRepository _repository;

  Future<void> load() async {
    emit(
      state.copyWith(status: RequestStatus.loading, clearErrorMessage: true),
    );
    try {
      final list = await _repository.listEntries();
      emit(ReviewHistoryState(status: RequestStatus.success, entries: list));
    } on Object catch (_) {
      emit(
        const ReviewHistoryState(
          status: RequestStatus.failure,
          errorMessage: 'Не удалось загрузить список',
        ),
      );
    }
  }
}
