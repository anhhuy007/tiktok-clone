import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:tiktok_clone/presentation/profile/profile_page/models/profile_item_model.dart';
import 'package:tiktok_clone/presentation/profile/profile_page_container/models/profile_page_container_model.dart';
import 'package:tiktok_clone/presentation/profile/profile_page/models/profile_page_model.dart';
import 'package:dio/dio.dart';
import 'package:tiktok_clone/presentation/search/models/searching_item.dart';
import 'package:tiktok_clone/presentation/search/models/user_info.dart';
import 'package:tiktok_clone/service/endpoints.dart';
import '../presentation/authentication/models/error_data.dart';
import '../presentation/authentication/models/user_data.dart';
import '../presentation/reels/models/comment.dart';
import '../presentation/reels/models/feed_video.dart';

class RemoteApiService {
  final Dio _dio;

  RemoteApiService() : _dio = Dio() {
    _dio.options.baseUrl = baseLocalUrl;
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
      } else {
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
      } else {
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

  Future<List<Comment>> uploadComment(
      int videoId, String content, int commenterId) async {
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

  Future<List<FeedVideo>> fetchSuggestedVideos(int limit) async {
    try {
      final response = await _dio.get(suggestedVideosUrl + limit.toString());
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        Logger().d('Suggested videos: ${response.data}');
        return data.map((json) => FeedVideo.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to fetch suggested videos',
        );
      }
    } on DioException catch (err) {
      throw Exception('Failed to fetch suggested videos: ${err.message}');
    }
  }

  Future<List<SearchItem>> fetchSearchHistoryItems(int userId) async {
    try {
      final response = await _dio.get(searchHistoryUrl + userId.toString());
      if (response.statusCode == 200) {
        Logger().d('Search history items: ${response.data}');
        final List<dynamic> data = response.data['data'];

        //   get user info if user exists
        for (var item in data) {
          item['searchQuery'] = item['search_query'];
          if (item['searched_user_id'] == null) {
            continue;
          }

          final userId = item['searched_user_id'];
          final userResponse = await _dio.get("$searchUserUrl/$userId");
          Logger().d('User response: ${userResponse.data}');
          if (userResponse.statusCode == 200) {
            final userInfo = UserInfo.fromJson(userResponse.data['data']);
            item['userId'] = userInfo.userId;
            item['name'] = userInfo.name;
            item['handle'] = userInfo.handle;
            item['avatarUrl'] = userInfo.avatarUrl;
            item['followers'] = userInfo.follower;
          }
        }

        final searchItems =
            data.map((json) => SearchItem.fromJson(json)).toList();
        for (var item in searchItems) {
          Logger().d('Search item: ${item.searchQuery}');
        }
        return searchItems;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to fetch search history items',
        );
      }
    } on DioException catch (err) {
      throw Exception('Failed to fetch search history items: ${err.message}');
    }
  }

  Future<List<SearchItem>> search(String query) async {
    try {
      final response = await _dio.get(searchUrl + query);
      if (response.statusCode == 200) {
        Logger().d('Search response: ${response.data}');
        final List<dynamic> data = response.data['data'];
        final userInfos = data.map((json) => UserInfo.fromJson(json)).toList();
        final result = userInfos
            .map((userInfo) => SearchItem(
                  id: 0,
                  userId: userInfo.userId,
                  name: userInfo.name,
                  handle: userInfo.handle,
                  avatarUrl: userInfo.avatarUrl,
                  followers: userInfo.follower,
                  searchQuery: query,
                ))
            .toList();
        return result;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to fetch users',
        );
      }
    } on DioException catch (err) {
      throw Exception('Failed to fetch users: ${err.message}');
    }
  }

  Future<void> postSearchHistoryItem(
      int userId, String searchQuery, int? searchedUserId) async {
    try {
      final response = await _dio.post(searchHistoryUrl, data: {
        'userId': userId,
        'searchQuery': searchQuery,
        'searchedUserId': searchedUserId
      });
      if (response.statusCode == 200) {
        Logger().d('Search history item posted successfully');
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to post search history item',
        );
      }
    } on DioException catch (err) {
      throw Exception('Failed to post search history item: ${err.message}');
    }
  }

  Future<void> deleteSearchHistoryItem(int searchId) async {
    try {
      final response = await _dio.delete(searchHistoryUrl + searchId.toString());
      if (response.statusCode == 200) {
        Logger().d('Search history item deleted successfully');
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to delete search history item',
        );
      }
    } on DioException catch (err) {
      throw Exception('Failed to delete search history item: ${err.message}');
    }
  }

  Future<bool> uploadPost(
      {required int channelId,
      required String title,
      required String song,
      required String videoUrl}) async {
    try {
      const randomThumbnailUrls = [
        "https://i.ytimg.com/vi/9bZkp7q19f0/hqdefault.jpg",
        "https://p16-capcut-sign-va.ibyteimg.com/tos-maliva-i-kosjp4qvy4-us/30c972eff98c46fe973d633a19a69031~tplv-nhvfeczskr-1:900:0.webp?lk3s=35090df9&x-expires=1752670818&x-signature=7YLDueRQx3UwKyF7KVR5LKIsYlU%3D",
        "https://p16-capcut-sign-va.ibyteimg.com/tos-maliva-i-kosjp4qvy4-us/57c72a59027e42179e02b23322f9a4af~tplv-nhvfeczskr-1:900:0.webp?lk3s=35090df9&x-expires=1754111110&x-signature=URiINHgjtsUm2gJiNilOEI3Rztc%3D",
        "https://img.freepik.com/premium-vector/lombok-indonesia-oktober-11-2022-follow-us-tiktok-social-vertical-media-banner-with-dynamic-circle-logo_343173-52.jpg?w=360",
        "https://i.pinimg.com/474x/f1/f1/e5/f1f1e5d6ed548f0b60372a245d36f8da.jpg",
        "https://i.pinimg.com/736x/cc/f6/f1/ccf6f123d40ce1d70e95e008bf3eb3eb.jpg"
      ];
      int randomIndex = Random().nextInt(randomThumbnailUrls.length);

      final response = await _dio.post(uploadPostUrl, data: {
        'channelId': channelId,
        'title': title,
        'song': song,
        'videoUrl': videoUrl,
        'thumbnailUrl': randomThumbnailUrls[randomIndex],
      });
      if (response.statusCode == 200) {
        Logger().d('Post uploaded successfully');
        return true;
      } else {
        return false;
      }
    } on DioException catch (err) {
      throw Exception('Failed to upload post: ${err.message}');
    }
  }
}
