import 'package:flutter/material.dart';
import 'package:tiktok_clone/theme/theme.dart';

class AppBarTitle extends StatelessWidget {
  AppBarTitle({
    Key? key,
    required this.text,
    this.margin,
    this.onTap
  }) : super(key: key);

  String text;
  EdgeInsetsGeometry? margin;
  Function? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: Text(
          text,
          style: CustomTextStyles.headlineSmall.copyWith(
            color: PrimaryColors.gray900
          ),
        )
      )
    );
  }
}