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

  Future<ProfilePageContainerModel> loadProfile({required int userId}) async {
    try{
      final response = await _dio.get("$profileInfoUrl/${userId.toString()}");
      if(response.statusCode == 200) {
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