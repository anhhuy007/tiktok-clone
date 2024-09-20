import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:logger/logger.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tiktok_clone/core/utils/size_utils.dart';
import '../../../widget/custom_app_bar.dart';
import 'feeding_page.dart';
import 'notifiers/feed_providers.dart';

class ReelsPage extends ConsumerStatefulWidget {
  const ReelsPage({Key? key}) : super(key: key);

  @override
  _ReelsPageState createState() => _ReelsPageState();
}

class _ReelsPageState extends ConsumerState<ReelsPage> {
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
                    return FeedingPage(video: video);
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