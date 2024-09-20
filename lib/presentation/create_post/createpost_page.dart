import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/widget/video_player.dart';

import 'notifier/createpost_notifier.dart';

class CreatePostPage extends ConsumerStatefulWidget {
  const CreatePostPage({super.key});

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends ConsumerState<CreatePostPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _hashtagController = TextEditingController();
  final _songController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _hashtagController.dispose();
    _songController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final createpostState = ref.watch(createPostProvider);
    final hashtags = ["#trending", "#foryou", "#love", "#instagood"];
    final songs = [
      "Let me love you",
      "Watermelon sugar",
      "Blinding lights",
      "Dance monkey",
      "Truth hurts"
    ];

    return Scaffold(
        appBar: AppBar(
          title: const Text('Create video'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                createpostState.videoFilePath.isNotEmpty
                    ? MyVideoPlayerWidget(
                        videoUrl: createpostState.videoFilePath,
                        onRemove: _removeVideo)
                    : _buildVideoPlaceHolder(),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                      hintText: 'Write a caption and add hashtags...',
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          color: Colors.grey),
                      border: InputBorder.none),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a title' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _hashtagController,
                  decoration: InputDecoration(
                    hintText: 'Hashtags',
                    hintStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.tag),
                    suffixIcon: PopupMenuButton<String>(
                      icon: const Icon(Icons.arrow_drop_down),
                      itemBuilder: (context) {
                        return hashtags
                            .map((hashtag) => PopupMenuItem<String>(
                                  value: hashtag,
                                  child: Text(hashtag),
                                ))
                            .toList();
                      },
                      onSelected: (value) {
                        _hashtagController.text = value;
                        // hide the keyboard
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                  validator: (value) => value!.isEmpty
                      ? 'Please enter at least one hashtag'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _songController,
                  decoration: InputDecoration(
                    hintText: 'Add a song',
                    hintStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.music_note),
                    suffixIcon: PopupMenuButton<String>(
                      icon: const Icon(Icons.arrow_drop_down),
                      itemBuilder: (context) {
                        return songs
                            .map((song) => PopupMenuItem<String>(
                                  value: song,
                                  child: Text(song),
                                ))
                            .toList();
                      },
                      onSelected: (value) {
                        _songController.text = value;
                        //   hide the keyboard
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a song' : null,
                ),
                const SizedBox(height: 60),
                ElevatedButton(
                  onPressed: () {
                    _uploadVideo();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                  child: createpostState.isUploading
                      ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white)),
                      )
                      : const Text('Create Post', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildVideoPlaceHolder() {
    return Column(
      children: [
        Container(
          width: 200,
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[200],
          ),
          child: GestureDetector(
            onTap: _pickVideo,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.videocam, size: 50, color: Colors.grey),
                  ref.watch(createPostProvider).isPickingVideo
                      ? const Text('Uploading video...',
                          style: TextStyle(color: Colors.grey))
                      : const Text('Add a video',
                          style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _uploadVideo() async {
    if (_formKey.currentState!.validate() && ref.read(createPostProvider).isUploading == false) {
      final result = await ref.read(createPostProvider.notifier).uploadVideo(
          _titleController.text, _hashtagController.text, _songController.text);

      if (result) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: 'Success',
                message: 'Video uploaded successfully',
                contentType: ContentType.success,
              ),
            ),
          );

        // NavigatorService.pushNamed(AppRoutes.homePage);
      } else {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: 'Oh Snap!',
                message: 'Failed to upload video',
                contentType: ContentType.failure,
              ),
            ),
          );
      }
    }
  }

  void _pickVideo() async {
    await ref.read(createPostProvider.notifier).pickVideo();
    if (ref.read(createPostProvider).videoFilePath.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video uploaded successfully')),
      );
    }
  }

  void _removeVideo() {
    ref.read(createPostProvider.notifier).removeVideo();
  }
}
