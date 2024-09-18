import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:logger/logger.dart';

class MyVideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final VoidCallback onRemove;

  const MyVideoPlayerWidget(
      {Key? key, required this.videoUrl, required this.onRemove})
      : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<MyVideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller.setLooping(true);
        _controller.play();
      }).catchError((error) {
        Logger().e('Error initializing video: $error');
        setState(() {
          _isInitialized = false;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return _isInitialized
        ? Column(
            children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  widget.onRemove();
                  _controller.pause();
                  _controller.dispose();
                  setState(() {
                    _isInitialized = false;
                  });
                },
                child: const Text('Remove video'),
              ),
            ],
          )
        : const Center(child: CircularProgressIndicator());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
