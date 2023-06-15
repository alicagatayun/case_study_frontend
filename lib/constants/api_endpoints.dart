final class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = "https://localhost:7168/";

  // receiveTimeout
  static const int receiveTimeout = 15000;
  // connectTimeout
  static const int connectionTimeout = 15000;

  static const String userRelationsUrl = "Story/get-user-having-story";
  static const String storyDetailUrl = "Story/get-story-detail";

}