part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  const DashboardState({
    this.userRelations = const [],
    this.applicationState = ApplicationState.loading,
    this.numberOfStories = 0
  });

  final List<UserDto> userRelations;
  final int numberOfStories;
  final ApplicationState applicationState;

  DashboardState copyWith({
    ApplicationState? applicationState,
    List<UserDto>? userRelations,
    int? numberOfStories,
  }) {
    return DashboardState(
      applicationState: applicationState ?? this.applicationState,
      userRelations: userRelations ?? this.userRelations,
      numberOfStories: numberOfStories ?? this.numberOfStories,
    );
  }

  @override
  List<Object> get props => [applicationState, userRelations, numberOfStories];
}

enum ApplicationState { loading, loaded, error }
