import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/contents/course_key_points.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
import 'package:flutter/material.dart';

class CourseKeyPointsListTileAdmin extends StatelessWidget {
  const CourseKeyPointsListTileAdmin({
    Key? key,
    required this.batch,
    required this.course,
    required this.courseKeyPoints,
    this.onTap,
  }) : super(key: key);
  final Batch batch;
  final Course course;
  final CourseKeyPoints? courseKeyPoints;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _listTileBuilder();
  }

  Widget _listTileBuilder() {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              Icons.circle,
              color: Colors.red,
              size: 15.0,
            ),
            SizedBox(width: 15.0),
            gradientText(
              text: courseKeyPoints!.keyPoint,
              color1: Colors.black,
              color2: Colors.black87,
              fontFamily: "Mukta",
              fontSize: 15,
            ),
          ],
        ),
      ),
    );
  }
}
