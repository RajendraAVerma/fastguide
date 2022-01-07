import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChewieVideo extends StatefulWidget {
  ChewieVideo({Key? key}) : super(key: key);
  @override
  _ChewieVideoState createState() => _ChewieVideoState();
}

class _ChewieVideoState extends State<ChewieVideo> {
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    initializeVideoPlayer();
  }

  Future<void> initializeVideoPlayer() async {
    videoPlayerController = VideoPlayerController.network(
      'https://awanti.s3.ap-south-1.amazonaws.com/Wedding+Background_+Free+Background_HD+Free+Weddin.mp4',
    );
    await Future.wait([videoPlayerController!.initialize()]);
    _initializeVideoPlayerFuture = videoPlayerController!.initialize();
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController!,
      aspectRatio: 16 / 9,
      autoPlay: false,
      looping: false,
      // Try playing around with some of these other options:

      // showControls: false,
      materialProgressColors: ChewieProgressColors(
        //   playedColor: Colors.red,
        //   handleColor: Colors.blue,
        //   backgroundColor: Colors.grey,
        bufferedColor: Colors.orangeAccent,
        // ),
        // placeholder: Container(
        //   color: Colors.grey,
      ),
      autoInitialize: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: videoPlayerController!.value.aspectRatio,
              child: Chewie(
                controller: chewieController!,
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator(color: Colors.red));
          }
        },
      ),

      // Container(
      //   child: Center(
      //     child: chewieController != null &&
      //             chewieController!.videoPlayerController.value.isInitialized
      //         ? Chewie(
      //             controller: chewieController!,
      //           )
      //         : Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: const [
      //               CircularProgressIndicator(),
      //               SizedBox(height: 20),
      //               Text('Loading'),
      //             ],
      //           ),
      //   ),
      // ),
    );
  }

  @override
  void dispose() {
    videoPlayerController!.dispose();
    chewieController!.dispose();
    super.dispose();
  }
}
