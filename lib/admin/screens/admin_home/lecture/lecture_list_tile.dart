import 'package:cached_network_image/cached_network_image.dart';
import 'package:fastguide/admin/screens/admin_home/models/chapter.dart';
import 'package:fastguide/admin/screens/admin_home/models/lecture.dart';
import 'package:fastguide/admin/screens/admin_home/models/topic.dart';
import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
import 'package:fastguide/app/widgets/listtile_widget.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LectureListTile extends StatelessWidget {
  const LectureListTile(
      {Key? key,
      required this.lecture,
      required this.onTap,
      required this.chapter,
      required this.topic})
      : super(key: key);
  final Lecture lecture;
  final Chapter chapter;
  final Topic topic;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return youtubeStyle();
  }

  ListTile _listTileBuilder() {
    return ListTile(
      title: Text(lecture.lectureName),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget newMethod() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        child: myListTileWidget(
          title: " ${lecture.lectureNo}.  ${lecture.lectureName}",
          subTitle: "Video No. : ${lecture.lectureNo}",
          color1: lecture.lectureType == 0 ? Colors.blue : Colors.pink,
          color2: lecture.lectureType == 0 ? Colors.blueAccent : Colors.pink,
          onTap: onTap!,
          opTapIcon: Icon(
            Icons.play_arrow,
            color: Colors.black,
          ),
          iconLink: lecture.lectureIcon,
        ),
      ),
    );
  }

  Widget youtubeStyle() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xff56ab2f),
                      Color(0xffa8e063),
                    ],
                  ),
                ),
                child: CachedNetworkImage(
                  imageUrl: lecture.lectureIcon,
                  imageBuilder: (context, imageProvider) =>
                      Image(image: imageProvider),
                  placeholder: (context, url) => SizedBox(
                    height: 100.0,
                    child: Shimmer.fromColors(
                        baseColor: Colors.blueAccent,
                        highlightColor: Colors.white,
                        child: Container(
                          color: Colors.black,
                        )),
                  ),
                  errorWidget: (context, url, error) => Container(
                    child: Center(
                      child: gradientText(
                        text: 'Video No. - ' + lecture.lectureNo.toString(),
                        color1: Colors.white,
                        color2: Colors.white,
                        fontFamily: 'Mukta',
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xffeb3349),
                          Color(0xfff45c43),
                        ],
                      ),
                    ),
                    child: Text(
                      lecture.lectureNo.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
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
                          gradientText(
                            text: lecture.lectureName,
                            color1: Colors.black,
                            color2: Colors.black,
                            fontFamily: 'Mukta',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: 7.0),
                          gradientText(
                            text:
                                chapter.chapterName + '  |  ' + topic.topicName,
                            color1: Colors.black54,
                            color2: Colors.black54,
                            fontFamily: 'Mukta',
                            fontSize: 12.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}

class LectureListTileAdmin extends StatelessWidget {
  const LectureListTileAdmin(
      {Key? key, required this.lecture, required this.onTap})
      : super(key: key);
  final Lecture? lecture;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _listTileBuilder();
  }

  ListTile _listTileBuilder() {
    return ListTile(
      title: Text(lecture!.lectureName),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
