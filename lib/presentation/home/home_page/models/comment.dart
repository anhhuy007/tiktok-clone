class Comment {
  int id;
  int videoId;
  String content;
  DateTime createdAt;
  int commenterId;
  int likeCount;
  int replyCount;
  String userHandle;
  String avatarUrl;

  Comment({
    required this.id,
    required this.videoId,
    required this.content,
    required this.createdAt,
    required this.commenterId,
    required this.likeCount,
    required this.replyCount,
    required this.userHandle,
    required this.avatarUrl,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      videoId: json['video_id'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
      commenterId: json['commenter_id'],
      likeCount: json['like_count'],
      replyCount: json['reply_count'],
      userHandle: json['handle'],
      avatarUrl: json['avatar_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'video_id': videoId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'commenter_id': commenterId,
      'like_count': likeCount,
      'reply_count': replyCount,
      'handle': userHandle,
      'avatar_url': avatarUrl,
    };
  }
}