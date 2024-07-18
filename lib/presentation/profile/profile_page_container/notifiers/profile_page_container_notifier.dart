import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/presentation/profile/profile_page_container/models/profile_page_container_model.dart';

/// A notifier that manages the state of a ProfilePageContainer according to the event dispatched to it
class ProfilePageContainerNotifier extends Notifier<ProfilePageContainerModel> {
  @override
  ProfilePageContainerModel build() {
    // TODO: implement build
    return ProfilePageContainerModel(
      userId: 1,
      handle: "@fearron",
      name: "Fearron",
      follower: 1,
      following: 2,
      posts: 4,
      description: "Eu proident est sint excepteur ad cillum exercitation sunt nisi consectetur minim pariatur quis elit. Aliqua cillum deserunt aliquip do irure culpa do deserunt tempor sunt.",
      avatarUrl: "https://yt3.googleusercontent.com/PlolKXX01kTs7Eqq_GDhUeXkVgVPlJhEUNVYw4AOgZfVPhUO-k-p2I6Qo_h7bGFXSmUexS-_PW4=s176-c-k-c0x00ffffff-no-rj",
      thumbnailUrl: "https://drive.google.com/file/d/1_VuG30LkK3lxNxRZhwFqIid1c7zBAKZh/view?usp=sharing"
    );
  }
}

final profilePageContainerNotifier = NotifierProvider<ProfilePageContainerNotifier, ProfilePageContainerModel> (
    () => ProfilePageContainerNotifier()
);