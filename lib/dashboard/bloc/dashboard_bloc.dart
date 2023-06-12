import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:case_study_frontend/dashboard/model/user_dto.dart';
import 'package:case_study_frontend/main.dart';
import 'package:equatable/equatable.dart';

part 'dashboard_state.dart';

part 'dashboard_event.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const DashboardState()) {
    on<GetUserRelationStories>(_onGetUserRelationStories);
  }

  final UserRepository _userRepository;

  Future<String?> getUser() async {
    try {
      final user = await _userRepository.getUser();
      return user;
    } catch (_) {
      return null;
    }
  }

  void _onGetUserRelationStories(GetUserRelationStories event, Emitter<DashboardState> emit) {}
}
