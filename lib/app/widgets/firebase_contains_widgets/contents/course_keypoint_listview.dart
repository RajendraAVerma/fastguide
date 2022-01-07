import 'package:fastguide/admin/screens/admin_home/cource/contents/course_key_points/course_key_points_list_tile.dart';
import 'package:fastguide/admin/screens/admin_home/cource/contents/course_key_points/list_items_builder.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/contents/course_key_points.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget courseKeyPointListView(
  BuildContext context,
  Batch batch,
  Course course,
) {
  final database = Provider.of<Database>(context, listen: false);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      gradientText(
        text: "Key Point Of Course ( पाठ्यक्रम का मुख्य बिंदु )",
        color1: Colors.red,
        color2: Colors.redAccent,
        fontFamily: "Mukta",
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      StreamBuilder<List<CourseKeyPoints>>(
        stream: database.courseKeyPointsStream(
            batchId: batch.id, courseId: course.id),
        builder: (context, snapshot) {
          return ListItemsBuilder<CourseKeyPoints>(
            snapshot: snapshot,
            itemBuilder: (context, courseKeyPoints) =>
                CourseKeyPointsListTileAdmin(
              onTap: () {},
              batch: batch,
              course: course,
              courseKeyPoints: courseKeyPoints,
            ),
          );
        },
      ),
    ],
  );
}
