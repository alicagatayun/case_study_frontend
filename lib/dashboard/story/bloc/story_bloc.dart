import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:case_study_frontend/constants/application_state.dart';
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
    on<PreviousStoryRequested>(_onPreviousStoryRequested);
    on<VideoLoaded>(_onVideoLoaded);
    on<VideoLoading>(_onVideoLoading);
  }

  final UserStoryRepository _userStoryRepository;
  final List<bool> _controllerList;

  void _onGetStoryDetailRequested(GetStoryDetailRequested event, Emitter<StoryState> emit) async {
    log('Get Story Detail Requested');

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
      loaderState: LoaderState.ready,
      currentIndex: 0,
    ));
  }

  void _onGetProgressBarNewValue(GetProgressBarNewValue event, Emitter<StoryState> emit) async {
    log('Get Progress New Value Requested');

    _controllerList[state.startFrom] = true;

    emit(state.copyWith(
      applicationState: ApplicationState.loaded,
      progressBarList: _controllerList,
      currentIndex: state.startFrom,
      loaderState: LoaderState.ready,
    ));
  }

  void _onStopStoryRequested(StopStoryRequested event, Emitter<StoryState> emit) async {
    log('Stop Story Requested');
    emit(state.copyWith(
      loaderState: LoaderState.stop,
    ));
  }

  void _onContinueStoryRequested(ContinueStoryRequested event, Emitter<StoryState> emit) async {
    log('Continue Story Requested');
    emit(state.copyWith(
      loaderState: LoaderState.cont,
    ));
  }

  void _onNextStoryRequested(NextStoryRequested event, Emitter<StoryState> emit) async {
    log('Next Story Requested');

    _controllerList[state.currentIndex] = false;
    emit(state.copyWith(
      loaderState: LoaderState.idle,
    ));
    if (_controllerList.length == state.currentIndex + 1) {
      log('STORY KAPANACAK');
      emit(state.copyWith(progressBarList: _controllerList, loaderState: LoaderState.close, currentIndex: 0));
    } else {
      _controllerList[state.currentIndex + 1] = true;
      emit(state.copyWith(
        progressBarList: _controllerList,
        loaderState: LoaderState.next,
        currentIndex: state.currentIndex + 1,
      ));
    }
    //TODO: Replace Id with user Id later.
    _userStoryRepository.updateStoryDetail(state.storyDetail[state.currentIndex].id, "563a77e9-3a2e-4a45-bdcf-01d214c2f86b");
  }

  void _onPreviousStoryRequested(PreviousStoryRequested event, Emitter<StoryState> emit) async {
    log('Previous Story Requested');
    if (_controllerList.length == 1 || state.currentIndex == 0) return;

    _controllerList[state.currentIndex] = false;
    _controllerList[state.currentIndex - 1] = true;
    emit(state.copyWith(
      progressBarList: _controllerList,
      loaderState: LoaderState.prev,
      currentIndex: state.currentIndex - 1,
    ));
  }

  void _onVideoLoaded(event, Emitter<StoryState> emit) {
    emit(state.copyWith(
      loaderState: LoaderState.videoLoaded,
    ));
  }

  void _onVideoLoading(event, Emitter<StoryState> emit) {
    emit(state.copyWith(
      loaderState: LoaderState.videoLoading,
    ));
  }
}
