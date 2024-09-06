import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:tiktok_clone/presentation/home/home_page/models/comment.dart';
import 'package:tiktok_clone/service/remote/remote_api_service.dart';

class CommentNotifier extends StateNotifier<AsyncValue<List<Comment>>> {
  final RemoteApiService _apiService;

  CommentNotifier(this._apiService) : super(const AsyncValue.loading());

  Future<void> loadComments(int videoId) async {
    Logger().d('Loading comments...');
    state = const AsyncValue.loading();
    // fetch comments from the server
    final comments = await _apiService.loadComments(videoId);
    state = AsyncValue.data(comments);
  }

  void clearComments() {
    state = const AsyncValue.loading();
  }
}