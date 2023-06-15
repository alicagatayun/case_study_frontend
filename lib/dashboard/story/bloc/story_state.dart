part of 'story_bloc.dart';

class StoryState extends Equatable {
  const StoryState({
    this.storyDetail = const [],
    this.progressBarList = const [],
    this.applicationState = ApplicationState.loading,
    this.loaderState = LoaderState.idle,
    this.startFrom = 0,
    this.currentIndex = -1,
  });

  final List<StoryDetail> storyDetail;
  final List<bool> progressBarList;
  final int startFrom;
  final int currentIndex;
  final ApplicationState applicationState;
  final LoaderState loaderState;

  StoryState copyWith({
    List<StoryDetail>? storyDetail,
    List<bool>? progressBarList,
    int? startFrom,
    int? currentIndex,
    ApplicationState? applicationState,
    LoaderState? loaderState,
  }) {
    return StoryState(
      applicationState: applicationState ?? this.applicationState,
      progressBarList: progressBarList ?? this.progressBarList,
      storyDetail: storyDetail ?? this.storyDetail,
      startFrom: startFrom ?? this.startFrom,
      loaderState: loaderState ?? this.loaderState,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object> get props => [currentIndex,applicationState, startFrom, storyDetail, progressBarList,loaderState];
}

