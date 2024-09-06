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

  final TextEditingController _commentController = TextEditingController();

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
                initialChildSize: 0.6,
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
                      child: Column(
                        children: [
                          Expanded(
                            child: CustomScrollView(
                              controller: scrollController,
                              slivers: [
                                SliverToBoxAdapter(
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Container(
                                        width: 50,
                                        height: 4,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.4),
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
                                              .map((comment) =>
                                                  CommentItem(comment: comment))
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
                          _buildReactionBar(),
                          _buildCommentInput()
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

  Widget _buildReactionBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[300]!, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildReactionEmoji('👍', 'Like'),
          _buildReactionEmoji('❤️', 'Love'),
          _buildReactionEmoji('😆', 'Haha'),
          _buildReactionEmoji('😮', 'Wow'),
          _buildReactionEmoji('😢', 'Sad'),
          _buildReactionEmoji('😠', 'Angry'),
        ],
      ),
    );
  }

  Widget _buildReactionEmoji(String emoji, String reactionName) {
    return InkWell(
      onTap: () {
        // TODO: Implement reaction functionality
        print('$reactionName reaction tapped');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onTap: () {
                // Scroll to the bottom when the text field is tapped
                _controller.jumpTo(1);
              },
              controller: _commentController,
              decoration: const InputDecoration(
                hintText: 'Add a comment...',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.gif_outlined,
              size: 40,
            ),
            onPressed: () {
              // TODO: Implement sending comment
              print('Sending comment: ${_commentController.text}');
              _commentController.clear();
            },
          ),
        ],
      ),
    );
  }
}
