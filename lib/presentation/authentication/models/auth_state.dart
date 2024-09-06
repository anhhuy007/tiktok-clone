import 'package:tiktok_clone/presentation/authentication/models/user_data.dart';

class AuthState {
  final bool isAuthenticated;
  final UserModel? user;

  AuthState({required this.isAuthenticated, this.user});
}