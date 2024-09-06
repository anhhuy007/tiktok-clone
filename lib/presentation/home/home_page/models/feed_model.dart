import 'package:video_player/video_player.dart';

import '../models/feed_video.dart';

class FeedModel {
  final List<FeedVideo> videos;
  final int previousIndex;
  final int currentIndex;

  FeedModel({required this.videos, required this.previousIndex, required this.currentIndex});

  FeedModel copyWith({List<FeedVideo>? videos, List<VideoPlayerController>? videoControllers, int? previousIndex, int? currentIndex}) {
    return FeedModel(
        videos: videos ?? this.videos,
        previousIndex: previousIndex ?? this.previousIndex,
        currentIndex: currentIndex ?? this.currentIndex
    );
  }
}