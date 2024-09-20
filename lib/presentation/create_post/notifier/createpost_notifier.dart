import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:tiktok_clone/presentation/authentication/models/user_data.dart';
import 'package:tiktok_clone/presentation/authentication/notifiers/auth_notifier.dart';
import 'package:tiktok_clone/presentation/create_post/model/createpost_state.dart';
import 'package:tiktok_clone/service/remote_api_service.dart';

import '../../reels/notifiers/feed_providers.dart';

class CreatePostNotifier extends StateNotifier<CreatePostState> {
  final firebaseStorage = FirebaseStorage.instance;
  final RemoteApiService apiService;
  final UserModel user;

  CreatePostNotifier({required this.apiService, required this.user})
      : super(CreatePostState.empty());

  Future<void> setPickVideoStatus(bool isPickingVideo) async {
    state = state.copyWith(isPickingVideo: isPickingVideo);
  }

  Future<void> pickVideo() async {
    try {
      final ImagePicker videoPicker = ImagePicker();
      final XFile? video =
          await videoPicker.pickVideo(source: ImageSource.gallery);

      state = state.copyWith(isPickingVideo: true);

      if (video == null) {
        state = state.copyWith(isPickingVideo: false);
        return;
      }

      state = state.copyWith(videoFilePath: video.path);
    } catch (e) {
      state = state.copyWith(isPickingVideo: false);
      Logger().e(e);
    }
  }

  Future<bool> uploadVideo(String title, String hashtags, String song) async {
    state = state.copyWith(isUploading: true);
    try {
      final videoFile = File(state.videoFilePath);

      // string length 10 characters from current time in milliseconds
      String filePath = 'video/${DateTime.now()}.mp4';
      await firebaseStorage.ref(filePath).putFile(videoFile);

      String downloadURL = await firebaseStorage.ref(filePath).getDownloadURL();
      title = '$title $hashtags';
      final result = await apiService.uploadPost(
          channelId: user.id, videoUrl: downloadURL, title: title, song: song);
      state = state.copyWith(isUploading: false);

      return result;
    } catch (e) {
      state = state.copyWith(isUploading: false);
      Logger().e(e);

      return false;
    }
  }

  void removeVideo() {
    state = state.copyWith(videoFilePath: '', isPickingVideo: false);
  }
}

final createPostProvider =
    StateNotifierProvider<CreatePostNotifier, CreatePostState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final user = ref.read(authProvider).user;
  return CreatePostNotifier(
      apiService: apiService, user: user ?? UserModel.empty());
});
