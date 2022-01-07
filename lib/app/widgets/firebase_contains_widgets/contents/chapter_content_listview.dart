 import 'package:fastguide/admin/screens/admin_home/chapter/contents/chapter_contents/chapter_content_list_tile.dart';
import 'package:fastguide/admin/screens/admin_home/chapter/contents/chapter_contents/list_items_builder.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/chapter.dart';
import 'package:fastguide/admin/screens/admin_home/models/contents/chapter_content.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/admin/screens/admin_home/models/section.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget chapterContentListView(
    BuildContext context,
    Batch batch,
    Course course,
    Section section,
    Chapter chapter,
  ) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<ChapterContent>>(
      stream: database.chapterContentsStream(
        batchId: batch.id,
        courseId: course.id,
        sectionId: section.id,
        chapterId: chapter.id,
      ),
      builder: (context, snapshot) {
        return ListItemsBuilder<ChapterContent>(
          snapshot: snapshot,
          itemBuilder: (context, chapterContent) => ChapterContentListTile(
            onTap: () {},
            batch: batch,
            course: course,
            section: section,
            chapter: chapter,
            chapterContent: chapterContent,
          ),
        );
      },
    );
  }