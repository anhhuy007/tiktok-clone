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
}