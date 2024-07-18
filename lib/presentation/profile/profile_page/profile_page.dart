import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/core/utils/size_utils.dart';
import 'package:tiktok_clone/presentation/profile/profile_page/models/profile_item_model.dart';
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

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onErrorContainer,
        body: _buildScrollView(context)
      )
    );
  }

  /// Section Widget
  Widget _buildScrollView(BuildContext context) {
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
                              itemCount: ref
                                  .watch(profileNotifier)
                                  .profileItemList.length,
                              itemBuilder: (context, index) {
                                ProfileItemModel model = ref.watch(profileNotifier).profileItemList[index];
                                return ProfileItemWidget(profileItemModelObj: model);
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
}