import 'package:flutter/material.dart';
import 'package:tiktok_clone/core/utils/size_utils.dart';
import 'package:tiktok_clone/widget/custom_image_view.dart';

class AppBarLeadingImage extends StatelessWidget {
  String? imagePath;
  EdgeInsetsGeometry? margin;
  Function? onTap;

  AppBarLeadingImage({Key? key, this.imagePath, this.margin, this.onTap})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap?.call();
      },
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: CustomImageView(
          imagePath: imagePath,
          width: 24.adaptSize,
          height: 24.adaptSize,
          boxFit: BoxFit.contain
        )
      )
    );
  }
}
