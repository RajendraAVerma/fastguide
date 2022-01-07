import 'package:cached_network_image/cached_network_image.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/chapter.dart';
import 'package:fastguide/admin/screens/admin_home/models/contents/chapter_content.dart';
import 'package:fastguide/admin/screens/admin_home/models/contents/course_content.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/admin/screens/admin_home/models/section.dart';
import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
import 'package:fastguide/app/widgets/custom_icon_button.dart';
import 'package:fastguide/app/widgets/pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseContentListTile extends StatelessWidget {
  const CourseContentListTile({
    Key? key,
    required this.batch,
    required this.course,
    required this.courseContent,
    this.onTap,
  }) : super(key: key);
  final Batch batch;
  final Course course;
  final CourseContent? courseContent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final _contentType = courseContent!.type;
    if (_contentType == 0) {
      return listTilePDF(context);
    } else if (_contentType == 1) {
      return listTileImages();
    } else if (_contentType == 2) {
      return listTileLink();
    } else if (_contentType == 3) {
      return listTileText();
    }
    return listTileText();
  }

  Widget listTilePDF(BuildContext context) {
    String themeColor1FromFirebase = course.themeColor1;
    int themeColor1Int = int.parse(themeColor1FromFirebase);
    // String themeColor2FromFirebase = course.themeColor2;
    // int themeColor2Int = int.parse(themeColor2FromFirebase);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 15.0),
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black38),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          leading: Container(
            child: Image(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/pdf.png'),
            ),
          ),
          title: gradientText(
            text: courseContent!.title,
            color1: Colors.black87,
            color2: Colors.black,
            fontFamily: 'Poppins',
            fontSize: 14.0,
            fontWeight: FontWeight.w700,
          ),
          subtitle: Text(
            courseContent!.time,
            style: TextStyle(color: Colors.black, fontSize: 10.0),
          ),
          trailing: CustomIconButton(
            elevation: 2.0,
            color: Color(themeColor1Int),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PDFviewer(
                  link: courseContent!.link,
                  title: courseContent!.title,
                  color: themeColor1Int,
                ),
              ),
            ),
            child: Icon(
              Icons.download_outlined,
              color: Colors.white,
            ),
          ),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PDFviewer(
                link: courseContent!.link,
                title: courseContent!.title,
                color: themeColor1Int,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget listTileImages() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 15.0),
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black38),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              courseContent!.title,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontFamily: "Poppins",
              ),
            ),
            Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
              ),
              child: CachedNetworkImage(
                imageUrl: courseContent!.link,
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
            Text(
              courseContent!.time,
              style: TextStyle(color: Colors.black, fontSize: 10.0),
            )
          ],
        ),
      ),
    );
  }

  Widget listTileLink() {
    void _launchURL({required String url}) async => await canLaunch(url)
        ? await launch(url)
        : throw 'Could not launch $url';
    String themeColor1FromFirebase = course.themeColor1;
    int themeColor1Int = int.parse(themeColor1FromFirebase);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 15.0),
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black38),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              leading: Container(
                child: Image(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/link1.png'),
                ),
              ),
              title: gradientText(
                text: courseContent!.title,
                color1: Colors.black87,
                color2: Colors.black,
                fontFamily: 'Roboto',
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
              ),
              subtitle: Text(
                courseContent!.time,
                style: TextStyle(color: Colors.black, fontSize: 10.0),
              ),
              trailing: CustomIconButton(
                elevation: 2.0,
                color: Color(themeColor1Int),
                onTap: () => _launchURL(
                  url: courseContent!.link,
                ),
                child: Icon(
                  Icons.link,
                  color: Colors.white,
                ),
              ),
              onTap: () => _launchURL(
                url: courseContent!.link,
              ),
            ),
            Text(
              courseContent!.time,
              style: TextStyle(color: Colors.black, fontSize: 10.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget listTileText() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 15.0),
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black38),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              leading: Container(
                child: Image(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/quote.png'),
                ),
              ),
              title: gradientText(
                text: courseContent!.title,
                color1: Colors.black87,
                color2: Colors.black,
                fontFamily: 'Roboto',
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
              ),
              subtitle: gradientText(
                text: courseContent!.link,
                color1: Colors.black87,
                color2: Colors.black,
                fontFamily: 'Roboto',
                fontSize: 14.0,
              ),
            ),
            Text(
              courseContent!.time,
              style: TextStyle(color: Colors.black, fontSize: 10.0),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseContentListTileAdmin extends StatelessWidget {
  const CourseContentListTileAdmin({
    Key? key,
    required this.batch,
    required this.course,
    required this.courseContent,
    this.onTap,
  }) : super(key: key);
  final Batch batch;
  final Course course;
  final CourseContent? courseContent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _listTileBuilder();
  }

  ListTile _listTileBuilder() {
    return ListTile(
      title: Text(courseContent!.title),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
