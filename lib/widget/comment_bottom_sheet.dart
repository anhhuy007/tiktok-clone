import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tiktok_clone/core/constants/placeholder_data.dart';
import 'package:tiktok_clone/core/constants/image_constants.dart';
import 'package:tiktok_clone/presentation/home/home_page/notifiers/feed_providers.dart';
import 'package:tiktok_clone/widget/comment_item.dart';

class CommentBottomSheet extends ConsumerStatefulWidget {
  final Function onDismissSheet;
  final int videoId;

  const CommentBottomSheet(
      {Key? key, required this.onDismissSheet, required this.videoId})
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

  Future<void> _openGiphyPicker() async {
    final gif = await GiphyPicker.pickGif(
        context: context,
        apiKey: dotenv.env['GIPHY_API_KEY'] ?? '',
        fullScreenDialog: false,
        previewType: GiphyPreviewType.previewWebp);

    if (gif != null) {
      setState(() {
        // _selectedGifUrl = gif.images.original?.url;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onDismissSheet();
      },
      child: Container(
        color: Colors.black54,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {},
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
                          CommentInput(
                            videoId: widget.videoId,
                            onGifSelected: (url) {
                              setState(() {
                                // _selectedGifUrl = url;
                              });
                            },
                            controller: _controller,
                            commentController: _commentController,
                          ),
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
        print('Reacting with $reactionName');
        // concat the reaction to the comment
        String comment = _commentController.text;
        comment += ' $emoji';

        _commentController.text = comment;
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
}

class CommentInput extends ConsumerStatefulWidget {
  const CommentInput(
      {required this.videoId,
      required this.onGifSelected,
      required this.controller,
        required this.commentController,
      super.key});

  final int videoId;
  final Function(String?) onGifSelected;
  final DraggableScrollableController controller;
  final TextEditingController commentController;

  @override
  _CommentInputState createState() => _CommentInputState();
}

class _CommentInputState extends ConsumerState<CommentInput> {
  bool _isSending = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          IconButton(
            icon: Image(
              image: AssetImage(ImageConstant.gifIcon),
              width: 30,
            ),
            onPressed: () async {
              final gif = await GiphyPicker.pickGif(
                context: context,
                apiKey: dotenv.env['GIPHY_API_KEY'] ?? '',
                fullScreenDialog: false,
                previewType: GiphyPreviewType.previewWebp,
              );
              if (gif != null) {
                widget.onGifSelected(gif.images.original?.url);
              }
            },
          ),
          Expanded(
            child: TextField(
              onTap: () {
                widget.controller.jumpTo(1);
              },
              controller: widget.commentController,
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
          _isSending
              ? const SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(),
                )
              : IconButton(
                  icon: Image(
                    image: AssetImage(ImageConstant.sendIcon),
                    width: 30,
                  ),
                  onPressed: _isSending ? null : _sendComment,
                ),
        ],
      ),
    );
  }

  Future<void> _sendComment() async {
    final comment = widget.commentController.text.trim();
    if (comment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a comment'),
        ),
      );
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      await ref.read(commentProvider.notifier).addComment(
        widget.videoId,
        comment,
      );

      widget.commentController.clear();
      widget.onGifSelected(null);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to send comment. Please try again.'),
        ),
      );
      Logger().e('Failed to send comment', error: e);
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }
}
