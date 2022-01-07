import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChewieVideoPlayer extends StatefulWidget {
  final String videoLink;

  const ChewieVideoPlayer({Key? key, required this.videoLink}) : super(key: key);
  @override
  _ChewieVideoPlayerState createState() => _ChewieVideoPlayerState();
}

class _ChewieVideoPlayerState extends State<ChewieVideoPlayer> {
  VideoPlayerController? _videoPlayerController1;
  ChewieController? _chewieController;

  Future<void> initializeVideoPlayer() async {
    await Future.wait([_videoPlayerController1!.initialize()]);
  }

  @override
  void initState() {
    initializeVideoPlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _videoPlayerController1 = VideoPlayerController.network(
      widget.videoLink,
    );
    _chewieController = ChewieController(
      placeholder: Container(
        color: Colors.amberAccent,
      ),
      videoPlayerController: _videoPlayerController1!,
      overlay: Container(
        alignment: Alignment.topRight,
        child: Container(
          padding: EdgeInsets.all(5.0),
          color: Colors.white,
          child: Text("FastGuide"),
        ),
      ),
      aspectRatio: 16 / 9,
      autoPlay: false,
      looping: false,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.blue,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.orangeAccent,
      ),
      autoInitialize: true,
    );

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Chewie(
        controller: _chewieController!,
      ),
    );
  }

  @override
  void dispose() {
    _chewieController!.pause();
    _chewieController!.dispose();
    _videoPlayerController1!.dispose();
    super.dispose();
  }
}
