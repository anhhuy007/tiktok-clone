import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/core/constants/image_constants.dart';
import 'package:tiktok_clone/core/utils/size_utils.dart';
import 'package:tiktok_clone/presentation/profile/profile_page/profile_page.dart';
import 'package:tiktok_clone/theme/theme.dart';
import 'package:tiktok_clone/widget/app_bar_leading_image.dart';
import 'package:tiktok_clone/widget/app_bar_title.dart';
import 'package:tiktok_clone/widget/app_bar_trailing_icon.dart';
import 'package:tiktok_clone/widget/custom_app_bar.dart';
import 'package:tiktok_clone/widget/custom_elevated_button.dart';
import 'package:tiktok_clone/widget/custom_icon_button.dart';
import 'package:tiktok_clone/widget/custom_image_view.dart';

class ProfilePageContainer extends ConsumerStatefulWidget {
  ProfilePageContainer({Key? key}) : super(key: key);

  @override
  ProfilePageContainerState createState() => ProfilePageContainerState();
}

class ProfilePageContainerState extends ConsumerState<ProfilePageContainer> with TickerProviderStateMixin {
  late TabController tabViewController;

  @override
  void initState() {
    super.initState();
    tabViewController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        appBar: _buildAppBar(context),
        body: SizedBox(
          width: SizeUtils.width,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 13.v),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.avatarPath,
                  height: 120.adaptSize,
                  width: 120.adaptSize,
                  borderRadius: BorderRadius.circular(60.h),
                ),
                SizedBox(height: 14.v),
                Text(
                  "@lionel_messi",
                  style: CustomTextStyles.titleLarge,
                ),
                SizedBox(height: 9.v),
                Text(
                  "Footballer",
                  style: CustomTextStyles.titleSmallGray900,
                ),
                SizedBox(height: 17.v),
                _buildRecentOrders(context),
                SizedBox(height: 18.v),
                _buildClientTestimonials(context),
                SizedBox(height: 34.v),
                Container(
                  height: 40.v,
                  width: 341.h,
                  margin: EdgeInsets.only(left: 24.h),
                  child: TabBar(
                    controller: tabViewController,
                    labelPadding: EdgeInsets.zero,
                    indicatorColor: ColorSchemes.primaryColorScheme.primary,
                    tabs: [
                      Tab(
                        child: Icon(
                          Icons.grid_view_rounded,
                          color: PrimaryColors.gray500,
                          size: 24.adaptSize
                        )
                      ),
                      Tab(
                        child: Icon(
                          Icons.bookmark,
                          color: PrimaryColors.gray500,
                          size: 24.adaptSize,
                        )
                      ),
                      Tab(
                        child: Icon(
                          Icons.favorite,
                          color: PrimaryColors.gray500,
                          size: 24.adaptSize,
                        )
                      )
                    ]
                  ),
                ),
                _buildReviews(context)
              ],
            )
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 52.h,
      leading: Icon(
        Icons.arrow_back
      ),
      title: AppBarTitle(
        text: "Lionel Messi",
        margin: EdgeInsets.only(left: 16.h),
      ),
      actions: [
        SizedBox(width: 20.h),
        IconButton(
          icon: Icon(
            Icons.notifications_none_outlined,
            color: Colors.black,
          ),
          onPressed: () {
            //NOTICE!!!: do it later
          },
        ),
        SizedBox(width: 20.h),
        IconButton(
          icon: Icon(
            Icons.more_horiz_outlined,
            color: Colors.black,
          ),
          onPressed: () {
            //NOTICE!!!: do it later
          },
        )
      ],
    );
  }

  /// Section Widget
  Widget _buildRecentOrders(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16.h),
              child: _buildUserProfile(
                context,
                content: "679",
                title: "Posts",
                onTap: () {

                }
              )
            )
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16.h),
              child: _buildUserProfile(
                context,
                content: "2.6M",
                title: "Followers",
                onTap: () {

                }
              ),
            )
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16.h),
              child: _buildUserProfile(
                context,
                content: "648",
                title: "Followings",
                onTap: () {

                }
              ),
            )
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16.h),
              child: _buildUserProfile(
                context,
                content: "27M",
                title: "Likes",
                onTap: () {

                }
              ),
            )
          )
        ],
      ),
    );
  }

  Widget _buildClientTestimonials(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomElevatedButton(
            buttonStyle: ElevatedButton.styleFrom(
                backgroundColor:  ColorSchemes.primaryColorScheme.primary,
                shadowColor: PrimaryColors.gray900,
                elevation: 3
            ),
            width: 132.h,
            text: "Follow",
            margin: EdgeInsets.symmetric(vertical: 1.v, horizontal: 2.v),
            leftIcon: Container(
              margin: EdgeInsets.only(right: 4.h),
              child: Icon(
                color: Colors.white,
                Icons.person_add,
                size: 14.adaptSize,
              ),
            ),
          ),
          CustomElevatedButton(
            buttonStyle: ElevatedButton.styleFrom(
              backgroundColor:  ColorSchemes.primaryColorScheme.onErrorContainer,
              shadowColor: ColorSchemes.primaryColorScheme.primary,
              elevation: 3
            ),
            width: 150.h,
            text: "Message",
            buttonTextStyle: CustomTextStyles.titleMediumOnErrorContainerSemiBold.copyWith(
              color: ColorSchemes.primaryColorScheme.primary
            ),
            margin: EdgeInsets.symmetric(vertical: 1.v, horizontal: 3.v),
            leftIcon: Container(
              margin: EdgeInsets.only(right: 4.h),
              child: Icon(
                color: ColorSchemes.primaryColorScheme.primary,
                Icons.messenger_outlined,
                size: 14.adaptSize,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.h),
            child: IconButton(
              icon: Icon(
                Icons.camera_alt_outlined,
                color: ColorSchemes.primaryColorScheme.primary,
                size: 25.adaptSize,
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Color(0xFFF4D7F5))
              ),
              onPressed: () {

              },
            )
          ),
          Padding(
              padding: EdgeInsets.only(left: 8.h),
              child: IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: ColorSchemes.primaryColorScheme.primary,
                  size: 25.adaptSize,
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Color(0xFFF4D7F5))
                ),
                onPressed: () {

                },
              )
          )
        ]
      )
    );
  }

  /// Section Widget
  Widget _buildReviews(BuildContext context) {
    return SizedBox(
      height: 474.v,
      child: TabBarView(
        controller: tabViewController,
        children: [
          ProfilePage(),
          ProfilePage(),
          ProfilePage()
        ],
      ),
    );
  }

  Widget _buildUserProfile(BuildContext context, {required String title, required String content, Function? onTap}) {
    return GestureDetector(
      onTap: () {onTap?.call();},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.h),
        decoration: BoxDecoration(
          color: ColorSchemes.primaryColorScheme.onErrorContainer,
          borderRadius: BorderRadius.circular(1.h)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              content,
              style: CustomTextStyles.headlineSmall.copyWith(color: PrimaryColors.gray900),
            ),
            SizedBox(height: 5.v),
            Text(
              title,
              style: CustomTextStyles.titleSmallErrorContainer.copyWith(color: ColorSchemes.primaryColorScheme.errorContainer),
            ),
            SizedBox(height: 1.v)
          ],
        ),
      ),
    );
  }
}


