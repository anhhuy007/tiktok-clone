import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:tiktok_clone/presentation/home/home_page/models/feed_model.dart';
import 'package:tiktok_clone/presentation/home/home_page/notifiers/feed_notifier.dart';
import 'package:video_player/video_player.dart';
import '../../../../service/remote/remote_api_service.dart';
import '../models/feed_video.dart';

final apiServiceProvider = Provider<RemoteApiService>((ref) => RemoteApiService());

final feedProvider = StateNotifierProvider<FeedNotifier, AsyncValue<FeedModel>>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return FeedNotifier(apiService);
});

final currentVideoProvider = Provider<FeedVideo?>((ref) {
  final feedState = ref.watch(feedProvider);
  return feedState.when(
    data: (obj) => obj.videos[obj.currentIndex],
    loading: () => null,
    error: (_, __) => null,
  );
});

final videoControllerProvider = StateNotifierProvider.family<VideoControllerNotifier, AsyncValue<VideoPlayerController>, String>(
      (ref, videoUrl) => VideoControllerNotifier(videoUrl),
);

class VideoControllerNotifier extends StateNotifier<AsyncValue<VideoPlayerController>> {
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