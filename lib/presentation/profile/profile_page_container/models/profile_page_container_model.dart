class UserInfoModel {
  UserInfoModel(
      {required this.userId,
      required this.handle,
      required this.name,
      required this.follower,
      required this.following,
      required this.posts,
      required this.description,
      required this.avatarUrl,
      required this.thumbnailUrl});

  int userId;
  String handle;
  String name;
  int follower;
  int following;
  int posts;
  String description;
  String avatarUrl;
  String thumbnailUrl;
  bool followed = false;

  factory UserInfoModel.empty() => UserInfoModel(
      userId: 0,
      handle: '',
      name: '',
      follower: 0,
      following: 0,
      posts: 0,
      description: '',
      avatarUrl: '',
      thumbnailUrl: '');

  factory UserInfoModel.fromJson(Map<String, dynamic> json) =>
      UserInfoModel(
          userId: json['id'],
          handle: json['handle'],
          name: json['name'],
          follower: json['follower'],
          following: json['following'],
          posts: json['posts'],
          description: json['description'],
          avatarUrl: json['avatar_url'],
          thumbnailUrl: json['thumbnail_url']);

  Map<String, dynamic> toJson() {
    return {
      "id": userId,
      "handle": handle,
      "name": name,
      "follower": follower,
      "following": following,
      "posts": posts,
      "description": description,
      "avatar_url": avatarUrl,
      "thumbnail_url": thumbnailUrl
    };
  }

  UserInfoModel copyWith({
    int? userId,
    String? handle,
    String? name,
    int? follower,
    int? following,
    int? posts,
    String? description,
    String? avatarUrl,
    String? thumbnailUrl,
    bool? followed,
  }) {
    return UserInfoModel(
      userId: userId ?? this.userId,
      handle: handle ?? this.handle,
      name: name ?? this.name,
      follower: follower ?? this.follower,
      following: following ?? this.following,
      posts: posts ?? this.posts,
      description: description ?? this.description,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    )..followed = followed ?? this.followed;
  }
}
