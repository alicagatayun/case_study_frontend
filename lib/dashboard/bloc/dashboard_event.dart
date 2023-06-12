part of 'dashboard_bloc.dart';

abstract class DashboardEvent {
  const DashboardEvent();
}

class GetUserRelationStories extends DashboardEvent {
  const GetUserRelationStories();
}
