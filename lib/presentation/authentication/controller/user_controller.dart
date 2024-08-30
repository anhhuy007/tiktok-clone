import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/presentation/authentication/data/error_data.dart';
import 'package:tiktok_clone/presentation/authentication/data/user_data.dart';
import 'package:tiktok_clone/presentation/authentication/repo/auth_repo.dart';
import 'package:tiktok_clone/presentation/authentication/repo/user_repo.dart';

class UserController extends StateNotifier<AsyncValue<dynamic>> {
  Ref ref;

  UserController({
    required this.ref,
  }) : super(const AsyncData(null));

  Future<Either<String, bool>> login({
    required String email,
    required String password,
}) async {
    state = const AsyncLoading();

    UserLoginRequest userRequest = UserLoginRequest(
        email: email,
        password: password,
    );
    final response = await ref.read(userRepoProvider).login(userRequest);
    if (response is ErrorResponse) {
      return Left(response.error);
    }
    else {
      ref.read(setAuthStateProvider.notifier).state = response;
      ref.read(setIsAuthenticatedProvider(true));
      ref.read(setAuthenticatedUserProvider(response.user));

      return const Right(true);
    }
  }

  Future<Either<String, bool>> signup({
    required String email,
    required String password,
    required String username,
    required String fullname
}) async {
    state = const AsyncLoading();

    UserSignupRequest userRequest = UserSignupRequest(
        email: email,
        password: password,
        username: username,
        fullname: fullname,
    );

    final response = await ref.read(userRepoProvider).signup(userRequest);

    if (response is ErrorResponse) {
      return Left(response.error);
    }

    return const Right(true);
  }
}

final userControllerProvider = StateNotifierProvider<UserController, AsyncValue<dynamic>>((ref) {
  return UserController(ref: ref);
});












