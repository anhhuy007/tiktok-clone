import 'package:flutter/cupertino.dart';
import 'package:tiktok_clone/presentation/authentication/features/login/login_page.dart';
import 'package:tiktok_clone/presentation/authentication/features/sign_up/signup_page.dart';
import 'package:tiktok_clone/presentation/home/home_page_container.dart';
import 'package:tiktok_clone/presentation/profile/profile_page_container/profile_page_container.dart';
import 'package:tiktok_clone/presentation/search/search_page.dart';
import '../presentation/create_post/createpost_page.dart';

class AppRoutes {
  static const String homePage = '/homePage';
  static const String profilePage = '/profilePage';
  static const String loginPage = '/loginPage';
  static const String signUpPage = '/signUpPage';
  static const String searchPage = '/searchPage';
  static const String createPostPage = '/createPostPage';

  static Map<String, WidgetBuilder> routes = {
    homePage: (context) => const HomePageContainer(),
    profilePage: (context) => ProfilePageContainer(),
    loginPage: (context) => const LogInPage(),
    signUpPage: (context) => const SignUpPage(),
    searchPage: (context) => const SearchPage(),
    createPostPage: (context) => const CreatePostPage(),
  };
}
