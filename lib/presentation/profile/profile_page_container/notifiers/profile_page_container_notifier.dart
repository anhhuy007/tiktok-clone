import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/presentation/profile/profile_page_container/models/profile_page_container_model.dart';

import '../../../reels/notifiers/feed_providers.dart';

/// A notifier that manages the state of a ProfilePageContainer according to the event dispatched to it
class ProfilePageContainerNotifier
    extends Notifier<AsyncValue<UserInfoModel>> {
  Future<void> updateState(
      {required int userId, required int profileId}) async {
    state = const AsyncValue.loading();
    final apiService = ref.read(apiServiceProvider);
    try {
      state = await AsyncValue.guard(() async {
        final profile = await apiService.loadProfile(profileId: profileId);
        final followStatus = await apiService.getFollowStatus(
            followerId: userId, followingId: profileId);
        profile.followed = followStatus;
        return profile;
      });
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> follow({required int userId, required int profileId}) async {
    //state = const AsyncValue.loading();
    final apiService = ref.read(apiServiceProvider);
    try {
      await apiService.followUser(followerId: userId, followingId: profileId);
      final stateCurrentValue = state.value!;
      state = const AsyncValue.loading();
      //avoid too much fetching
      state = AsyncValue.data(stateCurrentValue.copyWith(
          follower: stateCurrentValue.follower + 1, followed: true));
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> unfollow({required int userId, required int profileId}) async {
    final apiService = ref.read(apiServiceProvider);
    try {
      await apiService.unfollowUser(followerId: userId, followingId: profileId);
      final stateCurrentValue = state.value!;
      state = const AsyncValue.loading();
      //avoid too much fetching
      state = AsyncValue.data(stateCurrentValue.copyWith(
          follower: stateCurrentValue.follower - 1, followed: false));
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  @override
  AsyncValue<UserInfoModel> build() {
    return const AsyncValue.loading();
  }
}

final profilePageContainerNotifier = NotifierProvider<
        ProfilePageContainerNotifier, AsyncValue<UserInfoModel>>(
    () => ProfilePageContainerNotifier());
