import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/application/request_status.dart';
import '../domain/user_review_summary.dart';
import 'get_user_reviews_use_case.dart';

class UserReviewsListState {
  const UserReviewsListState({
    required this.status,
    this.reviews = const <UserReviewSummary>[],
    this.errorMessage,
  });

  const UserReviewsListState.initial()
    : status = RequestStatus.idle,
      reviews = const <UserReviewSummary>[],
      errorMessage = null;

  final RequestStatus status;
  final List<UserReviewSummary> reviews;
  final String? errorMessage;

  UserReviewsListState copyWith({
    RequestStatus? status,
    List<UserReviewSummary>? reviews,
    String? errorMessage,
    bool clearError = false,
  }) {
    return UserReviewsListState(
      status: status ?? this.status,
      reviews: reviews ?? this.reviews,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class UserReviewsListCubit extends Cubit<UserReviewsListState> {
  UserReviewsListCubit(this._getReviews)
    : super(const UserReviewsListState.initial());

  final GetUserReviewsUseCase _getReviews;

  Future<void> load() async {
    emit(state.copyWith(status: RequestStatus.loading, clearError: true));
    try {
      final list = await _getReviews();
      emit(state.copyWith(status: RequestStatus.success, reviews: list));
    } on Object catch (e) {
      emit(
        state.copyWith(
          status: RequestStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
