import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/presentation/home/home_page/notifiers/feed_providers.dart';
import 'package:tiktok_clone/presentation/profile/profile_page_container/models/profile_page_container_model.dart';

/// A notifier that manages the state of a ProfilePageContainer according to the event dispatched to it
class ProfilePageContainerNotifier extends Notifier<AsyncValue<ProfilePageContainerModel>> {


    state = const AsyncValue.loading();
    final apiService = ref.read(apiServiceProvider);
    try{
      state = await AsyncValue.guard(() async {
        return profile;
      });
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  @override
  AsyncValue<ProfilePageContainerModel> build() {
    return AsyncValue.loading();
  }
}

final profilePageContainerNotifier = NotifierProvider<ProfilePageContainerNotifier, AsyncValue<ProfilePageContainerModel>> (
    () => ProfilePageContainerNotifier()
);