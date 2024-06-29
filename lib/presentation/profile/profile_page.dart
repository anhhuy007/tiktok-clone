import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/core/utils/size_utils.dart';
import 'package:tiktok_clone/presentation/profile/models/profile_item_model.dart';
import 'package:tiktok_clone/presentation/profile/notifiers/profile_notifier.dart';
import 'package:tiktok_clone/presentation/profile/widgets/profile_item_widget.dart';

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
        backgroundColor: Color(0xFFFFFFFF),
        body: _buildScrollView(context)
      )
    );
  }

  /// Section Widget
  Widget _buildScrollView(BuildContext context) {
    //var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    //final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    //final double itemWidth = size.width / 2;

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 23.v),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer(
                  builder: (context, ref, _) {
                    return Expanded(
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisExtent: 201.v,
                          crossAxisCount: 2,
                          //childAspectRatio: (itemWidth / itemHeight),
                          mainAxisSpacing: 8.h,
                          crossAxisSpacing: 8.h
                        ),
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: ref
                                .watch(profileNotifier)
                                .profileItemList.length,
                        itemBuilder: (context, index) {
                          ProfileItemModel model = ref.watch(profileNotifier).profileItemList[index];
                          return Padding( padding: EdgeInsets.all(5.0),child: ProfileItemWidget(profileItemModelObj: model));
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