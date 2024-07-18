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