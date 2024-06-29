import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/presentation/profile/profile_page_container/models/profile_page_container_model.dart';

/// A notifier that manages the state of a ProfilePageContainer according to the event dispatched to it
class ProfilePageContainerNotifier extends Notifier<ProfilePageContainerModel> {
  @override
  ProfilePageContainerModel build() {
    // TODO: implement build
    return ProfilePageContainerModel();
  }
}

final profilePageContainerNotifier = NotifierProvider<ProfilePageContainerNotifier, ProfilePageContainerModel> (
    () => ProfilePageContainerNotifier()
);