import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tiktok_clone/core/constants/comment_placeholder.dart';
import 'package:tiktok_clone/presentation/home/home_page/notifiers/feed_providers.dart';
import 'package:tiktok_clone/widget/comment_item.dart';

class CommentBottomSheet extends ConsumerStatefulWidget {
  final Function onDismissSheet;

  const CommentBottomSheet({Key? key, required this.onDismissSheet})
      : super(key: key);

  @override
  _CommentBottomSheetState createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends ConsumerState<CommentBottomSheet> {
  final DraggableScrollableController _controller =
  DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScrollChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onScrollChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onScrollChanged() {
    if (_controller.size <= 0.21) {
      widget.onDismissSheet();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss the sheet when tapping outside
        widget.onDismissSheet();
      },
      child: Container(
        color: Colors.black54, // Semi-transparent background
        child: Stack(
          children: [
            // This GestureDetector prevents taps on the sheet from dismissing it
            GestureDetector(
              onTap: () {}, // Empty onTap to catch taps on the sheet
              child: DraggableScrollableSheet(
                initialChildSize: 0.5,
                maxChildSize: 1,
                minChildSize: 0.2,
                snap: true,
                shouldCloseOnMinExtent: true,
                snapSizes: const [0.5],
                controller: _controller,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: Container(
                      color: Colors.white,
                      child: CustomScrollView(
                        controller: scrollController,
                        slivers: [
                          SliverToBoxAdapter(
                            child: Center(
                              child: Padding(
                                padding:
                                const EdgeInsets.only(top: 8.0),
                                child: Container(
                                  width: 50,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color:
                                    Colors.black.withOpacity(0.4),
                                    borderRadius:
                                    BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SliverAppBar(
                            title: Text('Comments'),
                            pinned: true,
                            centerTitle: true,
                          ),
                          SliverToBoxAdapter(
                            child: Divider(
                              height: 1,
                              thickness: 1,
                              color: Colors.grey[200],
                            ),
                          ),
                          ref.watch(commentProvider).when(
                            data: (comments) {
                              return SliverList.list(
                                children: [
                                  for (final comment in comments)
                                    CommentItem(comment: comment),
                                ],
                              );
                            },
                            loading: () {
                                  return SliverToBoxAdapter(
                                    child: Skeletonizer(
                                      child: Column(
                                        children: commentFakeData
                                            .map((comment) => CommentItem(comment: comment))
                                            .toList(),
                                      ),
                                    ),
                                  );
                                },
                            error: (error, stackTrace) {
                              return const SliverToBoxAdapter(
                                child: Center(
                                  child: Text(
                                    'Failed to load comments',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
