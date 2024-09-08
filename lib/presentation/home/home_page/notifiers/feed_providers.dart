import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/presentation/authentication/models/user_data.dart';
import 'package:tiktok_clone/presentation/home/home_page/models/feed_model.dart';
import 'package:tiktok_clone/presentation/home/home_page/notifiers/comment_notifier.dart';
import 'package:tiktok_clone/presentation/home/home_page/notifiers/feed_notifier.dart';
import 'package:video_player/video_player.dart';
import '../../../../service/remote/remote_api_service.dart';
import '../../../authentication/notifiers/auth_notifier.dart';
import '../models/comment.dart';

final apiServiceProvider =
    Provider<RemoteApiService>((ref) => RemoteApiService());

final feedProvider =
    StateNotifierProvider<FeedNotifier, AsyncValue<FeedModel>>((ref) {
  final user = ref.read(authNotifierProvider).user;
  final apiService = ref.watch(apiServiceProvider);
  return FeedNotifier(user ?? UserModel.empty(), apiService);
});

final videoControllerProvider = StateNotifierProvider.family<
    VideoControllerNotifier, AsyncValue<VideoPlayerController>, String>(
  (ref, videoUrl) => VideoControllerNotifier(videoUrl),
);

final commentProvider = StateNotifierProvider<CommentNotifier, AsyncValue<List<Comment>>>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final user = ref.read(authNotifierProvider).user;
  return CommentNotifier(apiService, user ?? UserModel.empty());
});
