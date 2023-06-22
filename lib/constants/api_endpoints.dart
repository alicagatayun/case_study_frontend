final class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = "https://webapp-230618191055.azurewebsites.net/";

  // receiveTimeout
  static const int receiveTimeout = 15000;

  // connectTimeout
  static const int connectionTimeout = 15000;

  static const String userRelationsUrl = "Story/get-user-connections-having-story";
  static const String storyDetailUrl = "Story/get-story-detail";
  static const String updateStoryDetailUrl = "Story/update-story-detail";
}
