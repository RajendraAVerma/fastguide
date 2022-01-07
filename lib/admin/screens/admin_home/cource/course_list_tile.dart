import 'package:cached_network_image/cached_network_image.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/app/home/screens/batches_pages/common_widget/is_subcribed_course.dart';
import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CourceListTile extends StatelessWidget {
  const CourceListTile(
      {Key? key, required this.course, this.onTap, required this.batch})
      : super(key: key);
  final Course course;
  final Batch batch;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _gridTile(context);
  }

  ListTile _listTile() {
    return ListTile(
      title: Text(course.courseName),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _gridTile(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: _buildMainContainer(context),
    );
  }

  Widget _buildMainContainer(BuildContext context) {
    return Container(
      //decoration: BoxDecoration(color: Colors.yellow),
      child: _buildColumn(context),
    );
  }

  Widget _buildColumn(BuildContext context) {
    String themeColor1FromFirebase = course.themeColor1;
    int themeColor1Int = int.parse(themeColor1FromFirebase);
    String themeColor2FromFirebase = course.themeColor2;
    int themeColor2Int = int.parse(themeColor2FromFirebase);
    return Container(
      child: isSubcribeCourse(
        context: context,
        batch: batch,
        course: course,
        isSubSuscribedWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(themeColor2Int),
                    Color(themeColor1Int),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Container(
                padding: EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Container(
                  padding: EdgeInsets.all(20.0),
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
                  child: CachedNetworkImage(
                    imageUrl: course.boxIconLink,
                    imageBuilder: (context, imageProvider) =>
                        Image(image: imageProvider),
                    placeholder: (context, url) => SizedBox(
                      height: 50.0,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade400,
                        highlightColor: Colors.white,
                        child: Image(
                          height: 50.0,
                          image:
                              AssetImage("assets/images/image_placeholder.png"),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Image(
                      height: 100.0,
                      image: AssetImage("assets/images/image_placeholder.png"),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            gradientText(
              text: course.courseName,
              color1: Colors.black87,
              color2: Colors.black54,
              fontFamily: "Mukta",
              fontSize: 15.0,
              fontWeight: FontWeight.w800,
            ),
            SizedBox(height: 7.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 3.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(themeColor1Int),
                    Color(themeColor2Int),
                  ],
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
              child: gradientText(
                text: "Premium",
                color1: Colors.white,
                color2: Colors.white,
                fontFamily: 'Mukta',
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        isNotSubSuscribedWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(20.0),
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
                boxShadow: [
                  BoxShadow(
                    color: Color(themeColor1Int),
                    offset: Offset(0.0, 0.0),
                    blurRadius: 3.0,
                  ),
                ],
              ),
              child: CachedNetworkImage(
                imageUrl: course.boxIconLink,
                imageBuilder: (context, imageProvider) =>
                    Image(image: imageProvider),
                placeholder: (context, url) => SizedBox(
                  height: 50.0,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade400,
                    highlightColor: Colors.white,
                    child: Image(
                      height: 50.0,
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
            SizedBox(height: 10.0),
            gradientText(
              text: course.courseName,
              color1: Colors.black87,
              color2: Colors.black54,
              fontFamily: "Mukta",
              fontSize: 15.0,
              fontWeight: FontWeight.w800,
            ),
            SizedBox(height: 7.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 6.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black54,
                    Colors.black54,
                  ],
                ),
                borderRadius: BorderRadius.circular(2.0),
              ),
              child: Center(
                child: Text(
                  "Not Subscribed",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    height: 1.0,
                    fontFamily: 'Mukta',
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourceListTileAdmin extends StatelessWidget {
  const CourceListTileAdmin({Key? key, required this.course, this.onTap})
      : super(key: key);
  final Course? course;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _listTile();
  }

  ListTile _listTile() {
    return ListTile(
      title: Text(course!.courseName),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
