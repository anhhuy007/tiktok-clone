import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/presentation/authentication/models/error_data.dart';
import 'package:tiktok_clone/presentation/authentication/models/user_data.dart';

import '../../../service/remote/remote_api_service.dart';
import 'auth_notifier.dart';

class UserController extends StateNotifier<AsyncValue<dynamic>> {
  Ref ref;
  final RemoteApiService _remoteApiService;

  UserController(
    this._remoteApiService,
    this.ref,
  ) : super(const AsyncData(null));

  Future<Either<String, bool>> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    UserLoginRequest userRequest = UserLoginRequest(
      email: email,
      password: password,
    );
    final response = await _remoteApiService.login(userRequest);
    if (response is ErrorResponse) {
      return Left(response.error);
    } else {
      ref.read(authNotifierProvider.notifier).setAuthState(
            true,
            response.user,
          );

      return const Right(true);
    }
  }

  Future<Either<String, bool>> signup(
      {required String email,
      required String password,
      required String username,
      required String fullname}) async {
    state = const AsyncLoading();

    UserSignupRequest userRequest = UserSignupRequest(
      email: email,
      password: password,
      username: username,
      fullname: fullname,
    );

    final response = await _remoteApiService.signup(userRequest);

    if (response is ErrorResponse) {
      return Left(response.error);
    }

    return const Right(true);
  }
}

final userControllerProvider =
    StateNotifierProvider<UserController, AsyncValue<dynamic>>((ref) {
  final remoteApiService = RemoteApiService();
  return UserController(remoteApiService, ref);
});
