import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/presentation/authentication/notifiers/user_notifier.dart';
import 'package:tiktok_clone/presentation/authentication/models/user_data.dart';
import 'package:tiktok_clone/presentation/home/home_page/models/feed_model.dart';
import 'package:tiktok_clone/presentation/home/home_page/models/feed_video.dart';
import 'package:video_player/video_player.dart';

import '../../../../service/remote_api_service.dart';
import 'package:logger/logger.dart';

class FeedNotifier extends StateNotifier<AsyncValue<FeedModel>> {
  UserModel user;
  final RemoteApiService _remoteApiService;
  final Map<String, VideoPlayerController> videoControllers = {};

  FeedNotifier(this.user, this._remoteApiService)
      : super(const AsyncValue.loading()) {
    fetchFeedVideos();
  }

  Future<void> fetchFeedVideos() async {
    state = const AsyncValue.loading();
    try {
      Logger().d('Loading videos...');
      final videos = await _remoteApiService.loadVideos();
      final alreadyLiked =
          await _remoteApiService.getLikedVideos(user.id, videos);

      state = AsyncValue.data(FeedModel(
          videos: videos,
          videosLikeStatus: alreadyLiked,
          videosUnlikeStatus: List.filled(videos.length, false),
          currentVideoLiked: alreadyLiked[0],
          currentVideoUnliked: false,
          currentVideoLikeCount: videos[0].likes,
          isShowingComments: false,
          currentIndex: 0,
          previousIndex: -1));
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> fetchMoreVideos() async {
    Logger().d('fetchMoreVideos');
    final currentVideos = state.value?.videos ?? [];
    final previousIndex = state.value?.previousIndex ?? 0;
    final currentIndex = state.value?.currentIndex ?? 0;
    // load more videos
    try {
      final newVideos = await _remoteApiService.loadVideos(limit: 5);
      final updatedVideos = [...currentVideos, ...newVideos];

      final newAlreadyLiked =
          await _remoteApiService.getLikedVideos(user.id, newVideos);
      final updatedAlreadyLiked = [
        ...state.value!.videosLikeStatus,
        ...newAlreadyLiked
      ];

      state = AsyncValue.data(FeedModel(
          videos: updatedVideos,
          videosLikeStatus: updatedAlreadyLiked,
          videosUnlikeStatus: List.filled(updatedVideos.length, false),
          currentVideoLiked: updatedAlreadyLiked[currentIndex],
          currentVideoUnliked: false,
          currentVideoLikeCount: 0,
          isShowingComments: false,
          previousIndex: previousIndex,
          currentIndex: currentIndex));
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void likeVideo() {
    Logger().d('likeVideo');
    state.whenData((data) {
      state = AsyncValue.data(data.copyWith(
        currentVideoLiked: !data.currentVideoLiked,
        currentVideoUnliked: false,
        currentVideoLikeCount: data.currentVideoLiked
            ? data.currentVideoLikeCount - 1
            : data.currentVideoLikeCount + 1,
      ));
    });

    Logger().d('New like status: ${state.value?.currentVideoLiked}');
    Logger().d('New unlike status: ${state.value?.currentVideoUnliked}');
  }

  void unlikeVideo() {
    Logger().d('unlikeVideo');
    state.whenData((data) {
      state = AsyncValue.data(data.copyWith(
        currentVideoLiked: false,
        currentVideoUnliked: !data.currentVideoUnliked,
        currentVideoLikeCount:
            (!data.currentVideoUnliked && data.currentVideoLiked)
                ? data.currentVideoLikeCount - 1
                : data.currentVideoLikeCount,
      ));
    });
    Logger().d('New like status: ${state.value?.currentVideoLiked}');
    Logger().d('New unlike status: ${state.value?.currentVideoUnliked}');
  }

  void updateLikeStatus() {
    state.whenData((data) {
      final currentVideoLiked = data.videosLikeStatus[data.currentIndex];
      final currentVideoUnliked = data.videosUnlikeStatus[data.currentIndex];
      final currentVideoLikeCount = data.videos[data.currentIndex].likes;

      state = AsyncValue.data(data.copyWith(
        currentVideoLiked: currentVideoLiked,
        currentVideoUnliked: currentVideoUnliked,
        currentVideoLikeCount: currentVideoLikeCount,
      ));
    });
  }

  Future<void> onFeedIndexChanged(int newIndex) async {
    state.whenData((data) async {
      final updatedLiked = List<bool>.from(data.videosLikeStatus);
      final updatedUnliked = List<bool>.from(data.videosUnlikeStatus);

      // check if the video like status hasn't changed
      if (data.currentVideoLiked == data.videosLikeStatus[data.currentIndex]) {
        setCurrentVideo(newIndex);
        updateLikeStatus();
        return;
      }

      Logger().d('Updating like status for video ${data.videos[data.currentIndex].id}');

      var response = (data.currentVideoLiked)
          ? await _remoteApiService.likeVideo(
              user.id, data.videos[data.currentIndex].id)
          : await _remoteApiService.unlikeVideo(
              user.id, data.videos[data.currentIndex].id);

      // if the request fails, revert the video index
      if (!response) {
        Logger().e('Failed to update like status');
        setCurrentVideo(newIndex);
        updateLikeStatus();
        return;
      }

      Logger().d('Like status updated successfully');
      updatedLiked[data.currentIndex] = data.currentVideoLiked;
      updatedUnliked[data.currentIndex] = data.currentVideoUnliked;

      // update new likes for current video
      final newVideo = data.videos[data.currentIndex].copyWith(
          likes: data.currentVideoLikeCount);
      final updatedVideos = List<FeedVideo>.from(data.videos);
      updatedVideos[data.currentIndex] = newVideo;

      final nextVideoLiked = data.videosLikeStatus[newIndex];
      final nextVideoUnliked = data.videosUnlikeStatus[newIndex];
      final nextVideoLikeCount = data.videos[newIndex].likes;

      state = AsyncValue.data(data.copyWith(
        videos: updatedVideos,
        likeStatus: updatedLiked,
        unlikeStatus: updatedUnliked,
        previousIndex: data.currentIndex,
        currentIndex: newIndex,
        currentVideoLiked: nextVideoLiked,
        currentVideoUnliked: nextVideoUnliked,
        currentVideoLikeCount: nextVideoLikeCount,
      ));
    });
  }

  void setCurrentVideo(int index) {
    // pause the previous video
    state.whenData((data) {
      state = AsyncValue.data(data.copyWith(
        previousIndex: data.currentIndex,
        currentIndex: index,
      ));
    });
  }

  Future<void> setShowCommentStatus(bool status) async {
    state.whenData((data) async {
      state = AsyncValue.data(data.copyWith(isShowingComments: status));
    });
  }

  VideoPlayerController? getControllerForVideo(String videoUrl) {
    if (videoControllers.containsKey(videoUrl)) {
      return videoControllers[videoUrl];
    }

    return null;
  }

  Future<VideoPlayerController> initializeController(String videoUrl) async {
    if (videoControllers.containsKey(videoUrl)) {
      return videoControllers[videoUrl]!;
    }

    Logger().d('Initializing controller for $videoUrl');
    final controller = VideoPlayerController.network(videoUrl);
    await controller.initialize();
    videoControllers[videoUrl] = controller;
    Logger().d('Controller initialized for $videoUrl');

    return controller;
  }

  void disposeController(String videoUrl) {
    final controller = videoControllers[videoUrl];
    controller?.dispose();
  }

  @override
  void dispose() {
    super.dispose();
    for (var controller in videoControllers.values) {
      controller.dispose();
    }

    videoControllers.clear();
    super.dispose();
  }
}

class VideoControllerNotifier
    extends StateNotifier<AsyncValue<VideoPlayerController>> {
  final String videoUrl;

  VideoControllerNotifier(this.videoUrl) : super(const AsyncValue.loading()) {
    _initializeController();
  }

  Future<void> _initializeController() async {
    try {
      final controller = VideoPlayerController.network(videoUrl);
      await controller.initialize();
      state = AsyncValue.data(controller);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  @override
  void dispose() {
    state.whenData((controller) => controller.dispose());
    super.dispose();
  }
}
