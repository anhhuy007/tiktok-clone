import 'package:tiktok_clone/presentation/home/home_page/models/feed_video.dart';
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
}