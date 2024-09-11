
import 'package:tiktok_clone/presentation/home/home_page/models/feed_video.dart';
import 'package:tiktok_clone/presentation/search/models/searching_item.dart';

class SearchPageModel {
  final List<FeedVideo> suggestedVideos;
  final bool isFetchingMore;

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