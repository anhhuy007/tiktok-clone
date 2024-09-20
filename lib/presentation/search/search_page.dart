import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tiktok_clone/presentation/search/models/seach_page_model.dart';
import 'package:tiktok_clone/presentation/search/notifiers/onfocus_search_notifier.dart';
import 'package:tiktok_clone/presentation/search/onsearch_focus_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../reels/feeding_page.dart';
import '../reels/models/feed_video.dart';
import 'notifiers/search_notifier.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      ref.read(searchPageProvider.notifier).fetchMoreSuggestedVideos();
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchPageProvider);

    return Scaffold(
      appBar: AppBar(
        title: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: SizedBox(
            height: 70,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 20, bottom: 8),
              child: TextField(
                controller: searchState.value?.searchController,
                decoration: InputDecoration(
                  hintText: 'Search anything...',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                style: const TextStyle(color: Colors.black, fontSize: 13),
                onTap: () {
                  setState(() {
                    _isSearchFocused = true;
                  });
                },
                onChanged: (value) {
                  ref.read(onFocusSearchProvider.notifier).search(value);
                },
                onSubmitted: (value) {
                  ref.read(onFocusSearchProvider.notifier).insertSearchHistoryItem(
                      value, null);
                }
              ),
            ),
          ),
        ),
      ),
      body: _isSearchFocused
          ? OnFocusSearchPage(
              onClose: () {
                setState(() {
                  _isSearchFocused = false;
                });
                searchState.value?.searchController.clear();
                FocusScope.of(context).unfocus();
                ref.read(onFocusSearchProvider.notifier).fetchSearchHistoryItems();
              },
            )
          : Consumer(
              builder: (context, ref, child) {
                return searchState.when(
                  loading: () => Center(
                      child: LoadingAnimationWidget.halfTriangleDot(
                          color: Colors.black, size: 40)),
                  error: (error, stackTrace) =>
                      Center(child: Text('Error: $error')),
                  data: (SearchPageModel data) {
                    final videos = data.suggestedVideos;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: CustomScrollView(
                        controller: _scrollController,
                        slivers: [
                          SliverGrid(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1.0,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return VideoThumbnail(video: videos[index]);
                              },
                              childCount: videos.length,
                            ),
                          ),
                          if (data.isFetchingMore)
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Center(
                                  child: LoadingAnimationWidget.staggeredDotsWave(
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class VideoThumbnail extends StatelessWidget {
  final FeedVideo video;

  const VideoThumbnail({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FeedingPage(video: video),
          ),
        );
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Thumbnail image
          CachedNetworkImage(
            imageUrl: video.thumbnailUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey[300],
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[300],
              child: const Icon(Icons.error),
            ),
          ),
          // View count
          Positioned(
            left: 8,
            bottom: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Text(
                    _formatViewCount(video.views),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.remove_red_eye,
                    color: Colors.white,
                    size: 13,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatViewCount(int viewCount) {
    if (viewCount >= 1000000) {
      return '${(viewCount / 1000000).toStringAsFixed(1)}M';
    } else if (viewCount >= 1000) {
      return '${(viewCount / 1000).toStringAsFixed(1)}K';
    } else {
      return viewCount.toString();
    }
  }
}
