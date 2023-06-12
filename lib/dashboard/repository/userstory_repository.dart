import 'dart:convert';

import 'package:case_study_frontend/dashboard/api/user_api.dart';
import 'package:case_study_frontend/dashboard/model/user_dto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

class UserStoryRepository {
  final UserStoryApi userStoryApi;

  UserStoryRepository(this.userStoryApi);

  Future<List<UserDto>> getUsersRequested(String userId) async {
    try {
      final String response = await rootBundle.loadString('assets/sample.json');
      final data = await json.decode(response);

      //final response = await userStoryApi.getUsersStoryApi(userId);
      final users = (data['data'] as List).map((e) => UserDto.fromJson(e)).toList();
      return users;
    } on DioException catch (e) {
      return <UserDto>[];
    }
  }
}