import 'package:cached_network_image/cached_network_image.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/chapter.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/admin/screens/admin_home/models/section.dart';
import 'package:fastguide/admin/screens/admin_home/models/topic.dart';
import 'package:fastguide/app/home/screens/batches_pages/common_widget/ask_q_or_subscribe_button.dart';
import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
import 'package:fastguide/app/widgets/custom_icon_button.dart';
import 'package:fastguide/app/widgets/firebase_contains_widgets/lecture_listView.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LectureScreenPage extends StatefulWidget {
  LectureScreenPage({
    required this.batch,
    required this.course,
    required this.section,
    required this.chapter,
    required this.topic,
  });
  final Batch batch;
  final Course course;
  final Section section;
  final Chapter chapter;
  final Topic topic;

  static Future<void> show(
    BuildContext context,
    Batch batch,
    Course course,
    Section section,
    Chapter chapter,
    Topic topic,
  ) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => LectureScreenPage(
          batch: batch,
          course: course,
          chapter: chapter,
          section: section,
          topic: topic,
        ),
      ),
    );
  }

  @override
  _LectureScreenPageState createState() => _LectureScreenPageState();
}

class _LectureScreenPageState extends State<LectureScreenPage> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.topic.introLink)!,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        forceHD: true,
        hideThumbnail: false,
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return youtubeHirarchy();
  }

  youtubeHirarchy() {
    String themeColor1FromFirebase = widget.course.themeColor1;
    int themeColor1Int = int.parse(themeColor1FromFirebase);

    return Column(
      children: [
        Container(
          child: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  alignment: Alignment.topRight,
                  image: AssetImage('assets/images/bg.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            title: _appBarRow(context, themeColor1Int),
          ),
        ),
        Expanded(
          child: Scaffold(
            body: _buildContent(context),
          ),
        )
      ],
    );
  }

  Row _appBarRow(BuildContext context, int themeColor1Int) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CustomIconButton(
          color: Colors.white,
          elevation: 2.0,
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.arrow_back_rounded,
            color: Color(themeColor1Int),
          ),
        ),
        SizedBox(width: 5.0),
        Expanded(
          child: Container(
            child: gradientText(
              text: 'Chapter ' + widget.chapter.chapterNo.toString(),
              color1: Colors.black54,
              color2: Colors.black54,
              fontFamily: "Roboto",
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
        CustomIconTextButton(
          icon: Icon(Icons.add),
          onTap: () {},
          text: askQuestion_or_SubScribe_button(
            context: context,
            batch: widget.batch,
            course: widget.course,
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10.0),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _topicDetails(),
                    Divider(),
                    lectureListView(context, widget.batch, widget.course,
                        widget.section, widget.chapter, widget.topic),
                    SizedBox(height: 10.0),
                    Divider(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topicDetails() {
    String themeColor1FromFirebase = widget.course.themeColor1;
    int themeColor1Int = int.parse(themeColor1FromFirebase);
    String themeColor2FromFirebase = widget.course.themeColor2;
    int themeColor2Int = int.parse(themeColor2FromFirebase);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 120.0,
            width: 120.0,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: CachedNetworkImage(
              imageUrl: widget.topic.iconLink,
              imageBuilder: (context, imageProvider) =>
                  Image(image: imageProvider),
              placeholder: (context, url) => SizedBox(
                height: 100.0,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade400,
                  highlightColor: Colors.white,
                  child: Image(
                    height: 100.0,
                    image: AssetImage("assets/images/image_placeholder.png"),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Image(
                height: 100.0,
                image: AssetImage("assets/images/image_placeholder.png"),
              ),
            ),
          ),
          SizedBox(width: 7.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                gradientText(
                  text: 'Topic ',
                  color1: Color(themeColor1Int),
                  color2: Color(themeColor2Int),
                  fontFamily: "Mukta",
                  fontSize: 15.0,
                  fontWeight: FontWeight.w800,
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(themeColor1Int),
                        Color(themeColor2Int),
                      ],
                    ),
                  ),
                  child: Text(
                    widget.topic.topicNo.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: gradientText(
                    text: widget.topic.topicName,
                    color1: Colors.black,
                    color2: Colors.black87,
                    fontFamily: "Mukta",
                    fontSize: 20.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
