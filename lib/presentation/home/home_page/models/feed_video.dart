// id, title, video_url, thumbnail_url, views, youtube_id, channel_id
class FeedVideo {
  final int id;
  final String title;
  final int likes;
  final int comments;
  final int views;
  final String song;
  final DateTime createdAt;
  final String videoUrl;
  final String thumbnailUrl;
  final int channelId;
  final String channelHandle;
  final String channelAvatarUrl;

  FeedVideo({
    required this.id,
    required this.title,
    required this.likes,
    required this.comments,
    required this.views,
    required this.song,
    required this.createdAt,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.channelId,
    required this.channelHandle,
    required this.channelAvatarUrl,
  });

  FeedVideo copyWith({
    int? id,
    String? title,
    int? likes,
    int? comments,
    int? views,
    String? song,
    DateTime? createdAt,
    String? videoUrl,
    String? thumbnailUrl,
    int? channelId,
    String? channelHandle,
    String? channelAvatarUrl,
  }) {
    return FeedVideo(
      id: id ?? this.id,
      title: title ?? this.title,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      views: views ?? this.views,
      song: song ?? this.song,
      createdAt: createdAt ?? this.createdAt,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      channelId: channelId ?? this.channelId,
      channelHandle: channelHandle ?? this.channelHandle,
      channelAvatarUrl: channelAvatarUrl ?? this.channelAvatarUrl,
    );
  }

  factory FeedVideo.fromJson(Map<String, dynamic> json) {
    return FeedVideo(
      id: json['id'],
      title: json['title'],
      likes: json['likes'],
      comments: json['comments'],
      views: json['views'],
      song: json['song'],
      createdAt: DateTime.parse(json['created_at']),
      videoUrl: json['video_url'],
      thumbnailUrl: json['thumbnail_url'],
      channelId: json['channel_id'],
      channelHandle: json['handle'],
      channelAvatarUrl: json['avatar_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'likes': likes,
      'comments': comments,
      'views': views,
      'song': song,
      'created_at': createdAt.toIso8601String(),
      'video_url': videoUrl,
      'thumbnail_url': thumbnailUrl,
      'channel_id': channelId,
      'handle': channelHandle,
      'avatar_url': channelAvatarUrl,
    };
  }
}
