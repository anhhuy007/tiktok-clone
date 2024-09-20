import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:tiktok_clone/presentation/authentication/models/user_data.dart';
import 'package:tiktok_clone/presentation/authentication/notifiers/auth_notifier.dart';
import 'package:tiktok_clone/presentation/search/models/onfocus_searchpage_model.dart';
import 'package:tiktok_clone/service/remote_api_service.dart';

import '../../reels/notifiers/feed_providers.dart';

class OnFocusSearchNotifier
    extends StateNotifier<AsyncValue<OnFocusSearchPageModel>> {
  final RemoteApiService apiService;
  final UserModel user;

  OnFocusSearchNotifier(this.apiService, this.user)
      : super(const AsyncValue.loading()) {
    fetchSearchHistoryItems();
  }

  Future<void> fetchSearchHistoryItems() async {
    state = const AsyncValue.loading();
    try {
      final searchedItems = await apiService.fetchSearchHistoryItems(user.id);
      state = AsyncValue.data(OnFocusSearchPageModel(searchedItems: searchedItems, searchItems: null));
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> search(String value) async {
    Logger().d('Searching for $value');

    if (value.isEmpty) {
      fetchSearchHistoryItems();
      return;
    }

    state = const AsyncValue.loading();
    try {
      final searchItems = await apiService.search(value);
      state = AsyncValue.data(OnFocusSearchPageModel(searchedItems: null, searchItems: searchItems));
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> insertSearchHistoryItem(String query, int? searchedUserId) async {
    try {
      await apiService.postSearchHistoryItem(user.id, query, searchedUserId);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteSearchHistoryItem(int searchHistoryId) async {
    try {
      await apiService.deleteSearchHistoryItem(searchHistoryId);
      fetchSearchHistoryItems();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final onFocusSearchProvider = StateNotifierProvider<OnFocusSearchNotifier,
    AsyncValue<OnFocusSearchPageModel>>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final user = ref.read(authProvider).user;

  return OnFocusSearchNotifier(apiService, user ?? UserModel.empty());
});
