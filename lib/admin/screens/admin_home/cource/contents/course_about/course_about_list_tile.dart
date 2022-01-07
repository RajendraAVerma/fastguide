import 'package:cached_network_image/cached_network_image.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/contents/course_about.dart';
import 'package:fastguide/admin/screens/admin_home/models/contents/course_content.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
import 'package:fastguide/app/widgets/custom_icon_button.dart';
import 'package:fastguide/app/widgets/pdf_viewer.dart';
import 'package:fastguide/app/widgets/video/youtube_iframe_player.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseAboutListTile extends StatelessWidget {
  const CourseAboutListTile({
    Key? key,
    required this.batch,
    required this.course,
    required this.courseAbout,
    this.onTap,
  }) : super(key: key);
  final Batch batch;
  final Course course;
  final CourseAbout? courseAbout;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return listTileText(context);
  }

  Widget listTileText(BuildContext context) {
    String themeColor1FromFirebase = course.themeColor1;
    int themeColor1Int = int.parse(themeColor1FromFirebase);
    String themeColor2FromFirebase = course.themeColor2;
    int themeColor2Int = int.parse(themeColor2FromFirebase);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5.0,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.black38),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            gradientText(
              text: batch.tag + "  " + batch.batchName,
              color1: Color(themeColor2Int),
              color2: Color(themeColor1Int),
              fontFamily: 'Poppins',
              fontSize: 20,
            ),
            SizedBox(height: 10),
            Divider(),
            Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
              ),
              child: CachedNetworkImage(
                imageUrl: courseAbout!.imgLink1,
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
            SizedBox(height: 10),
            gradientText(
              text: 'Description :  ' + courseAbout!.discription,
              color1: Colors.black,
              color2: Colors.black,
              fontFamily: 'Mukta',
              fontSize: 15,
            ),
          ],
        ),
      ),
    );
  }
}

class CourseAboutListTileAdmin extends StatelessWidget {
  const CourseAboutListTileAdmin({
    Key? key,
    required this.batch,
    required this.course,
    required this.courseAbout,
    this.onTap,
  }) : super(key: key);
  final Batch batch;
  final Course course;
  final CourseAbout? courseAbout;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _listTileBuilder();
  }

  ListTile _listTileBuilder() {
    return ListTile(
      title: Text(courseAbout!.discription),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
