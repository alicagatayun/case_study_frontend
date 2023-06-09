import 'package:case_study_frontend/constants/api_endpoints.dart';
import 'package:case_study_frontend/dio/dio.dart';
import 'package:dio/dio.dart';

class UserStoryApi {
  UserStoryApi();

  Future<Response> getUsersStoryApi(String userId) async {
    Dio dio = Dio();
    DioClient dioC = DioClient(dio);
    try {
      Map<String, dynamic>? queryParameters = {"userId": userId};
      final Response response = await dioC.get(Endpoints.userRelationsUrl, queryParameters: queryParameters);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getStoryDetailApi(String storyId) async {
    Dio dio = Dio();
    DioClient dioC = DioClient(dio);
    try {
      Map<String, dynamic>? queryParameters = {"storyId": storyId};
      final Response response = await dioC.get(Endpoints.storyDetailUrl, queryParameters: queryParameters);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> updateStoryDetail(String storyDetailId, String userId) async {
    try {
      Dio dio = Dio();
      DioClient dioC = DioClient(dio);
      final Response response = await dioC.post(
        Endpoints.updateStoryDetailUrl,
        data: {
          'StoryDetailId': storyDetailId,
          'UserId': userId,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

}
