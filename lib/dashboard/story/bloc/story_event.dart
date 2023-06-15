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
  final int index;

  const NextStoryRequested(this.index);
}

class StopStoryRequested extends StoryEvent {

  const StopStoryRequested();
}

class ContinueStoryRequested extends StoryEvent {

  const ContinueStoryRequested();
}

class Ne extends StoryEvent {}

class StopAnimation extends StoryEvent {}
