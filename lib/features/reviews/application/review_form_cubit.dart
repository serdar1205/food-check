import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/application/request_status.dart';
import '../../restaurants/domain/restaurant.dart';
import '../domain/review_draft.dart';

class ReviewFormState {
  const ReviewFormState({
    required this.status,
    required this.overallRating,
    required this.foodQuality,
    required this.service,
    required this.atmosphere,
    required this.priceQuality,
    this.comment = '',
    this.message,
  });

  factory ReviewFormState.fromRestaurant(Restaurant restaurant) {
    final overall = restaurant.rating.round().clamp(
      ReviewDraft.minOverall,
      ReviewDraft.maxOverall,
    );
    return ReviewFormState(
      status: RequestStatus.idle,
      overallRating: overall,
      foodQuality: restaurant.foodQualityScore,
      service: restaurant.serviceScore,
      atmosphere: restaurant.atmosphereScore,
      priceQuality: restaurant.priceQualityScore,
    );
  }

  final RequestStatus status;
  final int overallRating;
  final int foodQuality;
  final int service;
  final int atmosphere;
  final int priceQuality;
  final String comment;
  final String? message;

  ReviewFormState copyWith({
    RequestStatus? status,
    int? overallRating,
    int? foodQuality,
    int? service,
    int? atmosphere,
    int? priceQuality,
    String? comment,
    String? message,
  }) {
    return ReviewFormState(
      status: status ?? this.status,
      overallRating: overallRating ?? this.overallRating,
      foodQuality: foodQuality ?? this.foodQuality,
      service: service ?? this.service,
      atmosphere: atmosphere ?? this.atmosphere,
      priceQuality: priceQuality ?? this.priceQuality,
      comment: comment ?? this.comment,
      message: message ?? this.message,
    );
  }

  ReviewDraft toDraft(String restaurantId, String restaurantName) =>
      ReviewDraft(
        restaurantId: restaurantId,
        restaurantName: restaurantName,
        overallRating: overallRating,
        foodQuality: foodQuality,
        service: service,
        atmosphere: atmosphere,
        priceQuality: priceQuality,
        comment: comment.isEmpty ? null : comment,
      );
}

class ReviewFormCubit extends Cubit<ReviewFormState> {
  ReviewFormCubit(super.initialState);

  factory ReviewFormCubit.fromRestaurant(Restaurant restaurant) {
    return ReviewFormCubit(ReviewFormState.fromRestaurant(restaurant));
  }

  void setOverallRating(int value) {
    final v = value.clamp(ReviewDraft.minOverall, ReviewDraft.maxOverall);
    emit(state.copyWith(overallRating: v));
  }

  void setFoodQuality(int value) {
    emit(state.copyWith(foodQuality: _clamp10(value)));
  }

  void setService(int value) {
    emit(state.copyWith(service: _clamp10(value)));
  }

  void setAtmosphere(int value) {
    emit(state.copyWith(atmosphere: _clamp10(value)));
  }

  void setPriceQuality(int value) {
    emit(state.copyWith(priceQuality: _clamp10(value)));
  }

  void setComment(String value) {
    emit(state.copyWith(comment: value));
  }

  static int _clamp10(int value) =>
      value.clamp(ReviewDraft.minCriterion, ReviewDraft.maxCriterion);
}
