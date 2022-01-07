import 'package:fastguide/admin/screens/admin_home/chapter/contents/chapter_contents/chapter_content_list_tile.dart';
import 'package:fastguide/admin/screens/admin_home/chapter/contents/chapter_contents/edit_chapter_content_page.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/show_exception_alert_dialog.dart';
import 'package:fastguide/admin/screens/admin_home/cource/contents/course_contents/list_items_builder.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/chapter.dart';
import 'package:fastguide/admin/screens/admin_home/models/contents/chapter_content.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/admin/screens/admin_home/models/section.dart';
import 'package:fastguide/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChapterContentPageAdmin extends StatelessWidget {
  const ChapterContentPageAdmin({
    required this.database,
    required this.batch,
    required this.course,
    required this.section,
    required this.chapter,
  });
  final Database database;
  final Batch batch;
  final Course course;
  final Section section;
  final Chapter chapter;

  static Future<void> show(
    BuildContext context,
    Batch batch,
    Course course,
    Section section,
    Chapter chapter,
  ) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => ChapterContentPageAdmin(
          database: database,
          batch: batch,
          course: course,
          section: section,
          chapter: chapter,
        ),
      ),
    );
  }

  Future<void> _delete(
    BuildContext context,
    Batch batch,
    Course course,
    Section section,
    Chapter chapter,
    ChapterContent chapterContent,
  ) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteChapterContent(
          batch, course, section, chapter, chapterContent);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  Future<void> _deleteConfirm(
    BuildContext context,
    Batch batch,
    Course course,
    Section section,
    Chapter chapter,
    ChapterContent chapterContent,
  ) async {
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
                  context, batch, course, section, chapter, chapterContent);
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
    return StreamBuilder<Course>(
      stream: database.courseStream(
        jobId: batch.id,
        batchId: batch.id,
        courseId: course.id,
      ),
      builder: (context, snapshot) {
        final job = snapshot.data;
        final jobName = job?.courseName ?? '';
        var buildContents =
            _buildContents(context, batch, course, section, chapter);
        return Scaffold(
          appBar: AppBar(
            elevation: 2.0,
            title: Text(jobName + ' - Contents Page'),
            centerTitle: true,
            actions: <Widget>[
              // IconButton(
              //   icon: Icon(Icons.edit, color: Colors.white),
              //   onPressed: () => EditCoursePage.show(
              //     context,
              //     database: database,
              //     batch: batch,
              //     course: job,
              //   ),
              // ),
              IconButton(
                icon: Icon(Icons.add, color: Colors.white),
                onPressed: () => EditChapterContentPage.show(
                  context,
                  database: database,
                  batch: batch,
                  course: course,
                  section: section,
                  chapter: chapter,
                ),
              ),
            ],
          ),
          body: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            child: buildContents,
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
          itemBuilder: (context, chapterContent) => Dismissible(
            key: Key('job-${batch.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _deleteConfirm(
                context, batch, course, section, chapter, chapterContent),
            child: ChapterContentListTileAdmin(
              onTap: () => EditChapterContentPage.show(
                context,
                database: database,
                batch: batch,
                course: course,
                section: section,
                chapter: chapter,
                chapterContent: chapterContent,
              ),
              batch: batch,
              course: course,
              section: section,
              chapter: chapter,
              chapterContent: chapterContent,
            ),
          ),
        );
      },
    );
  }
}
