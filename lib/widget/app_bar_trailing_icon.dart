
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/core/utils/size_utils.dart';
import 'package:tiktok_clone/widget/custom_image_view.dart';

class AppBarTrailingIcon extends StatelessWidget {
  String? iconPath;
  EdgeInsetsGeometry? margin;
  Function? onTap;

  AppBarTrailingIcon({Key? key, this.iconPath, this.margin, this.onTap})
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
                imagePath: iconPath,
                width: 28.adaptSize,
                height: 28.adaptSize,
                boxFit: BoxFit.contain
            )
        )
    );
  }
}