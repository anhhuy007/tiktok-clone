import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/core/constants/image_constants.dart';
import 'package:tiktok_clone/core/utils/size_utils.dart';
import 'package:tiktok_clone/route/app_routes.dart';
import 'package:tiktok_clone/widget/app_bar_leading_image.dart';
import 'package:tiktok_clone/widget/app_bar_trailing_image.dart';

import '../../../widget/custom_app_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
      )
    );
  }
}

PreferredSizeWidget _buildAppBar(BuildContext context) {
  return CustomAppBar(
    height: 44.v,
    leadingWidth: 52.h,
    leading: AppBarLeadingImage(
      imagePath: ImageConstant.tvIcon,
      margin: EdgeInsets.only(
        left: 24.h,
        top: 8.v,
        bottom: 7.v
      ),
      onTap: () {
        onTapCategoriesLive(context);
      }
    ),
    actions: [
      AppBarTrailingImage(
        imagePath: ImageConstant.searchIcon,
        margin: EdgeInsets.fromLTRB(24.h, 8.v, 24.h, 7.v),
        onTap: () {
          onTapRewind(context);
        }
      )
    ]
  );
}

dynamic onTapCategoriesLive(BuildContext context) {
  // NavigatorService.pushNamed(
  //   AppRoutes.seeLiveScreen(),
  // );
}

dynamic onTapRewind(BuildContext context) {
  // NavigatorService.pushNamed(
  //   AppRoutes.rewindScreen(),
  // );
}