import 'package:get_thumbnail_video/video_thumbnail.dart';

class CreatePostState {
  final String videoFilePath;
  final bool isPickingVideo;
  final bool isUploading;

  CreatePostState({
    required this.videoFilePath,
    required this.isPickingVideo,
    required this.isUploading,
  });

  factory CreatePostState.empty() {
    return CreatePostState(
      videoFilePath: '',
      isPickingVideo: false,
      isUploading: false,
    );
  }

  CreatePostState copyWith({
    String? videoFilePath,
    bool? isPickingVideo,
    bool? isUploading,
  }) {
    return CreatePostState(
      videoFilePath: videoFilePath ?? this.videoFilePath,
      isPickingVideo: isPickingVideo ?? this.isPickingVideo,
      isUploading: isUploading ?? this.isUploading,
    );
  }
}