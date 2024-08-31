import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/core/constants/image_constants.dart';
import 'package:tiktok_clone/core/utils/size_utils.dart';
import 'package:tiktok_clone/presentation/profile/profile_page/notifiers/profile_notifier.dart';
import 'package:tiktok_clone/presentation/profile/profile_page/profile_page.dart';
import 'package:tiktok_clone/presentation/profile/profile_page_container/models/profile_page_container_model.dart';
import 'package:tiktok_clone/presentation/profile/profile_page_container/notifiers/profile_page_container_notifier.dart';
import 'package:tiktok_clone/presentation/profile/profile_page_container/widgets/description_text_widget.dart';
import 'package:tiktok_clone/theme/theme_helper.dart';
import 'package:tiktok_clone/widget/app_bar_title.dart';
import 'package:tiktok_clone/widget/custom_app_bar.dart';
import 'package:tiktok_clone/widget/custom_elevated_button.dart';
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
    final profileState = ref.watch(profilePageContainerNotifier);
    return SafeArea(
      child: profileState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Error: $error')),
        data: (model) {
          tabViewController.addListener(
            () {
              switch(tabViewController.index) {
                case 0: ref.read(profileNotifier.notifier).fetchPopularVideos(userId: model.userId);
                case 1: ref.read(profileNotifier.notifier).fetchLatestVideos(userId: model.userId);
                case 2: ref.read(profileNotifier.notifier).fetchOldestVideos(userId: model.userId);
              }
            }
          );
          return Scaffold(
            backgroundColor: Color(0xFFFFFFFF),
            appBar: _buildAppBar(context, model),
            body: SizedBox(
              width: SizeUtils.width,
              child: SingleChildScrollView(
                  padding: EdgeInsets.only(top: 3.v),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: FIGMA_DESIGN_WIDTH.h,
                        height: 100.v,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.h),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.h),
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.h)
                                ),
                                child: CustomImageView(
                                  imagePath: ImageConstant.bannerPath,
                                )
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.v),
                      Row(
                        children: [
                          SizedBox(width: 20.h),
                          CustomImageView(
                            imagePath: model.avatarUrl,
                            height: 120.adaptSize,
                            width: 120.adaptSize,
                            borderRadius: BorderRadius.circular(60.h),
                          ),
                          SizedBox(width: 25.h,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model.name,
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              SizedBox(height: 3.v),
                              Text(
                                model.handle,
                                style: CustomTextStyles.titleSmallGray900,
                              ),
                              SizedBox(height: 3.v,),
                              _buildRecentOrders(context, model)
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 15.v),
                      Container(
                          child: DescriptionTextWidget(
                              text: model.description
                          )
                      ),
                      SizedBox(height: 20.v),
                      _buildClientTestimonials(context, model),
                      SizedBox(height: 20.v),
                      Container(
                        height: 40.v,
                        width: 341.h,
                        //margin: EdgeInsets.only(left: 24.h),
                        child: TabBar(
                            controller: tabViewController,
                            labelPadding: EdgeInsets.zero,
                            indicatorColor: Theme.of(context).colorScheme.primary,
                            tabs: [
                              Tab(
                                  child: Text(
                                    "Popular",
                                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18.fsize
                                    ),
                                  )
                              ),
                              Tab(
                                  child: Text(
                                    "Latest",
                                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18.fsize
                                    ),
                                  )
                              ),
                              Tab(
                                  child: Text(
                                    "Oldest",
                                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18.fsize
                                    ),
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
          );
        },
      )
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context, ProfilePageContainerModel model) {
    return CustomAppBar(
      leadingWidth: 52.h,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: AppBarTitle(
        text: model.name,
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
  Widget _buildRecentOrders(BuildContext context, ProfilePageContainerModel model) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 0.h),
                child: _buildUserProfile(
                    context,
                    content: model.follower.toString(),
                    title: "Followers",
                    onTap: () {

                    }
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 0.h),
                child: _buildUserProfile(
                    context,
                    content: model.following.toString(),
                    title: "Followings",
                    onTap: () {

                    }
                ),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8.88.h),
                child: _buildUserProfile(
                  context,
                  content: model.posts.toString(),
                  title: "Posts",
                  onTap: () {

                  }
                )
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildClientTestimonials(BuildContext context, ProfilePageContainerModel model) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomElevatedButton(
            buttonStyle: ElevatedButton.styleFrom(
                backgroundColor:  Theme.of(context).colorScheme.primary,
                shadowColor: PrimaryColors.gray900,
                elevation: 3
            ),
            width: (FIGMA_DESIGN_WIDTH - 30).h,
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
        padding: EdgeInsets.symmetric(horizontal: 0.h),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onErrorContainer,
          borderRadius: BorderRadius.circular(1.h)
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              content,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: PrimaryColors.gray500,
                fontSize: 12.fsize
              ),
            ),
            SizedBox(width: 5.h),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: PrimaryColors.gray500,
                fontSize: 12.fsize
              ),
            ),
            SizedBox(width: 1.h)
          ],
        ),
      ),
    );
  }
}


