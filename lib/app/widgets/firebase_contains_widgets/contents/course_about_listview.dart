 import 'package:fastguide/admin/screens/admin_home/cource/contents/course_about/course_about_list_tile.dart';
import 'package:fastguide/admin/screens/admin_home/cource/contents/course_about/list_items_builder.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/contents/course_about.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget courseAboutListView(
    BuildContext context,
    Batch batch,
    Course course,
  ) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<CourseAbout>>(
      stream:
          database.courseAboutsStream(batchId: batch.id, courseId: course.id),
      builder: (context, snapshot) {
        return ListItemsBuilder<CourseAbout>(
          snapshot: snapshot,
          itemBuilder: (context, courseAbout) => CourseAboutListTile(
            onTap: () {},
            batch: batch,
            course: course,
            courseAbout: courseAbout,
          ),
        );
      },
    );
  }