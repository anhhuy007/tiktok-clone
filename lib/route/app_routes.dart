import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/presentation/authentication/features/login/login_page.dart';
import 'package:tiktok_clone/presentation/authentication/features/sign_up/create_profile_page.dart';
import 'package:tiktok_clone/presentation/authentication/features/sign_up/signup_page.dart';
import 'package:tiktok_clone/presentation/home/home_page_container.dart';
import 'package:tiktok_clone/presentation/profile/profile_page_container/profile_page_container.dart';
import 'package:tiktok_clone/presentation/search/search_page.dart';
import '../presentation/create_post/createpost_page.dart';
import '../presentation/profile/edit_profile_page/editprofile_page.dart';
import '../presentation/profile/profile_page_container/models/profile_page_container_model.dart';
import '../presentation/reels/feeding_page.dart';
import '../presentation/reels/models/feed_video.dart';

class AppRoutes {
  static const String homePage = '/homePage';
  static const String profilePage = '/profilePage';
  static const String loginPage = '/loginPage';
  static const String signUpPage = '/signUpPage';
  static const String searchPage = '/searchPage';
  static const String createPostPage = '/createPostPage';
  static const String feedingPage = '/feedingPage';
  static const String editProfilePage = '/editProfilePage';
  static const String createProfilePage = '/createProfilePage';

  static Map<String, WidgetBuilder> routes = {
    homePage: (context) => const HomePageContainer(),
    profilePage: (context) => const ProfilePageContainer(),
    loginPage: (context) => const LogInPage(),
    signUpPage: (context) => const SignUpPage(),
    searchPage: (context) => const SearchPage(),
    createPostPage: (context) => const CreatePostPage(),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case feedingPage:
        final args = settings.arguments as FeedVideo;
        return MaterialPageRoute(
          builder: (context) => FeedingPage(video: args),
        );
      case editProfilePage:
        final args = settings.arguments as UserInfoModel;
        return MaterialPageRoute(
          builder: (context) => EditProfilePage(userModel: args),
        );
      case createProfilePage:
        final args = settings.arguments as UserInfoModel;
        return MaterialPageRoute(
          builder: (context) => CreateProfilePage(userModel: args),
        );
      default:
        return MaterialPageRoute(
          builder: routes[settings.name]!,
        );
    }
  }
}
