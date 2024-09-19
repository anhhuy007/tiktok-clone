import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:tiktok_clone/presentation/authentication/models/user_data.dart';
import 'package:tiktok_clone/presentation/home/home_page/models/comment.dart';
import 'package:tiktok_clone/service/remote_api_service.dart';

class CommentNotifier extends StateNotifier<AsyncValue<List<Comment>>> {
  final RemoteApiService _apiService;
  UserModel user;

  CommentNotifier(this._apiService, this.user) : super(const AsyncValue.loading());

  Future<void> loadComments(int videoId) async {
    Logger().d('Loading comments...');
    state = const AsyncValue.loading();
    // fetch comments from the server
    final comments = await _apiService.loadComments(videoId);
    state = AsyncValue.data(comments);
  }

  Future<void> addComment(int videoId, String content) async {
    try {
      Logger().d('Adding comment...');
      final currentComment = state.value;
      state = const AsyncValue.loading();
      // add comment to the server
      final newComment = await _apiService.uploadComment(
        videoId,
        content,
        user.id,
      );

      // concat new comment to the existing comments
      final List<Comment> updatedComments = currentComment! + newComment;
      state = AsyncValue.data(updatedComments);
    }
    catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      Logger().e('Failed to add comment', error: e);
    }
  }

  void clearComments() {
    state = const AsyncValue.loading();
  }
}