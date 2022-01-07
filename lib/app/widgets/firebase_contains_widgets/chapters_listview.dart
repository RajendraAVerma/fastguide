import 'package:fastguide/admin/screens/admin_home/chapter/chapter_list_tile.dart';
import 'package:fastguide/admin/screens/admin_home/chapter/list_items_builder.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/chapter.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/admin/screens/admin_home/models/section.dart';
import 'package:fastguide/app/home/screens/batches_pages/topic_page.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget chapterListView(
  BuildContext context,
  Batch batch,
  Course course,
  Section section,
) {
  final database = Provider.of<Database>(context, listen: false);
  return StreamBuilder<List<Chapter>>(
    stream: database.chaptersStream(
      batchId: batch.id,
      courseId: course.id,
      sectionId: section.id,
    ),
    builder: (context, snapshot) {
      return ListItemsBuilder<Chapter>(
        snapshot: snapshot,
        itemBuilder: (context, chapter) => CourceListTile(
          onTap: () => TopicPage.show(context, batch, course, section, chapter),
          chapter: chapter,
          course: course,
        ),
      );
    },
  );
}
