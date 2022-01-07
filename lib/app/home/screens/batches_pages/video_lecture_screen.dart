import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/chapter.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/admin/screens/admin_home/models/lecture.dart';
import 'package:fastguide/admin/screens/admin_home/models/section.dart';
import 'package:fastguide/admin/screens/admin_home/models/topic.dart';
import 'package:fastguide/app/home/screens/batches_pages/common_widget/ask_q_or_subscribe_button.dart';
import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
import 'package:fastguide/app/widgets/custom_icon_button.dart';
import 'package:fastguide/app/widgets/firebase_contains_widgets/lecture_listView.dart';
import 'package:fastguide/app/widgets/pdf_viewer.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoLectureScreenPage extends StatefulWidget {
  VideoLectureScreenPage({
    required this.batch,
    required this.course,
    required this.section,
    required this.chapter,
    required this.topic,
    required this.lecture,
  });
  final Batch batch;
  final Course course;
  final Section section;
  final Chapter chapter;
  final Topic topic;
  final Lecture lecture;

  static Future<void> show(
    BuildContext context,
    Batch batch,
    Course course,
    Section section,
    Chapter chapter,
    Topic topic,
    Lecture lecture,
  ) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => VideoLectureScreenPage(
          batch: batch,
          course: course,
          chapter: chapter,
          section: section,
          topic: topic,
          lecture: lecture,
        ),
      ),
    );
  }

  @override
  _VideoLectureScreenPageState createState() => _VideoLectureScreenPageState();
}

class _VideoLectureScreenPageState extends State<VideoLectureScreenPage> {
  YoutubePlayerController? _controller;

  // Future<void> secureScreen() async {
  //   await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  // }

  // Future<void> clearSecureScreen() async {
  //   await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  // }

  @override
  void initState() {
    _controller = YoutubePlayerController(
        flags: YoutubePlayerFlags(
          autoPlay: true,
          forceHD: true,
          hideThumbnail: false,
        ),
        initialVideoId:
            YoutubePlayer.convertUrlToId(widget.lecture.lectureVideoLink)!);

    //secureScreen();
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    //clearSecureScreen();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return youtubeHirarchy();
  }

  youtubeHirarchy() {
    String themeColor1FromFirebase = widget.course.themeColor1;
    int themeColor1Int = int.parse(themeColor1FromFirebase);
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        aspectRatio: 14 / 7,
        controller: _controller!,
      ),
      builder: (context, player) {
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
            player,
            Expanded(
              child: Scaffold(
                body: _buildContent(context),
              ),
            )
          ],
        );
      },
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
        SizedBox(width: 10.0),
        gradientText(
          text: '',
          color1: Colors.black87,
          color2: Colors.black54,
          fontFamily: "Roboto",
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        Spacer(),
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
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SingleChildScrollView(
              child: GestureDetector(
                onTap: () {
                  _bottomSheetDescription(context);
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.only(
                    //   bottomLeft: Radius.circular(20.0),
                    //   bottomRight: Radius.circular(20.0),
                    // ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 1.0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomIconButton2(
                            elevation: 20.0,
                            color: widget.lecture.lectureType == 0
                                ? Color(0xffeb3349)
                                : Color(0xfff45c43),
                            onTap: () {},
                            child: Text(
                              widget.lecture.lectureNo.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      widget.lecture.lectureName,
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Mukta',
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        gradientText(
                                          text: widget.chapter.chapterName +
                                              '  |  ' +
                                              widget.topic.topicName,
                                          color1: Colors.black54,
                                          color2: Colors.black54,
                                          fontFamily: 'Mukta',
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 5.0),
                          Icon(
                            Icons.arrow_drop_down_circle_outlined,
                            size: 30.0,
                            color: Colors.blue.shade900,
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Divider(),
                      SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _iconWidget(
                            logoPath: 'assets/images/link.png',
                            onTap: () => _launchURL(
                              url: widget.lecture.lectureButtonLink1,
                            ),
                            text: 'LINK',
                          ),
                          _iconWidget(
                            logoPath: 'assets/images/screenshot.png',
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PDFviewer(
                                  link: widget.lecture.lectureButtonLink2,
                                  title: widget.lecture.lectureName,
                                  color: 0xffffd200,
                                ),
                              ),
                            ),
                            text: 'SLIDE',
                          ),
                          _iconWidget(
                            logoPath: 'assets/images/notes.png',
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PDFviewer(
                                  link: widget.lecture.lectureButtonLink3,
                                  title: widget.lecture.lectureName,
                                  color: 0xff26c6da,
                                ),
                              ),
                            ),
                            text: 'NOTES',
                          ),
                          _iconWidget(
                            logoPath: 'assets/images/share.png',
                            onTap: () => Share.share(
                                'Download FastGuide App :-  https://fastguide.in/download-app',
                                subject:
                                    'FastGuide - Self Directed Learning App !'),
                            text: 'SHARE',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: lectureListView(
                context,
                widget.batch,
                widget.course,
                widget.section,
                widget.chapter,
                widget.topic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL({required String url}) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  Widget _iconWidget({
    VoidCallback? onTap,
    required String logoPath,
    required String text,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 70.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          children: [
            Image(
              fit: BoxFit.cover,
              image: AssetImage(logoPath),
            ),
            SizedBox(height: 2.5),
            Text(
              text,
              style: TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _bottomSheetDescription(BuildContext context) {
    String themeColor1FromFirebase = widget.course.themeColor1;
    int themeColor1Int = int.parse(themeColor1FromFirebase);
    String themeColor2FromFirebase = widget.course.themeColor2;
    int themeColor2Int = int.parse(themeColor2FromFirebase);
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 20.0,
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          height: MediaQuery.of(context).size.height - 350.0,
          child: Column(
            //mainAxisSize: MainAxisSize.values.last,
            children: <Widget>[
              Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Center(
                            child: Divider(
                          color: Colors.black45,
                          thickness: 5.0,
                        )),
                        width: 50,
                      ),
                    ),
                    ListTile(
                      title: gradientText(
                        text: "Description",
                        color1: Color(themeColor1Int),
                        color2: Color(themeColor2Int),
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                      trailing: Icon(Icons.cancel),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    Container(child: Divider()),
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                child: Column(
                  children: [
                    Text(widget.lecture.lectureDiscription),
                  ],
                ),
              ))
            ],
          ),
        );
      },
    );
  }
}
