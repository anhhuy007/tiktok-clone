import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:tiktok_clone/presentation/authentication/models/user_data.dart';
import 'package:tiktok_clone/presentation/authentication/notifiers/auth_notifier.dart';
import 'package:tiktok_clone/presentation/home/home_page/notifiers/feed_providers.dart';
import 'package:tiktok_clone/presentation/search/models/onfocus_searchpage_model.dart';
import 'package:tiktok_clone/service/remote/remote_api_service.dart';

class OnFocusSearchNotifier extends StateNotifier<AsyncValue<OnFocusSearchPageModel>> {
  final RemoteApiService apiService;
  final UserModel user;

  OnFocusSearchNotifier(this.apiService, this.user) : super(const AsyncValue.loading()) {
    fetchSearchHistoryItems();
  }

  Future<void> fetchSearchHistoryItems() async {
    state = const AsyncValue.loading();
    try {
      final searchItems = await apiService.fetchSearchHistoryItems(user.id);
      state = AsyncValue.data(OnFocusSearchPageModel(searchItems: searchItems));
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> search(String value) async {
    Logger().d('Searching for $value');
    state = const AsyncValue.loading();
    try {
      final searchItems = await apiService.search(value);
      Logger().d('Search results: $searchItems');
      state = AsyncValue.data(OnFocusSearchPageModel(searchItems: searchItems));
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final onFocusSearchProvider = StateNotifierProvider<OnFocusSearchNotifier, AsyncValue<OnFocusSearchPageModel>>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final user = ref.read(authProvider).user;

  return OnFocusSearchNotifier(apiService, user ?? UserModel.empty());
});