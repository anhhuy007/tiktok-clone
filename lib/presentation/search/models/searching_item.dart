class SearchItem {
  final String? name;
  final String? handle;
  final String? avatarUrl;
  final int? followers;
  final String? searchQuery;

  SearchItem({
    this.name,
    this.handle,
    this.avatarUrl,
    this.followers,
    this.searchQuery,
  });

  factory SearchItem.fromJson(Map<String, dynamic> json) {
    return SearchItem(
      name: json['name'],
      handle: json['handle'],
      avatarUrl: json['avatarUrl'],
      followers: json['followers'],
      searchQuery: json['searchQuery'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'handle': handle,
      'avatarUrl': avatarUrl,
      'followers': followers,
      'searchQuery': searchQuery,
    };
  }
}