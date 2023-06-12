import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:case_study_frontend/dashboard/model/user_dto.dart';
import 'package:case_study_frontend/dashboard/repository/userstory_repository.dart';
import 'package:case_study_frontend/main.dart';
import 'package:equatable/equatable.dart';

part 'dashboard_state.dart';

part 'dashboard_event.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc({
    required UserRepository userRepository,
    required UserStoryRepository userStoryRepository,
  })  : _userRepository = userRepository,
        _userStoryRepository = userStoryRepository,
        super(const DashboardState()) {
    on<GetUserRelationStories>(_onGetUserRelationStories);
  }

  final UserRepository _userRepository;
  final UserStoryRepository _userStoryRepository;

  Future<String?> getUser() async {
    try {
      final user = await _userRepository.getUser();
      return user;
    } catch (_) {
      return null;
    }
  }

  void _onGetUserRelationStories(GetUserRelationStories event, Emitter<DashboardState> emit) async {
    emit(state.copyWith(applicationState: ApplicationState.loading));
    var userId = await getUser();
    if (userId != null) {
      final result = await _userStoryRepository.getUsersRequested(userId);
      var filteredList = result.where((item) => item.story != null);

      emit(state.copyWith(applicationState: ApplicationState.loaded, userRelations: result, numberOfStories: filteredList.length));
    } else {
      emit(state.copyWith(applicationState: ApplicationState.error));
    }
  }
}
