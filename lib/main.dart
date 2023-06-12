import 'package:case_study_frontend/dashboard/api/user_api.dart';
import 'package:case_study_frontend/dashboard/bloc/dashboard_bloc.dart';
import 'package:case_study_frontend/dashboard/repository/userstory_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard/ui/dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  UserRepository? _userRepository;
  UserStoryRepository? _userStoryRepository;

  @override
  void initState() {
    super.initState();
    _userRepository = UserRepository();
    _userStoryRepository = UserStoryRepository(UserStoryApi());
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _userRepository,
      child: BlocProvider(
        create: (_) => DashboardBloc(
          userRepository: _userRepository!,
          userStoryRepository: _userStoryRepository!,
        ),
        child: MaterialApp(builder: (context, child) {
          return const DashboardPage();
        }),
      ),
    );
  }
}

class UserRepository {
  Future<String?> getUser() async {
    return Future.delayed(const Duration(milliseconds: 1000), () => '563a77e9-3a2e-4a45-bdcf-01d214c2f86b');
  }
}
