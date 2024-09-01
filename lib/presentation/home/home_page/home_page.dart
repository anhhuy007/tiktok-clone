import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:tiktok_clone/core/constants/image_constants.dart';
import 'package:tiktok_clone/core/utils/size_utils.dart';
import 'package:tiktok_clone/presentation/home/home_page/models/feed_video.dart';
import 'package:tiktok_clone/presentation/profile/profile_page/notifiers/profile_notifier.dart';
import 'package:tiktok_clone/presentation/profile/profile_page_container/notifiers/profile_page_container_notifier.dart';
import 'package:tiktok_clone/widget/app_bar_leading_image.dart';
import 'package:tiktok_clone/widget/app_bar_trailing_image.dart';
import 'package:tiktok_clone/widget/custom_image_view.dart';
import 'package:video_player/video_player.dart';
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
              loading: () => const Center(child: CircularProgressIndicator()),
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
                    ref.read(feedProvider.notifier).setCurrentVideo(index);
                  },
                );
              },
            )));
  }
}

PreferredSizeWidget _buildAppBar(BuildContext context) {
  return CustomAppBar(
      height: 44.v,
      leadingWidth: 52.h,
      bgColor: Colors.black,
      leading: AppBarLeadingImage(
          imagePath: ImageConstant.tvIcon,
          margin: EdgeInsets.only(left: 24.h, top: 8.v, bottom: 7.v),
          onTap: () {}),
      actions: [
        AppBarTrailingImage(
            imagePath: ImageConstant.searchIcon,
            margin: EdgeInsets.fromLTRB(24.h, 8.v, 24.h, 7.v),
            onTap: () {})
      ]);
}

Widget _buildFeedingPage(BuildContext context, WidgetRef ref, FeedVideo video) {
  return Container(
    color: Colors.black,
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    alignment: Alignment.bottomLeft,
    child: Stack(children: [
      VideoPlayerWidget(video: video),
      _buildUserProfile(context, ref, video)
    ]),
  );
}

Widget _buildUserProfile(BuildContext context, WidgetRef ref, FeedVideo video) {
  return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.only(top: 386.v, right: 1.h),
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
                                if(context.mounted) {
                                  ref.read(profilePageContainerNotifier.notifier).updateState(userId: video.channelId);
                                  ref.read(profileNotifier.notifier).fetchPopularVideos(userId: video.channelId);
                                  Navigator.of(context).pushNamed("/profileScreen");
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
                      child: Column(children: [
                        Icon(
                          Icons.flag,
                          color: Colors.white,
                          size: 35.adaptSize,
                        ),
                        SizedBox(height: 30.v),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.thumb_up,
                              color: Colors.white,
                              size: 30.adaptSize,
                            ),
                            Text(
                              video.likes.toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal),
                            )
                          ],
                        ),
                        SizedBox(height: 30.v),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.thumb_down,
                              color: Colors.white,
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
                        SizedBox(height: 30.v),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                        SizedBox(height: 30.v),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                      ]))
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
                            borderRadius: BorderRadius.circular(12.adaptSize),
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
                              borderRadius: BorderRadius.circular(5.adaptSize),
                              alignment: Alignment.center,
                              boxFit: BoxFit.fill,
                            ))
                      ])),
            )
          ])));
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
        // if (controller.value.isInitialized && !controller.value.isPlaying) {
        //   Logger().d('play video ${video.id}');
        //   controller.play();
        // }

        return Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: Stack(children: [
                  VideoPlayer(controller),
                  ControlsOverlay(video),
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
  final FeedVideo video;

  const ControlsOverlay(this.video, {Key? key}) : super(key: key);

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
    final controllerAsyncValue =
        ref.watch(videoControllerProvider(widget.video.videoUrl));

    return controllerAsyncValue.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
      data: (controller) {
        if (controller.value.isInitialized && !controller.value.isPlaying && firstTime) {
          Logger().d('play video ${widget.video.id}');
          controller.play();
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
            if (controller.value.isPlaying) {
              controller.pause();
              Logger().d('pause video');
            } else {
              controller.play();
              Logger().d('play video');
            }
          },
          child: Stack(
            children: [
              // Video player
              VideoPlayer(controller),

              // Controls overlay
              AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                  child: Center(
                    child: Icon(
                      controller.value.isPlaying
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
      },
    );
  }
}
