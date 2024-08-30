import 'package:flutter/cupertino.dart';
import 'package:tiktok_clone/presentation/authentication/features/login/login_page.dart';
import 'package:tiktok_clone/presentation/authentication/features/sign_up/signup_page.dart';
import 'package:tiktok_clone/presentation/home/home_page/home_page.dart';
import 'package:tiktok_clone/presentation/profile/profile_page_container/profile_page_container.dart';

class AppRoutes {
  static const String homeScreen = '/homeScreen';
  static const String profileScreen = '/profileScreen';
  static const String loginScreen = '/loginScreen';
  static const String signUpScreen = '/signUpScreen';

  static Map<String, WidgetBuilder> routes = {
    homeScreen: (context) => const HomeScreen(),
    profileScreen: (context) => ProfilePageContainer(),
    loginScreen: (context) => const LogInPage(),
    signUpScreen: (context) => const SignUpPage(),
  };
}
