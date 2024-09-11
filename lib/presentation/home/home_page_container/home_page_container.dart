import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:tiktok_clone/core/utils/size_utils.dart';
import 'package:tiktok_clone/presentation/home/home_page/home_page.dart';
import 'package:tiktok_clone/presentation/search/search_page.dart';

import '../../../core/constants/image_constants.dart';

class HomePageContainer extends ConsumerStatefulWidget {
  const HomePageContainer({Key? key}) : super(key: key);

  @override
  _HomePageContainerState createState() => _HomePageContainerState();
}

class _HomePageContainerState extends ConsumerState<HomePageContainer> {
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: SalomonBottomBar(
          backgroundColor: _currentIndex <= 0 ? Colors.black : Colors.white,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            _buildSalomonBottomBarItem(
              0,
              ImageConstant.homeIcon,
              ImageConstant.homeIcon_white,
              'Home',
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
              Colors.yellow,
            ),
            _buildSalomonBottomBarItem(
              3,
              ImageConstant.chatIcon,
              ImageConstant.chatIcon_white,
              'Chat',
              Colors.red,
            ),
            _buildSalomonBottomBarItem(
              4,
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
          children: const [
            HomePage(),
            SearchPage(),
            Center(child: Text('Add')),
            Center(child: Text('Chat')),
            Center(child: Text('Profile')),
          ],
        ));
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
          _currentIndex <= 0 ? whiteThemeIconPath : blackThemeIconPath,
        ),
        width: 24.adaptSize,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: _currentIndex <= 0 ? Colors.white : selectedColor,
        ),
      ),
      selectedColor: _currentIndex <= 0 ? Colors.black : selectedColor,
    );
  }
}
