import 'package:flutter/cupertino.dart';
import 'package:tiktok_clone/presentation/home/home_page/home_page.dart';
import 'package:tiktok_clone/presentation/profile/profile_page_container/profile_page_container.dart';

class AppRoutes {
  static const String homeScreen = '/homeScreen';
  static const String profileScreen = '/profileScreen';
  static Map<String, WidgetBuilder> routes = {
    homeScreen: (context) => HomeScreen(),
    profileScreen: (context) => ProfilePageContainer()
  };
}
