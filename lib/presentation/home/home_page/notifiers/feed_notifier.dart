import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/presentation/home/home_page/models/feed_model.dart';
import 'package:tiktok_clone/presentation/home/home_page/models/feed_video.dart';
import 'package:video_player/video_player.dart';

import '../../../../service/remote/remote_api_service.dart';
import 'package:logger/logger.dart';

class FeedNotifier extends StateNotifier<AsyncValue<FeedModel>> {

  final RemoteApiService _remoteApiService;
  final Map<String, VideoPlayerController> videoControllers = {};

  FeedNotifier(this._remoteApiService) : super(const AsyncValue.loading()) {
    Logger().d('FeedNotifier created', );
    fetchFeedVideos();
  }

  Future<void> fetchFeedVideos() async {
    state = const AsyncValue.loading();

    try {
      Logger().d('Loading videos...');
      final videos = await _remoteApiService.loadVideos();
      Logger().d('Videos loaded: ${videos.length}');
      state = AsyncValue.data(FeedModel(videos: videos, currentIndex: 0, previousIndex: -1));
    }
    catch (e, stackTrace) {
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

      state = AsyncValue.data(FeedModel(videos: updatedVideos, previousIndex: previousIndex, currentIndex: currentIndex));
    }
    catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
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