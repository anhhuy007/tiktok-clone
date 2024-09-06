class ProfilePageContainerModel {
  ProfilePageContainerModel({
    required this.userId,
    required this.handle,
    required this.name,
    required this.follower,
    required this.following,
    required this.posts,
    required this.description,
    required this.avatarUrl,
    required this.thumbnailUrl
  });

  int userId;
  String handle;
  String name;
  int follower;
  int following;
  int posts;
  String description;
  String avatarUrl;
  String thumbnailUrl;

  factory ProfilePageContainerModel.fromJson(Map<String, dynamic> json) => ProfilePageContainerModel(
    userId: json['id'],
    handle: json['handle'],
    name: json['name'],
    follower: json['follower'],
    following: json['following'],
    posts: json['posts'],
    description: json['description'],
    avatarUrl: json['avatar_url'],
    thumbnailUrl: json['thumbnail_url']
  );

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