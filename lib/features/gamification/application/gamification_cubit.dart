import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/application/request_status.dart';
import '../domain/achievement.dart';
import '../domain/gamification_repository.dart';
import '../domain/user_level_snapshot.dart';

class GamificationState {
  const GamificationState({
    required this.status,
    this.snapshot,
    this.achievements = const <Achievement>[],
    this.errorMessage,
  });

  final RequestStatus status;
  final UserLevelSnapshot? snapshot;
  final List<Achievement> achievements;
  final String? errorMessage;
}

class GamificationCubit extends Cubit<GamificationState> {
  GamificationCubit(this._repository)
    : super(const GamificationState(status: RequestStatus.idle));

  final GamificationRepository _repository;

  Future<void> load() async {
    emit(const GamificationState(status: RequestStatus.loading));
    try {
      final snap = await _repository.getLevelSnapshot();
      final list = await _repository.listAchievements();
      emit(
        GamificationState(
          status: RequestStatus.success,
          snapshot: snap,
          achievements: list,
        ),
      );
    } on Object catch (_) {
      emit(
        const GamificationState(
          status: RequestStatus.failure,
          errorMessage: 'Не удалось загрузить данные',
        ),
      );
    }
  }
}
