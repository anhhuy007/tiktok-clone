import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tiktok_clone/core/constants/image_constants.dart';
import 'package:tiktok_clone/core/utils/size_utils.dart';
import 'package:tiktok_clone/presentation/profile/profile_page/models/profile_item_model.dart';
import 'package:tiktok_clone/presentation/profile/profile_page/models/profile_page_model.dart';
import 'package:tiktok_clone/presentation/profile/profile_page/notifiers/profile_notifier.dart';
import 'package:tiktok_clone/presentation/profile/profile_page/widgets/profile_item_widget.dart';
import 'package:tiktok_clone/theme/theme_helper.dart';


class ProfilePage extends ConsumerStatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends ConsumerState<ProfilePage>{
  @override
  Widget build(BuildContext context) {
    final profileVideosState = ref.watch(profileNotifier);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onErrorContainer,
        body: profileVideosState.when(
          loading: () => _buildPlaceholder(context),
          error: (error, stackTrace) =>
            Center(child: Text('Error: $error')),
          data: (model) => _buildScrollView(context, model)
        )
      )
    );
  }

  /// Section Widget
  Widget _buildScrollView(BuildContext context, ProfileModel model) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
        child: Column(
            children: [
              SizedBox(height: 23.v),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.h),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Consumer(
                        builder: (context, ref, _) {
                          return Flexible(
                            child: GridView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisExtent: 201.v,
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 5.h,
                                  crossAxisSpacing: 1.h
                              ),
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: model.profileItemList.length,
                              itemBuilder: (context, index) {
                                return ProfileItemWidget(profileItemModelObj: model.profileItemList[index]);
                              },
                            ),
                          );
                        },
                      )
                    ]
                ),
              )
            ]
        )
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          SizedBox(height: 23.v),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer(
                  builder: (context, ref, _) {
                    return Flexible(
                      child: Skeletonizer(
                        effect: ShimmerEffect(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          duration: Duration(milliseconds: 1)
                        ),
                        enabled: true,
                        child: GridView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisExtent: 201.v,
                            crossAxisCount: 3,
                            mainAxisSpacing: 5.h,
                            crossAxisSpacing: 1.h
                          ),
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 6,
                          itemBuilder: (context, index) {
                            //Fake Profile Item
                            return ProfileItemWidget(
                              profileItemModelObj: ProfileItemModel(
                                id: -1,
                                title: "Fake title",
                                likes: -1,
                                comments: -1,
                                views: -1,
                                song: "Fake song",
                                createdAt: DateTime.now(),
                                videoUrl: "Fake url",
                                thumbnailUrl: ImageConstant.image1Path,
                                channelId: -1
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                )
              ]
            ),
          )
        ]
      )
    );
  }
}