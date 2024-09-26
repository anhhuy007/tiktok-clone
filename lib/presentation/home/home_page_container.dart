import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:tiktok_clone/core/utils/size_utils.dart';
import 'package:tiktok_clone/presentation/authentication/models/user_data.dart';
import 'package:tiktok_clone/presentation/authentication/notifiers/auth_notifier.dart';
import 'package:tiktok_clone/presentation/create_post/createpost_page.dart';
import 'package:tiktok_clone/presentation/profile/profile_page/notifiers/profile_notifier.dart';
import 'package:tiktok_clone/presentation/profile/profile_page/profile_page.dart';
import 'package:tiktok_clone/presentation/profile/profile_page_container/notifiers/profile_page_container_notifier.dart';
import 'package:tiktok_clone/presentation/profile/profile_page_container/profile_page_container.dart';
import 'package:tiktok_clone/presentation/search/search_page.dart';

import '../../core/constants/image_constants.dart';
import '../reels/notifiers/feed_providers.dart';
import '../reels/reels_page.dart';

class HomePageContainer extends ConsumerStatefulWidget {
  const HomePageContainer({Key? key}) : super(key: key);

  @override
  _HomePageContainerState createState() => _HomePageContainerState();
}

class _HomePageContainerState extends ConsumerState<HomePageContainer> {
  var _currentIndex = 0;
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SalomonBottomBar(
        backgroundColor: _currentIndex <= 1 ? Colors.black : Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) {
          if (_currentIndex != index) {
            _handleTabChange(_currentIndex, index);
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: [
          _buildSalomonBottomBarItem(
            0,
            ImageConstant.reelsIcon,
            ImageConstant.reelsIcon_white,
            'Reels',
            Colors.purple,
          ),
          _buildSalomonBottomBarItem(
            1,
            ImageConstant.searchIcon,
            ImageConstant.searchIcon_white,
            'Search',
            Colors.blue,
          ),
          _buildSalomonBottomBarItem(
            2,
            ImageConstant.addIcon,
            ImageConstant.addIcon_white,
            'Add',
            Colors.purple,
          ),
          _buildSalomonBottomBarItem(
            3,
            ImageConstant.profileIcon,
            ImageConstant.profileIcon_white,
            'Profile',
            Colors.teal,
          ),
        ],
        margin: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildOffstageNavigator(0),
          _buildOffstageNavigator(1),
          _buildOffstageNavigator(2),
          _buildOffstageNavigator(3),
        ],
      ),
    );
  }

  Widget _buildOffstageNavigator(int index) {
    return Offstage(
      offstage: _currentIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) {
              switch (index) {
                case 0:
                  return const ReelsPage();
                case 1:
                  return const SearchPage();
                case 2:
                  return const CreatePostPage();
                case 3:
                  return const ProfilePageContainer();
                default:
                  return const SizedBox.shrink();
              }
            },
          );
        },
      ),
    );
  }

  Future<void> _handleTabChange(int oldIndex, int newIndex) async {
    final oldTab = _getTabName(oldIndex);
    final newTab = _getTabName(newIndex);
    Logger().d('Switching from $oldTab to $newTab');

    // You can add more custom logic here
    // For example, you could call methods on the widgets if needed
    if (oldIndex == 0) {
      // Reels tab is being left
      String? currentVideoUrl =
          await ref.read(feedProvider.notifier).getCurrentVideoUrl();
      ref.read(videoControllerProvider(currentVideoUrl!)).whenData((value) {
        value.pause();
      });
    }
    if (newIndex == 0) {
      // Reels tab is being entered
      String? currentVideoUrl =
          await ref.read(feedProvider.notifier).getCurrentVideoUrl();
      ref.read(videoControllerProvider(currentVideoUrl!)).whenData((value) {
        value.play();
      });
    }
    else if (newIndex == 3) {
      // Profile tab is being entered
      final UserModel? user = ref.read(authProvider).user;
      if (user != null) {
        await ref.read(profilePageContainerNotifier.notifier).updateState(userId: user.id, profileId: user.id);
        await ref.read(profileNotifier.notifier).fetchPopularVideos(userId: user.id);
      }
    }
  }

  String _getTabName(int index) {
    switch (index) {
      case 0:
        return 'Reels';
      case 1:
        return 'Search';
      case 2:
        return 'Create';
      case 3:
        return 'Profile';
      default:
        return 'Unknown';
    }
  }

  SalomonBottomBarItem _buildSalomonBottomBarItem(
    int index,
    String blackThemeIconPath,
    String whiteThemeIconPath,
    String title,
    Color selectedColor,
  ) {
    return SalomonBottomBarItem(
      icon: Image(
        image: AssetImage(
          _currentIndex <= 1 ? whiteThemeIconPath : blackThemeIconPath,
        ),
        width: 24.adaptSize,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: _currentIndex <= 1 ? Colors.white : selectedColor,
        ),
      ),
      selectedColor: _currentIndex <= 1 ? Colors.white : selectedColor,
    );
  }
}


