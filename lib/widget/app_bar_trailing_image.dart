import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/core/utils/size_utils.dart';

import 'custom_image_view.dart';

class AppBarTrailingImage extends StatelessWidget {
  String? imagePath;
  EdgeInsetsGeometry? margin;
  Function? onTap;

  AppBarTrailingImage({Key? key, this.imagePath, this.margin, this.onTap})
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
                width: 28.adaptSize,
                height: 28.adaptSize,
                boxFit: BoxFit.contain
            )
        )
    );
  }
}
