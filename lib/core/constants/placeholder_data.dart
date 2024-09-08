import 'package:tiktok_clone/presentation/home/home_page/models/comment.dart';
import 'package:tiktok_clone/presentation/home/home_page/models/feed_video.dart';

final List<Comment> commentFakeData = List.generate(
    5,
    (index) => Comment(
          id: index,
          videoId: index,
          content: 'Comment $index',
          createdAt: DateTime.now(),
          commenterId: index,
          likeCount: index,
          replyCount: index,
          userHandle: 'User $index',
          avatarUrl: 'https://picsum.photos/200/300?random=$index',
        ));

final FeedVideo feedFakeVideo = FeedVideo(
  id: 0,
  title: 'Sample Video',
  likes: 0,
  comments: 0,
  views: 0,
  song: 'Sample Song',
  createdAt: DateTime.now(),
  videoUrl:
      'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
  thumbnailUrl: 'https://picsum.photos/200/300?random=0',
  channelId: 0,
  channelHandle: 'Sample Channel',
  channelAvatarUrl: 'https://picsum.photos/200/300?random=0',
);
