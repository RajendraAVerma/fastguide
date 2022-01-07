import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastguide/admin/screens/admin_home/chapter/edit_chapter_page.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/show_exception_alert_dialog.dart';
import 'package:fastguide/admin/screens/admin_home/lecture/edit_lecture_page.dart';
import 'package:fastguide/admin/screens/admin_home/lecture/lecture_list_tile.dart';
import 'package:fastguide/admin/screens/admin_home/lecture/list_items_builder.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/chapter.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/admin/screens/admin_home/models/lecture.dart';
import 'package:fastguide/admin/screens/admin_home/models/section.dart';
import 'package:fastguide/admin/screens/admin_home/models/topic.dart';
import 'package:fastguide/admin/screens/admin_home/topic/edit_topic_page.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LecturePage extends StatelessWidget {
  const LecturePage(
      {required this.database,
      required this.batch,
      required this.course,
      required this.section,
      required this.chapter,
      required this.topic});
  final Database database;
  final Batch batch;
  final Course course;
  final Section section;
  final Chapter chapter;
  final Topic topic;

  static Future<void> show(BuildContext context, Batch batch, Course course,
      Section section, Chapter chapter, Topic topic) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => LecturePage(
            database: database,
            batch: batch,
            course: course,
            section: section,
            chapter: chapter,
            topic: topic),
      ),
    );
  }

  Future<void> _delete(BuildContext context, Batch batch, Course course,
      Section section, Chapter chapter, Topic topic, Lecture lecture) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteLecture(
          batch, course, section, chapter, topic, lecture);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  Future<void> _deleteConfirm(BuildContext context, Batch batch, Course course,
      Section section, Chapter chapter, Topic topic, Lecture lecture) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Confirm'),
        content: Text('Soch Le !!'),
        actions: <Widget>[
          FlatButton(
            onPressed: () async {
              await _delete(
                  context, batch, course, section, chapter, topic, lecture);
              Navigator.of(context, rootNavigator: true)
                  .pop(); // dismisses only the dialog and returns nothing
            },
            child: new Text('Delete'),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true)
                  .pop(); // dismisses only the dialog and returns nothing
            },
            child: new Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Topic>(
      stream: database.topicStream(
          jobId: batch.id,
          batchId: batch.id,
          courseId: course.id,
          sectionId: section.id,
          chapterId: chapter.id,
          topicId: topic.id),
      builder: (context, snapshot) {
        final job = snapshot.data;
        final jobName = job?.topicName ?? '';
        return Scaffold(
          appBar: AppBar(
            elevation: 2.0,
            title: Text(jobName),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: () => EditTopicPage.show(
                  context,
                  database: database,
                  batch: batch,
                  course: course,
                  section: section,
                  chapter: chapter,
                  topic: job,
                ),
              ),
              IconButton(
                icon: Icon(Icons.add, color: Colors.white),
                onPressed: () => EditLecturePage.show(
                  context,
                  database: database,
                  course: course,
                  section: section,
                  batch: batch,
                  chapter: chapter,
                  topic: job,
                ),
              ),
            ],
          ),
          body: _buildContents(
            context,
            batch,
            course,
            section,
            chapter,
            topic,
          ),
        );
      },
    );
  }

  Widget _buildContents(
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
          itemBuilder: (context, lecture) => Dismissible(
            key: Key('job-${batch.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _deleteConfirm(
                context, batch, course, section, chapter, topic, lecture),
            child: LectureListTileAdmin(
              onTap: () => EditLecturePage.show(
                context,
                database: database,
                batch: batch,
                course: course,
                section: section,
                chapter: chapter,
                topic: topic,
                lecture: lecture,
              ),
              lecture: lecture,
            ),
          ),
        );
      },
    );
  }
}
