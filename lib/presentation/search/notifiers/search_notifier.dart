import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/presentation/authentication/models/user_data.dart';
import 'package:tiktok_clone/presentation/search/models/seach_page_model.dart';
import 'package:tiktok_clone/service/remote/remote_api_service.dart';

class SearchPageNotifier extends StateNotifier<AsyncValue<SearchPageModel>> {
  SearchPageNotifier({required this.apiService, required this.user})
      : super(const AsyncValue.loading());

  final RemoteApiService apiService;
  final UserModel user;

  void updateQuery(String query) {
    state = state.whenData((data) => data.copyWith(query: query));
  }

  Future<void> fetchSuggestedVideos() async {
    state = const AsyncValue.loading();
    // Fetch suggested videos
    final suggestedVideos = await apiService.fetchSuggestedVideos(15);
    state = state
        .whenData((data) => data.copyWith(suggestedVideos: suggestedVideos));
  }

  Future<void> fetchMoreSuggestedVideos() async {
    state = const AsyncValue.loading();
    // Fetch more suggested videos
    final suggestedVideos = await apiService.fetchSuggestedVideos(15);
    state = state.whenData((data) => data.copyWith(
        suggestedVideos: [...data.suggestedVideos, ...suggestedVideos]));
  }

  Future<void> fetchSearchHistoryItems() async {
    state = const AsyncValue.loading();
    // Fetch search history items
    final searchHistoryItems = await apiService.fetchSearchHistoryItems(user.id);
    state = state.whenData(
        (data) => data.copyWith(searchItems: searchHistoryItems));
  }

  Future<void> search(String query) async {
    state = const AsyncValue.loading();
    // Search for query
    final searchResults = await apiService.search(query);
    state = state.whenData((data) => data.copyWith(searchItems: searchResults));
  }
}
