import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:tiktok_clone/presentation/authentication/data/error_data.dart';
import 'package:tiktok_clone/presentation/authentication/data/user_data.dart';
import 'package:tiktok_clone/service/endpoints.dart';

abstract class UserRepo {
  Future<dynamic> login(UserLoginRequest req);
  Future<dynamic> signup(UserSignupRequest req);
}

class UserRepoImpl implements UserRepo {
  late Dio _dio;

  UserRepoImpl() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseLocalUrl,
        connectTimeout: const Duration(seconds: 5000),
        receiveTimeout: const Duration(seconds: 3000),
      ),
    );
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
}

final userRepoProvider = Provider<UserRepoImpl>((ref) {
  return UserRepoImpl();
});