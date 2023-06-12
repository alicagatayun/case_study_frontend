class UserDto {
  User? user;
  Stories? story;
  bool allSeen;
  DateTime createdAt;
  UserDto({
    this.user,
    this.story,
    required this.allSeen,
    required this.createdAt,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      story: json['story'] != null ? Stories.fromJson(json['story']) : null,
      allSeen: json['AllSeen'] ?? false,
      createdAt: json['CreatedAt'],
    );
  }
}

class User  {
  String id;
  String? name;
  String? profilePhotoPath;
  DateTime createdAt;
  User({
    required this.id,
    this.name,
    this.profilePhotoPath,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['Id'],
      name: json['Name'],
      profilePhotoPath: json['ProfilePhotoPath'],
      createdAt: json['CreatedAt'],
    );
  }
}

class Stories {
  String id;
  String userId;
  int numberOfStoryGroup;
  DateTime createdAt;

  Stories({
    required this.id,
    required this.userId,
    required this.numberOfStoryGroup,
    required this.createdAt,
  });

  factory Stories.fromJson(Map<String, dynamic> json) {
    return Stories(
      id: json['Id'],
      userId: json['UserId'],
      numberOfStoryGroup: json['NumberOfStoryGroup'],
      createdAt: json['CreatedAt'],
    );
  }
}
