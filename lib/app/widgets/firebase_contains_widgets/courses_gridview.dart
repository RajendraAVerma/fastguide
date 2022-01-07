import 'package:fastguide/admin/screens/admin_home/cource/course_list_tile.dart';
import 'package:fastguide/admin/screens/admin_home/cource/list_items_builder.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/app/home/screens/batches_pages/sections_and_chapter_page.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget coursesGridView(
  BuildContext context,
  Batch batch,
) {
  final database = Provider.of<Database>(context, listen: false);
  return StreamBuilder<List<Course>>(
    stream: database.coursesStream(batchId: batch.id),
    builder: (context, snapshot) {
      return ListItemsBuilder<Course>(
        snapshot: snapshot,
        itemBuilder: (context, course) => CourceListTile(
          onTap: () => SectionAndChapterPage.show(context, batch, course),
          course: course,
          batch: batch,
        ),
      );
    },
  );
}
