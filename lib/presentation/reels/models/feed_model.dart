import 'package:video_player/video_player.dart';

import 'comment.dart';
import 'feed_video.dart';

class FeedModel {
  final List<FeedVideo> videos;
  final List<bool> videosLikeStatus;
  final List<bool> videosUnlikeStatus;
  final bool currentVideoLiked;
  final bool currentVideoUnliked;
  final int currentVideoLikeCount;
  final bool isShowingComments;

  final int previousIndex;
  final int currentIndex;

  FeedModel(
      {required this.videos,
      required this.videosLikeStatus,
      required this.videosUnlikeStatus,
      required this.currentVideoLiked,
      required this.currentVideoUnliked,
      required this.currentVideoLikeCount,
      required this.isShowingComments,
      required this.previousIndex,
      required this.currentIndex});

  FeedModel copyWith(
      {List<FeedVideo>? videos,
      List<bool>? likeStatus,
      List<bool>? unlikeStatus,
      bool? currentVideoLiked,
      bool? currentVideoUnliked,
      int? currentVideoLikeCount,
      List<VideoPlayerController>? videoControllers,
      bool? isShowingComments,
      List<Comment>? comments,
      int? previousIndex,
      int? currentIndex}) {
    return FeedModel(
        videos: videos ?? this.videos,
        videosLikeStatus: likeStatus ?? this.videosLikeStatus,
        videosUnlikeStatus: unlikeStatus ?? this.videosUnlikeStatus,
        currentVideoLiked: currentVideoLiked ?? this.currentVideoLiked,
        currentVideoUnliked: currentVideoUnliked ?? this.currentVideoUnliked,
        currentVideoLikeCount:
            currentVideoLikeCount ?? this.currentVideoLikeCount,
        isShowingComments: isShowingComments ?? this.isShowingComments,
        previousIndex: previousIndex ?? this.previousIndex,
        currentIndex: currentIndex ?? this.currentIndex);
  }
}
