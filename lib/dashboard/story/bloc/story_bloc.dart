import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:case_study_frontend/constants/application_state.dart';
import 'package:case_study_frontend/constants/flutter_contstants.dart';
import 'package:case_study_frontend/dashboard/model/story_detail_dto.dart';
import 'package:case_study_frontend/dashboard/repository/userstory_repository.dart';
import 'package:equatable/equatable.dart';

part 'story_event.dart';

part 'story_state.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  StoryBloc({
    required UserStoryRepository userStoryRepository,
  })  : _userStoryRepository = userStoryRepository,
        _controllerList = [],
        super(const StoryState()) {
    on<GetStoryDetailRequested>(_onGetStoryDetailRequested);
    on<GetProgressBarNewValue>(_onGetProgressBarNewValue);
    on<NextStoryRequested>(_onNextStoryRequested);
    on<StopStoryRequested>(_onStopStoryRequested);
    on<ContinueStoryRequested>(_onContinueStoryRequested);
  }

  final UserStoryRepository _userStoryRepository;
  final List<bool> _controllerList;

  void _onGetStoryDetailRequested(GetStoryDetailRequested event, Emitter<StoryState> emit) async {
    final result = await _userStoryRepository.getStoryDetail(event.storyId);

    for (int i = 0; i < result!.storyDetail!.length; i++) {
      bool prValue = false;
      _controllerList.add(prValue);
    }

    emit(state.copyWith(
      applicationState: ApplicationState.loaded,
      storyDetail: result.storyDetail,
      progressBarList: _controllerList,
      startFrom: result.startFrom,
      currentIndex: 0,
    ));
  }

  void _onGetProgressBarNewValue(GetProgressBarNewValue event, Emitter<StoryState> emit) async {
    _controllerList[event.index] = true;

    emit(state.copyWith(
      applicationState: ApplicationState.loaded,
      progressBarList: _controllerList,
      loaderState: LoaderState.ready,
    ));
  }

  void _onStopStoryRequested(StopStoryRequested event, Emitter<StoryState> emit) async {
    log('loader state changed');
    emit(state.copyWith(
      loaderState: LoaderState.stop,
    ));
  }

  void _onContinueStoryRequested(ContinueStoryRequested event, Emitter<StoryState> emit) async {
    log('loader state changed');
    emit(state.copyWith(
      loaderState: LoaderState.cont,
    ));
  }

  void _onNextStoryRequested(NextStoryRequested event, Emitter<StoryState> emit) async {
    _controllerList[event.index] = false;
    emit(state.copyWith(
      loaderState: LoaderState.idle,
    ));
    if (_controllerList.length == event.index + 1) {
      log('STORY KAPANACAK');
      emit(state.copyWith(
        progressBarList: _controllerList,
        loaderState: LoaderState.close,
      ));
    } else {
      _controllerList[event.index + 1] = true;
      emit(state.copyWith(
        progressBarList: _controllerList,
        loaderState: LoaderState.next,
        currentIndex: event.index + 1,
      ));
    }
  }
}
