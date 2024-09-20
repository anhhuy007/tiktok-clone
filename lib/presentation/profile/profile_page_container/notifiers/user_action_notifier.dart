import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/presentation/profile/profile_page_container/models/user_action_model.dart';

import '../../../reels/notifiers/feed_providers.dart';

class UserActionNotifier extends Notifier<AsyncValue<UserAction>> {
  @override
  AsyncValue<UserAction> build() {
    return const AsyncValue.loading();
  }

  Future<void> updateUserAction(
      {required int followerId, required int followingId}) async {
    state = const AsyncValue.loading();
    final apiService = ref.read(apiServiceProvider);
    try {
      final response = await apiService.getFollowStatus(
          followerId: followerId, followingId: followingId);
      state = AsyncValue.data(UserAction(followed: response));
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}

final userActionNotifier =
    NotifierProvider<UserActionNotifier, AsyncValue<UserAction>>(
        () => UserActionNotifier());
