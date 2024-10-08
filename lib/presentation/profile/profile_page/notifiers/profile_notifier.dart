import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/presentation/profile/profile_page/models/profile_page_model.dart';

import '../../../reels/notifiers/feed_providers.dart';

/// A notifier that manages the state of a Profile according to the event dispatched to it
class ProfileNotifier extends Notifier<AsyncValue<ProfileModel>> {
  @override
  AsyncValue<ProfileModel> build() {
    return const AsyncValue.loading();
  }

  Future<void> fetchPopularVideos({required int userId}) async {
    state = const AsyncValue.loading();
    final apiService = ref.read(apiServiceProvider);
    try {
      state = await AsyncValue.guard(() async {
        final result = await apiService.loadPopularVideos(userId: userId);
        return result;
      });
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> fetchLatestVideos({required int userId}) async {
    state = const AsyncValue.loading();
    final apiService = ref.read(apiServiceProvider);
    try {
      state = await AsyncValue.guard(() async {
        final result = await apiService.loadLatestVideos(userId: userId);
        return result;
      });
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> fetchOldestVideos({required int userId}) async {
    state = const AsyncValue.loading();
    final apiService = ref.read(apiServiceProvider);
    try {
      state = await AsyncValue.guard(() async {
        final result = await apiService.loadOldestVideos(userId: userId);
        return result;
      });
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final profileNotifier =
    NotifierProvider<ProfileNotifier, AsyncValue<ProfileModel>>(
        () => ProfileNotifier());
