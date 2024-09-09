import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:logger/logger.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tiktok_clone/core/constants/image_constants.dart';
import 'package:tiktok_clone/core/utils/size_utils.dart';
import 'package:tiktok_clone/presentation/authentication/notifiers/auth_notifier.dart';
import 'package:tiktok_clone/presentation/home/home_page/models/feed_video.dart';
import 'package:tiktok_clone/presentation/profile/profile_page/notifiers/profile_notifier.dart';
import 'package:tiktok_clone/presentation/profile/profile_page_container/notifiers/profile_page_container_notifier.dart';
import 'package:tiktok_clone/widget/app_bar_leading_image.dart';
import 'package:tiktok_clone/widget/app_bar_trailing_image.dart';
import 'package:tiktok_clone/widget/comment_bottom_sheet.dart';
import 'package:tiktok_clone/widget/custom_image_view.dart';
import 'package:video_player/video_player.dart';
import '../../../core/constants/placeholder_data.dart';
import '../../../widget/custom_app_bar.dart';
import 'notifiers/feed_providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final feedState = ref.watch(feedProvider);
    return SafeArea(
        child: Scaffold(
            appBar: _buildAppBar(context),
            body: feedState.when(
              loading: () => Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.black,
                child: Center(
                  child: LoadingAnimationWidget.newtonCradle(
                    color: Colors.white,
                    size: 2 * 50.adaptSize,
                  ),
                ),
              ),
              error: (error, stackTrace) =>
                  Center(child: Text('Error: $error')),
              data: (obj) {
                return PageView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: obj.videos.length,
                  itemBuilder: (context, index) {
                    final video = obj.videos[index];
                    return _buildFeedingPage(context, ref, video);
                  },
                  onPageChanged: (index) {
                    if (index == obj.videos.length - 1) {
                      ref.read(feedProvider.notifier).fetchMoreVideos();
                    }

                    // pause the previous video
                    Logger().d('index: $index');
                    final previousIndex = obj.currentIndex;
                    ref
                        .read(videoControllerProvider(
                            obj.videos[previousIndex].videoUrl))
                        .whenData((value) {
                      Logger().d('pause video $previousIndex');
                      value.pause();
                    });

                    // handle changing state of the current video
                    ref.read(feedProvider.notifier).onFeedIndexChanged(index);

                    // update the comment status
                    ref.read(feedProvider.notifier).setShowCommentStatus(false);
                    ref.read(commentProvider.notifier).clearComments();
                  },
                );
              },
            )));
  }
}

PreferredSizeWidget _buildAppBar(BuildContext context) {
  return CustomAppBar(
    height: 44.v,
    leadingWidth: 100.h,
    bgColor: Colors.black,
    title: const Padding(
      padding: EdgeInsets.only(top: 10, left: 10),
      child: Row(
        children: [
          Text(
            "Shorts",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(
            Icons.arrow_drop_down_outlined,
            color: Colors.white,
            size: 30,
          ),
        ],
      ),
    ),
  );
}

Widget _buildFeedingPage(BuildContext context, WidgetRef ref, FeedVideo video) {
  return Container(
    color: Colors.black,
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    child: Stack(children: [
      VideoPlayerWidget(video: video),
      UserProfileWidget(video: video)
    ]),
  );
}

class UserProfileWidget extends ConsumerWidget {
  final FeedVideo video;

  const UserProfileWidget({required this.video, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
        alignment: Alignment.bottomLeft,
        child: Stack(children: [
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.only(top: 356.v, right: 1.h),
              padding: EdgeInsets.only(left: 20.h, right: 10.h),
              child: Column(children: [
                Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    if (context.mounted) {
                                      ref
                                          .read(profilePageContainerNotifier
                                              .notifier)
                                          .updateState(
                                              profileId: video.channelId,
                                              userId: ref
                                                  .read(authNotifierProvider)
                                                  .user!
                                                  .id);
                                      ref
                                          .read(profileNotifier.notifier)
                                          .fetchPopularVideos(
                                              userId: video.channelId);
                                      Navigator.of(context)
                                          .pushNamed("/profileScreen");
                                    }
                                  },
                                  child: SizedBox(
                                    height: 50.adaptSize,
                                    width: 50.adaptSize,
                                    child: CustomImageView(
                                      imagePath: video.channelAvatarUrl,
                                      width: 50.adaptSize,
                                      height: 50.adaptSize,
                                      borderRadius:
                                          BorderRadius.circular(30.adaptSize),
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                      left: 20.h,
                                      top: 7.v,
                                      bottom: 7.v,
                                    ),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            video.channelHandle,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          // subscribe button
                                          OutlinedButton(
                                              onPressed: () {
                                                // subscribe
                                              },
                                              style: OutlinedButton.styleFrom(
                                                  foregroundColor: Colors.red,
                                                  side: const BorderSide(
                                                      color: Colors.white),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16.h,
                                                      vertical: 4.v)),
                                              child: const Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .notifications_active_rounded,
                                                    color: Colors.white,
                                                    size: 14,
                                                  ),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    'Follow',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12),
                                                  )
                                                ],
                                              )),
                                        ]))
                              ],
                            ),
                            SizedBox(height: 8.v),
                            SizedBox(
                              width: 262.h,
                              child: Text(
                                video.title,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ]),
                      Padding(
                          padding: EdgeInsets.only(
                            left: 79.h,
                            top: 30.v,
                          ),
                          child: Container(
                            height: 330.v,
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.flag,
                                    color: Colors.white,
                                    size: 35.adaptSize,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      LikeButton(
                                        size: 30.adaptSize,
                                        isLiked: ref
                                            .watch(feedProvider)
                                            .value!
                                            .currentVideoLiked,
                                        likeBuilder: (bool isLiked) {
                                          return Icon(
                                            Icons.thumb_up,
                                            color: isLiked
                                                ? Colors.blue
                                                : Colors.white,
                                            size: 30.adaptSize,
                                          );
                                        },
                                        onTap: (isLiked) {
                                          // like the video
                                          ref
                                              .read(feedProvider.notifier)
                                              .likeVideo();
                                          return Future.value(!isLiked);
                                        },
                                      ),
                                      Text(
                                        ref
                                            .watch(feedProvider)
                                            .value!
                                            .currentVideoLikeCount
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal),
                                      )
                                    ],
                                  ),
                                  InkWell(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.thumb_down,
                                          color: ref
                                                  .watch(feedProvider)
                                                  .value!
                                                  .currentVideoUnliked
                                              ? Colors.blue
                                              : Colors.white,
                                          size: 30.adaptSize,
                                        ),
                                        const Text(
                                          "Dislike",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.normal),
                                        )
                                      ],
                                    ),
                                    onTap: () {
                                      // unlike the video
                                      ref
                                          .read(feedProvider.notifier)
                                          .unlikeVideo();
                                    },
                                  ),
                                  InkWell(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.comment,
                                          color: Colors.white,
                                          size: 30.adaptSize,
                                        ),
                                        Text(
                                          video.comments.toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.normal),
                                        )
                                      ],
                                    ),
                                    onTap: () {
                                      ref
                                          .read(commentProvider.notifier)
                                          .loadComments(video.id);
                                      ref
                                          .read(feedProvider.notifier)
                                          .setShowCommentStatus(true);
                                    },
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.share,
                                        color: Colors.white,
                                        size: 30.adaptSize,
                                      ),
                                      const Text(
                                        "Share",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal),
                                      )
                                    ],
                                  ),
                                ]),
                          ))
                    ]),
                Padding(
                  padding: EdgeInsets.only(top: 10.v),
                  child: GestureDetector(
                      onTap: () {
                        // navigate to the song detail page
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(children: [
                              CustomImageView(
                                imagePath: ImageConstant.discIcon,
                                width: 24.adaptSize,
                                height: 24.adaptSize,
                                margin: EdgeInsets.only(
                                  top: 4.v,
                                  left: 8.h,
                                  bottom: 3.v,
                                ),
                                borderRadius:
                                    BorderRadius.circular(12.adaptSize),
                                alignment: Alignment.center,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 5.v,
                                  left: 8.h,
                                  bottom: 3.v,
                                ),
                                child: Icon(
                                  Icons.music_note,
                                  color: Colors.white,
                                  size: 16.adaptSize,
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                    top: 5.v,
                                    bottom: 3.v,
                                  ),
                                  child: Text(
                                    video.song,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.normal),
                                  ))
                            ]),
                            Padding(
                                padding: EdgeInsets.only(
                                  top: 5.v,
                                  right: 8.h,
                                  bottom: 3.v,
                                ),
                                child: CustomImageView(
                                  imagePath:
                                      "https://d1csarkz8obe9u.cloudfront.net/themedlandingpages/tlp_hero_music-posters-2f2d087885999ac3b17f080cb61ea1f2.jpg?ts%20=%201699441158",
                                  width: 40.adaptSize,
                                  height: 40.adaptSize,
                                  borderRadius:
                                      BorderRadius.circular(5.adaptSize),
                                  alignment: Alignment.center,
                                  boxFit: BoxFit.fill,
                                ))
                          ])),
                )
              ])),
          ref.watch(feedProvider).value!.isShowingComments
              ? CommentBottomSheet(
                  onDismissSheet: () {
                    ref.read(feedProvider.notifier).setShowCommentStatus(false);
                  },
                  videoId: video.id,
                )
              : Container()
        ]));
  }
}

class VideoPlayerWidget extends ConsumerWidget {
  final FeedVideo video;

  const VideoPlayerWidget({required this.video, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(videoControllerProvider(video.videoUrl));

    return controller.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
      data: (controller) {
        return Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: Stack(children: [
                  VideoPlayer(controller),
                  ControlsOverlay(controller),
                ]),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ControlsOverlay extends ConsumerStatefulWidget {
  final VideoPlayerController controller;

  const ControlsOverlay(this.controller, {Key? key}) : super(key: key);

  @override
  _ControlsOverlayState createState() => _ControlsOverlayState();
}

class _ControlsOverlayState extends ConsumerState<ControlsOverlay> {
  bool _showControls = true;
  Timer? _timer;
  bool firstTime = true;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _resetTimer() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller.value.isInitialized &&
        !widget.controller.value.isPlaying &&
        firstTime) {
      widget.controller.play();
      firstTime = false;
      _showControls = false;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _showControls = !_showControls;
        });
        if (_showControls) {
          _resetTimer();
        } else {
          _timer?.cancel();
        }
        if (widget.controller.value.isPlaying) {
          widget.controller.pause();
          Logger().d('pause video');
        } else {
          widget.controller.play();
          Logger().d('play video');
        }
      },
      child: Stack(
        children: [
          // Video player
          VideoPlayer(widget.controller),

          // Controls overlay
          AnimatedOpacity(
            opacity: _showControls ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Container(
              color: Colors.black.withOpacity(0.4),
              child: Center(
                child: Icon(
                  widget.controller.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
