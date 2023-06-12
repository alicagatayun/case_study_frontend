part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  const DashboardState({
    this.userRelations = const [],
    this.applicationState = ApplicationState.loading,
  });

  final List<UserDto> userRelations;

  final ApplicationState applicationState;

  DashboardState copyWith({
    ApplicationState? applicationState,
    List<UserDto>? userRelations,
  }) {
    return DashboardState(
      applicationState: applicationState ?? this.applicationState,
      userRelations: userRelations ?? this.userRelations,
    );
  }

  @override
  List<Object> get props => [applicationState, userRelations];
}

enum ApplicationState { loading, loaded, error }
