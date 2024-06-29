import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomImageView extends StatelessWidget {
  String? imagePath;
  double? height;
  double? width;
  Color? color;
  BoxFit? boxFit;
  final String placeHolder;
  Alignment? alignment;
  VoidCallback? onTap;
  EdgeInsetsGeometry? margin;
  BorderRadius? borderRadius;
  BoxBorder? boxBorder;

  CustomImageView(
      {Key? key,
      this.imagePath,
      this.height,
      this.width,
      this.color,
      this.boxFit,
      this.placeHolder = 'assets/icons/image_not_found.png',
      this.alignment,
      this.onTap,
      this.margin,
      this.borderRadius,
      this.boxBorder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment!,
            child: _buildWidget(),
          )
        : _buildWidget();
  }

  Widget _buildWidget() {
    return Padding(
        padding: margin ?? EdgeInsets.zero,
        child: InkWell(onTap: onTap, child: _buildCircleImage()));
  }

  Widget _buildCircleImage() {
    if (borderRadius != null) {
      return ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: _buildImageWithBorder());
    } else {
      return _buildImageWithBorder();
    }
  }

  Widget _buildImageWithBorder() {
    if (boxBorder != null) {
      return Container(
          decoration: BoxDecoration(
              border: boxBorder,
              borderRadius: borderRadius ?? BorderRadius.zero),
          child: _buildImageView());
    } else {
      return _buildImageView();
    }
  }

  Widget _buildImageView() {
    if (imagePath != null) {
      switch (imagePath!.imageType) {
        case ImageType.svg:
          return Container(
              height: height,
              width: width,
              child: SvgPicture.asset(imagePath!,
                  height: height,
                  width: width,
                  fit: boxFit ?? BoxFit.contain,
                  colorFilter: color != null
                      ? ColorFilter.mode(
                          color ?? Colors.transparent, BlendMode.srcIn)
                      : null));
        case ImageType.png:
          return Image.asset(
            imagePath!,
            height: height,
            width: width,
            color: color,
            fit: boxFit ?? BoxFit.cover,
          );
        case ImageType.jpg:
          return Image.asset(
            imagePath!,
            height: height,
            width: width,
            color: color,
            fit: boxFit ?? BoxFit.cover,
          );
        case ImageType.network:
          return CachedNetworkImage(
              height: height,
              width: width,
              fit: boxFit,
              imageUrl: imagePath!,
              color: color,
              placeholder: (context, url) => Container(
                    height: 30,
                    width: 30,
                    child: LinearProgressIndicator(
                      color: Colors.grey.shade200,
                      backgroundColor: Colors.grey.shade100,
                    ),
                  ),
              errorWidget: (context, url, error) => Image.asset(
                    placeHolder,
                    height: height,
                    width: width,
                    fit: boxFit,
                  ));
        case ImageType.file:
          return Image.file(
            File(imagePath!),
            height: height,
            width: width,
            color: color,
            fit: boxFit ?? BoxFit.cover,
          );
        default:
          return Image.asset(
            placeHolder,
            height: height,
            width: width,
            color: color,
            fit: boxFit,
          );
      }
    }

    return const SizedBox();
  }
}

extension ImageTypeExtension on String {
  ImageType get imageType {
    if (startsWith('http') || startsWith('https')) {
      return ImageType.network;
    } else if (endsWith('.svg')) {
      return ImageType.svg;
    } else if (endsWith('.png')) {
      return ImageType.png;
    } else if (endsWith('.jpg')) {
      return ImageType.jpg;
    } else if (startsWith('file://')) {
      return ImageType.file;
    } else {
      return ImageType.unknown;
    }
  }
}

enum ImageType { svg, png, jpg, network, file, unknown }
