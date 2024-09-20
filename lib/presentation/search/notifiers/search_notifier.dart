import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:tiktok_clone/presentation/authentication/models/user_data.dart';
import 'package:tiktok_clone/presentation/authentication/notifiers/auth_notifier.dart';
import 'package:tiktok_clone/presentation/search/models/seach_page_model.dart';
import 'package:tiktok_clone/service/remote_api_service.dart';

import '../../reels/models/feed_video.dart';
import '../../reels/notifiers/feed_providers.dart';


class SearchPageNotifier extends StateNotifier<AsyncValue<SearchPageModel>> {
  SearchPageNotifier({required this.apiService, required this.user})
      : super(const AsyncValue.loading()) {
    fetchSuggestedVideos();
  }

  final RemoteApiService apiService;
  final UserModel user;

  Future<void> fetchSuggestedVideos() async {
    try {
      state = const AsyncValue.loading();
      // Fetch suggested videos
      Logger().i('Fetching suggested videos...');
      final suggestedVideos = await apiService.fetchSuggestedVideos(18);
      state = AsyncValue.data(SearchPageModel(
        suggestedVideos: suggestedVideos,
        isFetchingMore: false,
      ));
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> fetchMoreSuggestedVideos() async {
    state.whenData((data) async {
        try {
          state = AsyncValue.data(data.copyWith(isFetchingMore: true));
          // Fetch more suggested videos
          final suggestedVideos = await apiService.fetchSuggestedVideos(15);
          final List<FeedVideo> updatedSuggestedVideos = [
          ...state.value?.suggestedVideos ?? [],
          ...suggestedVideos
          ];
          state = AsyncValue.data(SearchPageModel(
            suggestedVideos: updatedSuggestedVideos,
            isFetchingMore: false,
          ));
        } catch (e, stackTrace) {
          state = AsyncValue.error(e, stackTrace);
        }
    });
  }
}

final searchPageProvider =
    StateNotifierProvider<SearchPageNotifier, AsyncValue<SearchPageModel>>(
        (ref) {
  final apiService = ref.watch(apiServiceProvider);
  final user = ref.read(authProvider).user;

  return SearchPageNotifier(
      apiService: apiService, user: user ?? UserModel.empty());
});
