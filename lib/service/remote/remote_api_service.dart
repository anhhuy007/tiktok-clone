import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:tiktok_clone/presentation/home/home_page/models/comment.dart';
import 'package:tiktok_clone/presentation/home/home_page/models/feed_video.dart';
import 'package:tiktok_clone/presentation/profile/profile_page/models/profile_item_model.dart';
import 'package:tiktok_clone/presentation/profile/profile_page_container/models/profile_page_container_model.dart';
import 'package:tiktok_clone/presentation/profile/profile_page/models/profile_page_model.dart';
import 'package:dio/dio.dart';
import 'package:tiktok_clone/service/endpoints.dart';

import '../../presentation/authentication/models/error_data.dart';
import '../../presentation/authentication/models/user_data.dart';

class RemoteApiService {
  final Dio _dio;

  RemoteApiService() : _dio = Dio() {
    _dio.options.baseUrl = baseRemoteUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  @override
  Future<dynamic> login(UserLoginRequest req) async {
    try {
      final response = await _dio.post(
        loginUrl,
        data: req.toJson(),
      );

      Logger().d("Response: ${response.data}");

      return UserResponse.fromJson(response.data);
    } on DioError catch (e) {
      Logger().e("Error: ${e.response?.data}");
      return ErrorResponse.fromJson(e.response?.data);
    }
  }

  @override
  Future<dynamic> signup(UserSignupRequest req) async {
    Logger().d("Request: ${req.toJson()}");

    try {
      final response = await _dio.post(
        signupUrl,
        data: req.toJson(),
      );

      Logger().d("Response: ${response.data}");

      return response;
    } on DioError catch (e) {
      Logger().e("Error: ${e.response!.data}");
      return ErrorResponse.fromJson(e.response!.data);
    }
  }

  @override
  Future<dynamic> logout() async {
    try {
      final response = await _dio.get(
        logoutUrl,
      );

      Logger().d("Response: ${response.data}");

      return response;
    } on DioError catch (e) {
      Logger().e("Error: ${e.response!.data}");
      return ErrorResponse.fromJson(e.response!.data);
    }
  }

  Future<List<FeedVideo>> loadVideos({int limit = 1}) async {
    try {
      final response = await _dio.get(feedVideosUrl);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => FeedVideo.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to load videos',
        );
      }
    } on DioException catch (err) {
      throw Exception('Failed to load videos: ${err.message}');
    }
  }

  Future<ProfilePageContainerModel> loadProfile(
      {required int profileId}) async {
    try {
      final response =
          await _dio.get("$profileInfoUrl/${profileId.toString()}");
      if (response.statusCode == 200) {
        return ProfilePageContainerModel.fromJson(response.data["data"][0]);
      } else {
        throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: 'Failed to get profile info');
      }
    } on DioException catch (err) {
      throw Exception('Failed to get profile info: ${err.message}');
    }
  }

  Future<ProfileModel> loadPopularVideos({required int userId}) async {
    try {
      final response = await _dio.get("$popularVideosUrl/${userId.toString()}");
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data["data"];
        final result = ProfileModel(
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

  Future<ProfileModel> loadLatestVideos({required int userId}) async {
    try {
      final response = await _dio.get("$latestVideosUrl/${userId.toString()}");
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data["data"];
        final result = ProfileModel(
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

  Future<ProfileModel> loadOldestVideos({required int userId}) async {
    try {
      final response = await _dio.get("$oldestVideosUrl/${userId.toString()}");
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data["data"];
        final result = ProfileModel(
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

  Future<bool> getFollowStatus(
      {required int followerId, required int followingId}) async {
    try {
      final response = await _dio.get("$followStatusUrl",
          data: {"follower_id": followerId, "following_id": followingId});
      if (response.statusCode == 200) {
        final result = response.data["data"]["followed"];
        return result;
      } else {
        throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: "Failed to get follow status");
      }
    } on DioException catch (err) {
      throw Exception('Failed to get follow status: ${err.message}');
    }
  }

  Future<bool> followUser(
      {required int followerId, required int followingId}) async {
    try {
      final response = await _dio.post("$followUrl",
          data: {"follower_id": followerId, "following_id": followingId});
      if (response.statusCode == 200) {
        return true;
      }
      else {
        throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: 'Failed to follow user');
      }
    } on DioException catch (err) {
      throw Exception('Failed to follow user: ${err.message}');
    }
  }

  Future<bool> unfollowUser(
      {required int followerId, required int followingId}) async {
    try {
      final response = await _dio.post("$unfollowUrl",
          data: {"follower_id": followerId, "following_id": followingId});
      if (response.statusCode == 200) {
        return true;
      }
      else {
        throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: 'Failed to unfollow user');
      }
    } on DioException catch (err) {
      throw Exception('Failed to unfollow user: ${err.message}');
    }
  }

  Future<List<bool>> getLikedVideos(int userId, List<FeedVideo> videos) async {
    try {
      // get current user id from shared preferences
      const userid = '1';
      final List<bool> likedVideos = [];
      Logger().d(
          'Getting liked videos for user id: $userId for ${videos.length} videos');
      for (var vid in videos) {
        final response = await _dio.post(likeVideoStatusUrl, data: {
          'video_id': vid.id.toString(),
          'liker_id': userid.toString(),
        });
        if (response.statusCode == 200) {
          Logger().d('Liked videos response: ${response.data}');
          var data = response.data['data'];
          likedVideos.add(data['liked']);
        } else {
          likedVideos.add(false);
          throw Exception('Failed to get liked videos');
        }
      }

      return likedVideos;
    } on DioException catch (err) {
      throw Exception('Failed to get liked videos: ${err.message}');
    }
  }

  Future<bool> likeVideo(int userId, int videoId) async {
    try {
      final response = await _dio.post(likeVideoUrl, data: {
        'video_id': videoId.toString(),
        'liker_id': userId.toString(),
      });
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
      final response = await _dio.post(unlikeVideoUrl, data: {
        'video_id': videoId.toString(),
        'liker_id': userId.toString(),
      });
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
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to load comments',
        );
      }
    } on DioException catch (err) {
      throw Exception('Failed to load comments: ${err.message}');
    }
  }

  Future<List<Comment>> uploadComment(int videoId, String content, int commenterId) async {
    try {
      final response = await _dio.post(postCommentUrl, data: {
        'video_id': videoId,
        'content': content,
        'commenter_id': commenterId,
      });
      if (response.statusCode == 200) {
        Logger().d('Comment uploaded successfully');
        final List<dynamic> data = response.data['data'];
        return data.map((json) => Comment.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to upload comment',
        );
      }
    } on DioException catch (err) {
      throw Exception('Failed to upload comment: ${err.message}');
    }
  }
}
