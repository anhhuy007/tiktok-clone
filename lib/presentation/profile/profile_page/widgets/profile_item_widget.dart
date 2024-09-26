import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:tiktok_clone/core/constants/image_constants.dart';
import 'package:tiktok_clone/core/utils/size_utils.dart';
import 'package:tiktok_clone/presentation/profile/profile_page/models/profile_item_model.dart';
import 'package:tiktok_clone/widget/custom_image_view.dart';

class ProfileItemWidget extends StatelessWidget {
  ProfileItemWidget({
    required this.profileItemModelObj,
    Key? key
  }) : super(key: key);

  ProfileItemModel profileItemModelObj;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      height: 200.v,
      width: 125.h,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12.h)
        ),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            CustomImageView(
              imagePath: profileItemModelObj.thumbnailUrl,
              height: 200.v,
              width: 125.h,
              borderRadius: BorderRadius.circular(12.h),
              alignment: Alignment.center,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                margin: EdgeInsets.fromLTRB(10.h, 174.v, 60.h, 10.v),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.h)
                ),
                child: Row(
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.playButtonPath,
                      height: 16.adaptSize,
                      width: 16.adaptSize,
                      borderRadius: BorderRadius.circular(8.h),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 4.h,
                        top: 2.v
                      ),
                      child: Text(
                        profileItemModelObj.views.toString(),
                        style: TextStyle(
                          fontSize: 10.fsize,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFFFFFFF)
                        ),
                      ),
                    )
                  ],
                ),
              )
            )
          ],
        ),
      )
    );
  }
}