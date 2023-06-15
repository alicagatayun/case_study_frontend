class StoryDetailDto {
  List<StoryDetail>? storyDetail;
  int? startFrom;

  StoryDetailDto({
    this.storyDetail,
    this.startFrom,
  });

  factory StoryDetailDto.fromJson(Map<String, dynamic> json) {
    final storyDetailsList = (json['storyDetails'] as List)
        .map((storyJson) => StoryDetail.fromJson(storyJson))
        .toList();
    return StoryDetailDto(
      storyDetail: storyDetailsList,
      startFrom: json['startFrom'] ?? 0,
    );
  }
}

class StoryDetail {
  String id;
  String? storyId;
  String? imagePath;
  bool? isVideo;
  int? duration;
  DateTime createdAt;

  StoryDetail({
    required this.id,
    this.storyId,
    this.imagePath,
    this.isVideo,
    this.duration,
    required this.createdAt,
  });

  factory StoryDetail.fromJson(Map<String, dynamic> json) {
    return StoryDetail(
      id: json['id'],
      storyId: json['storyId'],
      imagePath: json['imagePath'],
      isVideo: json['isVideo'],
      duration: json['duration'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
