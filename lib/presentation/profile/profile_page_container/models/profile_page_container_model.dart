class ProfilePageContainerModel {
  ProfilePageContainerModel(
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

  factory ProfilePageContainerModel.fromJson(Map<String, dynamic> json) =>
      ProfilePageContainerModel(
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

  ProfilePageContainerModel copyWith({
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
    return ProfilePageContainerModel(
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
