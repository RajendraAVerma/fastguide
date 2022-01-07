import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Video extends StatefulWidget {
  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {

  
  String? videoURL = "https://www.youtube.com/watch?v=K9Fa4UW704g";

  YoutubePlayerController? _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(videoURL!)!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _willPopCallback() async {
      return true;
    }

    @override
    void dispose() {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      super.dispose();
    }

    return WillPopScope(
      onWillPop: _willPopCallback,
      child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
        if (orientation == Orientation.landscape) {
          return Scaffold(
            body: youtubeHirarchy(),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text("fgdfg"),
            ),
            body: youtubeHirarchy(),
          );
        }
      }),
    );



  }

  youtubeHirarchy() {
    return Container(
      margin: const EdgeInsets.all(100.0),
      // padding: const EdgeInsets.all(100.0),
      child: Container(
        child: Align(
          alignment: Alignment.center,
          child: YoutubePlayer(
            controller: _controller!,
          ),
        ),
      ),
    );
  }

}
