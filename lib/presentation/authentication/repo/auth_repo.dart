import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiktok_clone/presentation/authentication/data/user_data.dart';

const IS_AUTHENTICATED = 'is_authenticated';
const AUTHENTICATED_USER_EMAIL = 'authenticated_user_email';

final sharedPrefProvider = Provider((_) async {
  return await SharedPreferences.getInstance();
});

final setAuthStateProvider = StateProvider<UserResponse?>(
  (ref) => null,
);

final setIsAuthenticatedProvider =
    StateProvider.family<void, bool>((ref, isAuth) async {
  final prefs = await ref.watch(sharedPrefProvider);
  ref.watch(setAuthStateProvider);
  prefs.setBool(
    IS_AUTHENTICATED,
    isAuth,
  );
});

final setAuthenticatedUserProvider =
    StateProvider.family<void, UserModel>((ref, userdata) async {
  final prefs = await ref.watch(sharedPrefProvider);
  ref.watch(setAuthStateProvider);
  prefs.setString(
    AUTHENTICATED_USER_EMAIL,
    jsonEncode(userdata)
  );
});

final getIsAuthenticatedProvider = FutureProvider<bool>((ref) async {
  final prefs = await ref.watch(sharedPrefProvider);
  ref.watch(setAuthStateProvider);
  return prefs.getBool(IS_AUTHENTICATED) ?? false;
});

final getAuthenticatedUserProvider = FutureProvider<UserModel>((ref) async {
  final prefs = await ref.watch(sharedPrefProvider);
  ref.watch(setAuthStateProvider);
  dynamic user = prefs.getString(AUTHENTICATED_USER_EMAIL) ?? '';
  return UserModel.fromJson(user);
});

final resetStorage = StateProvider<dynamic>((ref) async {
  final prefs = await ref.watch(sharedPrefProvider);
  final isCleared = await prefs.clear();
  return isCleared;
});
