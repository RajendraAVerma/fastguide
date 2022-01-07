import 'package:fastguide/admin/screens/admin_home/cource/contents/course_contents/course_content_list_tile.dart';
import 'package:fastguide/admin/screens/admin_home/cource/contents/course_contents/list_items_builder.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/contents/course_content.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget courseContentListView(
  BuildContext context,
  Batch batch,
  Course course,
) {
  final database = Provider.of<Database>(context, listen: false);
  return StreamBuilder<List<CourseContent>>(
    stream:
        database.courseContentsStream(batchId: batch.id, courseId: course.id),
    builder: (context, snapshot) {
      return ListItemsBuilder<CourseContent>(
        snapshot: snapshot,
        itemBuilder: (context, courseContent) => CourseContentListTile(
          onTap: () {},
          batch: batch,
          course: course,
          courseContent: courseContent,
        ),
      );
    },
  );
}
