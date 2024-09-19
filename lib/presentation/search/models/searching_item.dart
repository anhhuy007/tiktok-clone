class SearchItem {
  final int? id;
  final int? userId;
  final String? name;
  final String? handle;
  final String? avatarUrl;
  final int? followers;
  final String? searchQuery;

  SearchItem({
    this.id,
    this.userId,
    this.name,
    this.handle,
    this.avatarUrl,
    this.followers,
    this.searchQuery,
  });

  factory SearchItem.fromJson(Map<String, dynamic> json) {
    return SearchItem(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      handle: json['handle'],
      avatarUrl: json['avatarUrl'],
      followers: json['followers'],
      searchQuery: json['searchQuery'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'handle': handle,
      'avatarUrl': avatarUrl,
      'followers': followers,
      'searchQuery': searchQuery,
    };
  }
}