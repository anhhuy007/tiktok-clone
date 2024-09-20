
import 'package:flutter/cupertino.dart';
import '../../reels/models/feed_video.dart';


class SearchPageModel {
  final List<FeedVideo> suggestedVideos;
  final bool isFetchingMore;
  final TextEditingController searchController = TextEditingController();

  SearchPageModel({
    required this.suggestedVideos,
    required this.isFetchingMore,
  });

  SearchPageModel copyWith({
    List<FeedVideo>? suggestedVideos,
    bool? isFetchingMore,
  }) {
    return SearchPageModel(
      suggestedVideos: suggestedVideos ?? this.suggestedVideos,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
    );
  }
}