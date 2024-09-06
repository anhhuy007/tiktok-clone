import 'package:tiktok_clone/presentation/home/home_page/models/comment.dart';

final List<Comment> commentFakeData = List.generate(5, (index) =>
  Comment(
    id: index,
    videoId: index,
    content: 'Comment $index',
    createdAt: DateTime.now(),
    commenterId: index,
    likeCount: index,
    replyCount: index,
    userHandle: 'User $index',
    avatarUrl: 'https://picsum.photos/200/300?random=$index',
  )
);