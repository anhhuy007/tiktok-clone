import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/core/utils/size_utils.dart';
import 'package:tiktok_clone/theme/theme_helper.dart';

class CustomElevatedButton extends StatelessWidget{
  CustomElevatedButton({
    Key? key,
    this.decoration,
    this.leftIcon,
    this.rightIcon,
    this.margin,
    this.onPressed,
    this.buttonStyle,
    this.alignment,
    this.buttonTextStyle,
    this.isDisabled,
    this.height,
    this.width,
    required this.text
  });

  final BoxDecoration? decoration;
  final Widget? leftIcon;
  final Widget? rightIcon;
  EdgeInsets? margin;
  VoidCallback? onPressed;
  ButtonStyle? buttonStyle;
  Alignment? alignment;
  TextStyle? buttonTextStyle;
  bool? isDisabled;
  double? height;
  double? width;
  String text;

  @override
  Widget build(BuildContext context) {
    return alignment != null ? Align(
      alignment: alignment!,
      child: buildElevatedButtonWidget
    ) : buildElevatedButtonWidget;
  }

  Widget get buildElevatedButtonWidget => Container(
    height: this.height ?? 38.v,
    width: this.width ?? double.maxFinite,
    margin: margin,
    decoration: decoration,
    child: ElevatedButton(
      style: buttonStyle,
      onPressed: isDisabled ?? false ? null : onPressed ?? () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          leftIcon ?? const SizedBox.shrink(),
          Text(
            text,
            style: buttonTextStyle ?? CustomTextStyles.titleMediumOnErrorContainerSemiBold
          ),
          rightIcon ?? const SizedBox.shrink()
        ],
      ),
    ),
  );
}