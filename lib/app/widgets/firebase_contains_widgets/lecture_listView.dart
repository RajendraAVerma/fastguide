
import 'package:fastguide/admin/screens/admin_home/lecture/lecture_list_tile.dart';
import 'package:fastguide/admin/screens/admin_home/lecture/list_items_builder.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/chapter.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/admin/screens/admin_home/models/lecture.dart';
import 'package:fastguide/admin/screens/admin_home/models/section.dart';
import 'package:fastguide/admin/screens/admin_home/models/topic.dart';
import 'package:fastguide/app/home/screens/batches_pages/video_lecture_screen.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget lectureListView(
  BuildContext context,
  Batch batch,
  Course course,
  Section section,
  Chapter chapter,
  Topic topic,
) {
  final database = Provider.of<Database>(context, listen: false);
  return StreamBuilder<List<Lecture>>(
    stream: database.lecturesStream(
        batchId: batch.id,
        courseId: course.id,
        sectionId: section.id,
        chapterId: chapter.id,
        topicId: topic.id),
    builder: (context, snapshot) {
      return ListItemsBuilder<Lecture>(
        snapshot: snapshot,
        itemBuilder: (context, lecture) => LectureListTile(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => VideoLectureScreenPage(
                  batch: batch,
                  course: course,
                  section: section,
                  chapter: chapter,
                  topic: topic,
                  lecture: lecture,
                ),
              ),
            );
          },
          lecture: lecture,
          chapter: chapter,
          topic: topic,
        ),
      );
    },
  );
}
