import 'package:tiktok_clone/presentation/home/home_page/models/feed_video.dart';
import 'package:tiktok_clone/presentation/profile/profile_page/models/profile_item_model.dart';
import 'package:tiktok_clone/presentation/profile/profile_page_container/models/profile_page_container_model.dart';
import 'package:tiktok_clone/presentation/profile/profile_page/models/profile_page_model.dart';
import 'package:dio/dio.dart';
import 'package:tiktok_clone/service/endpoints.dart';

class RemoteApiService {
  final Dio _dio;

  RemoteApiService() : _dio = Dio() {
    _dio.options.baseUrl = baseLocalUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  Future<List<FeedVideo>> loadVideos({int limit = 1}) async {
    try {
      final response = await _dio.get(feedVideosUrl);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => FeedVideo.fromJson(json)).toList();
      }
      else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to load videos',
        );
      }
    } on DioException catch(err) {
      throw Exception('Failed to load videos: ${err.message}');
    }
  }

<<<<<<< Updated upstream
  Future<ProfilePageContainerModel> loadProfile({required int userId}) async {
    try{
      final response = await _dio.get("$profileInfoUrl/${userId.toString()}");
<<<<<<< HEAD
<<<<<<< HEAD
      if (response.statusCode == 200) {
=======
  Future<ProfilePageContainerModel> loadProfile({required int profileId}) async {
    try{
      final response = await _dio.get("$profileInfoUrl/${profileId.toString()}");
      if(response.statusCode == 200) {
>>>>>>> Stashed changes
=======
      if(response.statusCode == 200) {
>>>>>>> parent of 010ad7a (feat: add like and comment notifier)
=======
      if(response.statusCode == 200) {
>>>>>>> parent of 010ad7a (feat: add like and comment notifier)
        return ProfilePageContainerModel.fromJson(response.data["data"][0]);
      }
      else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to get profile info'
        );
      }
    } on DioException catch(err) {
      throw Exception('Failed to get profile info: ${err.message}');
    }
  }
  
  Future<ProfileModel> loadPopularVideos({required int userId}) async {
    try{
      final response = await _dio.get("$popularVideosUrl/${userId.toString()}");
      if(response.statusCode == 200) {
        final List<dynamic> data = response.data["data"];
        final result = ProfileModel(
          profileItemList: data.map((json) => ProfileItemModel.fromJson(json))
              .toList()
        );
        return result;
      }
      else {
        throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: 'Failed to get popular videos'
        );
      }
    } on DioException catch(err) {
      throw Exception('Failed to get popular videos: ${err.message}');
    }
  }

  Future<ProfileModel> loadLatestVideos({required int userId}) async {
    try{
      final response = await _dio.get("$latestVideosUrl/${userId.toString()}");
      if(response.statusCode == 200) {
        final List<dynamic> data = response.data["data"];
        final result = ProfileModel(
            profileItemList: data.map((json) => ProfileItemModel.fromJson(json))
                .toList()
        );
        return result;
      }
      else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to get popular videos'
        );
      }
    } on DioException catch(err) {
      throw Exception('Failed to get popular videos: ${err.message}');
    }
  }

  Future<ProfileModel> loadOldestVideos({required int userId}) async {
    try{
      final response = await _dio.get("$oldestVideosUrl/${userId.toString()}");
      if(response.statusCode == 200) {
        final List<dynamic> data = response.data["data"];
        final result = ProfileModel(
<<<<<<< HEAD
<<<<<<< HEAD
            profileItemList:
                data.map((json) => ProfileItemModel.fromJson(json)).toList());
        return result;
      } else {
        throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: 'Failed to get popular videos');
      }
    } on DioException catch (err) {
      throw Exception('Failed to get popular videos: ${err.message}');
    }
  }

<<<<<<< Updated upstream
  Future<List<bool>> getLikedVideos(int userId, List<FeedVideo> videos) async {
    try {
      // get current user id from shared preferences
      const userid = '1';
      final List<bool> likedVideos = [];
      Logger().d('Getting liked videos for user id: $userId for ${videos.length} videos');
      for (var vid in videos) {
        final response = await _dio.post(
            likeVideoStatusUrl,
            data: {
              'video_id': vid.id.toString(),
              'liker_id': userid.toString(),
            }
=======
            profileItemList: data.map((json) => ProfileItemModel.fromJson(json))
                .toList()
>>>>>>> parent of 010ad7a (feat: add like and comment notifier)
        );
        return result;
      }
<<<<<<< HEAD

      return likedVideos;
    } on DioException catch (err) {
      throw Exception('Failed to get liked videos: ${err.message}');
    }
  }

  Future<bool> likeVideo(int userId, int videoId) async {
    try {
      final response = await _dio.post(
          likeVideoUrl,
          data: {
            'video_id': videoId.toString(),
            'liker_id': userId.toString(),
          }
      );
      if (response.statusCode == 200) {
        Logger().d('Liked video response: ${response.data}');
        return true;
      } else {
        throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: 'Failed to like video');
      }
    } on DioException catch (err) {
      throw Exception('Failed to like video: ${err.message}');
    }
  }

  Future<bool> unlikeVideo(int userId, int videoId) async {
    try {
      final response = await _dio.post(
          unlikeVideoUrl,
          data: {
            'video_id': videoId.toString(),
            'liker_id': userId.toString(),
          }
      );
      if (response.statusCode == 200) {
        Logger().d('Unliked video response: ${response.data}');
        return true;
      } else {
        throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: 'Failed to unlike video');
      }
    } on DioException catch (err) {
      throw Exception('Failed to unlike video: ${err.message}');
    }
  }

  Future<List<Comment>> loadComments(int videoId) async {
    try {
      final response = await _dio.get("$fetchCommentsUrl/$videoId");
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => Comment.fromJson(json)).toList();
=======
  Future<bool> getFollowStatus({required int followerId, required int followingId}) async {
    try {
      final response = await _dio.get("$followStatusUrl", queryParameters: {"follower_id": followerId, "following_id": followingId});
      if(response.statusCode == 200) {
        final result = response.data["data"]["followed"];
        return result;
>>>>>>> Stashed changes
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
<<<<<<< Updated upstream
          error: 'Failed to load comments',
=======
      else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to get popular videos'
>>>>>>> parent of 010ad7a (feat: add like and comment notifier)
        );
      }
    } on DioException catch(err) {
      throw Exception('Failed to get popular videos: ${err.message}');
    }
  }
<<<<<<< HEAD
}
=======
          error: "Failed to get follow status"
        );
      }
    } on DioException catch (err) {
      throw Exception ('Failed to get follow status: ${err.message}');
    }
  }
}
>>>>>>> Stashed changes
=======
}
>>>>>>> parent of 010ad7a (feat: add like and comment notifier)
=======
            profileItemList: data.map((json) => ProfileItemModel.fromJson(json))
                .toList()
        );
        return result;
      }
      else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to get popular videos'
        );
      }
    } on DioException catch(err) {
      throw Exception('Failed to get popular videos: ${err.message}');
    }
  }
}
>>>>>>> parent of 010ad7a (feat: add like and comment notifier)
