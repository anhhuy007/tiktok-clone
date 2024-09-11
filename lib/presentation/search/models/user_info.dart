class UserInfo {
  UserInfo(
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

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
      userId: json['id'] ?? 0,
      handle: json['handle'] ?? '',
      name: json['name'] ?? '',
      follower: json['follower'] ?? 0,
      following: json['following'] ?? 0,
      posts: json['posts'] ?? 0,
      description: json['description'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
      thumbnailUrl: json['thumbnail_url'] ?? '');

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
}
