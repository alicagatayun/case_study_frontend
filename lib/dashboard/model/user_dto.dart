class UserDto {
  User? user;
  Stories? story;
  bool? allSeen;
  UserDto({
    this.user,
    this.story,
     this.allSeen,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      story: json['story'] != null ? Stories.fromJson(json['story']) : null,
      allSeen: json['allSeen'] ?? false,
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
      id: json['id'],
      name: json['name'],
      profilePhotoPath: json['profilePhotoPath'],
      createdAt: DateTime.parse(json['createdAt']),
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
      id: json['id'],
      userId: json['userId'],
      numberOfStoryGroup: json['numberOfStoryGroup'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
