import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiktok_clone/presentation/authentication/models/auth_state.dart';

import '../models/user_data.dart';

const IS_AUTHENTICATED = 'is_authenticated';
const AUTHENTICATED_USER_EMAIL = 'authenticated_user_email';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(isAuthenticated: false));

  Future<void> loadAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    final isAuthenticated = prefs.getBool(IS_AUTHENTICATED) ?? false;
    final userJson = prefs.getString(AUTHENTICATED_USER_EMAIL);
    final user = userJson != null ? UserModel.fromJson(jsonDecode(userJson)) : null;

    state = AuthState(isAuthenticated: isAuthenticated, user: user);
  }

  Future<void> setAuthState(bool isAuthenticated, UserModel? user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(IS_AUTHENTICATED, isAuthenticated);
    if (user != null) {
      await prefs.setString(AUTHENTICATED_USER_EMAIL, jsonEncode(user));
    } else {
      await prefs.remove(AUTHENTICATED_USER_EMAIL);
    }

    state = AuthState(isAuthenticated: isAuthenticated, user: user);
  }

  Future<void> resetAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    state = AuthState(isAuthenticated: false, user: null);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
      (ref) => AuthNotifier(),
);