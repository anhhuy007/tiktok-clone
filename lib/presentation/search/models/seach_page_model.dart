
import 'package:tiktok_clone/presentation/home/home_page/models/feed_video.dart';
import 'package:tiktok_clone/presentation/search/models/searching_item.dart';

class SearchPageModel {
  final String query;
  final List<FeedVideo> suggestedVideos;
  final List<SearchItem> searchItems;

  SearchPageModel({
    required this.query,
    required this.suggestedVideos,
    required this.searchItems,
  });

  SearchPageModel copyWith({
    String? query,
    List<FeedVideo>? suggestedVideos,
    List<SearchItem>? searchItems,
  }) {
    return SearchPageModel(
      query: query ?? this.query,
      suggestedVideos: suggestedVideos ?? this.suggestedVideos,
      searchItems: searchItems ?? this.searchItems,
    );
  }
}