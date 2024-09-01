import 'package:tiktok_clone/presentation/home/home_page/models/feed_video.dart';

/// this class is used in the [profile_item_widget] screen.
class ProfileItemModel {
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

  ProfileItemModel({
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
  });

  factory ProfileItemModel.fromJson(Map<String, dynamic> json) {
    return ProfileItemModel(
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
    };
  }
}