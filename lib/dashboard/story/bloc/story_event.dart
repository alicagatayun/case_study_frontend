part of 'story_bloc.dart';

abstract class StoryEvent {
  const StoryEvent();
}

class GetStoryDetailRequested extends StoryEvent {
  final String storyId;

  const GetStoryDetailRequested(this.storyId);
}

class GetProgressBarNewValue extends StoryEvent {
  final int index;

  const GetProgressBarNewValue(this.index);
}

class NextStoryRequested extends StoryEvent {
  const NextStoryRequested();
}

class PreviousStoryRequested extends StoryEvent {
  const PreviousStoryRequested();
}

class StopStoryRequested extends StoryEvent {
  const StopStoryRequested();
}

class ContinueStoryRequested extends StoryEvent {
  const ContinueStoryRequested();
}

class VideoLoaded extends StoryEvent {
  const VideoLoaded();

}
class VideoLoading extends StoryEvent {
  const VideoLoading();

}

class StopAnimation extends StoryEvent {}
