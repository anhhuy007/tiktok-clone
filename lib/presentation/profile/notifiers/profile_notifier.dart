import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/core/constants/image_constants.dart';
import 'package:tiktok_clone/presentation/profile/models/profile_item_model.dart';
import 'package:tiktok_clone/presentation/profile/models/profile_page_model.dart';

/// A notifier that manages the state of a Profile according to the event dispatched to it
class ProfileNotifier extends Notifier<ProfileModel> {
  @override
  ProfileModel build() {
    // TODO: implement build
    return ProfileModel(
        profileItemList: [
          ProfileItemModel(imgPath: ImageConstant.image1Path, follows: "333.5K"),
          ProfileItemModel(imgPath: ImageConstant.image2Path, follows: "100.1K"),
          ProfileItemModel(imgPath: ImageConstant.image3Path, follows: "55.5K"),
          ProfileItemModel(imgPath: ImageConstant.image4Path, follows: "333.3K"),
          ProfileItemModel(imgPath: ImageConstant.image5Path, follows: "666.6K"),
          ProfileItemModel(imgPath: ImageConstant.image6Path, follows: "999.9K")
        ]
    );
  }
}

final profileNotifier = NotifierProvider<ProfileNotifier, ProfileModel> (
    () => ProfileNotifier()
);