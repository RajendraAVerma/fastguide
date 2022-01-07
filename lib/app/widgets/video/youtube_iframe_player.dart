import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YouTubeiFramePlayer extends StatefulWidget {
  final String youtubeVideoId;

  const YouTubeiFramePlayer({Key? key, required this.youtubeVideoId})
      : super(key: key);
  @override
  _YouTubeiFramePlayerState createState() => _YouTubeiFramePlayerState();
}

class _YouTubeiFramePlayerState extends State<YouTubeiFramePlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.youtubeVideoId,
      params: YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        desktopMode: false,
        privacyEnhanced: true,
        useHybridComposition: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const player = YoutubePlayerIFrame();
    return YoutubePlayerControllerProvider(
      controller: _controller,
      child: YoutubeValueBuilder(
        controller: _controller,
        builder: (context, value) {
          return player;
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}

///
