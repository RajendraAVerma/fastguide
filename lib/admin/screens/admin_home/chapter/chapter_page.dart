import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastguide/admin/screens/admin_home/chapter/chapter_list_tile.dart';
import 'package:fastguide/admin/screens/admin_home/chapter/edit_chapter_page.dart';
import 'package:fastguide/admin/screens/admin_home/chapter/list_items_builder.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/show_exception_alert_dialog.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/chapter.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/admin/screens/admin_home/models/section.dart';
import 'package:fastguide/admin/screens/admin_home/section/edit_section_page.dart';
import 'package:fastguide/admin/screens/admin_home/topic/topic_page.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChapterPageAdmin extends StatelessWidget {
  const ChapterPageAdmin({
    required this.database,
    required this.batch,
    required this.course,
    required this.section,
  });
  final Database database;
  final Batch batch;
  final Course course;
  final Section section;

  static Future<void> show(
    BuildContext context,
    Batch batch,
    Course course,
    Section section,
  ) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => ChapterPageAdmin(
          database: database,
          batch: batch,
          course: course,
          section: section,
        ),
      ),
    );
  }

  Future<void> _delete(BuildContext context, Batch batch, Course course,
      Section section, Chapter chapter) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteChapter(batch, course, section, chapter);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  Future<void> _deleteConfirm(BuildContext context, Batch batch, Course course,
      Section section, Chapter chapter) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Confirm'),
        content: Text('Soch Le !!'),
        actions: <Widget>[
          FlatButton(
            onPressed: () async {
              await _delete(context, batch, course, section, chapter);
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
    return StreamBuilder<Section>(
      stream: database.sectionStream(
        jobId: batch.id,
        batchId: batch.id,
        courseId: course.id,
        sectionId: section.id,
      ),
      builder: (context, snapshot) {
        final job = snapshot.data;
        final jobName = job?.sectionName ?? '';
        return Scaffold(
          appBar: AppBar(
            elevation: 2.0,
            title: Text(jobName),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: () => EditSectionPage.show(
                  context,
                  database: database,
                  batch: batch,
                  course: course,
                  section: job,
                ),
              ),
              IconButton(
                icon: Icon(Icons.add, color: Colors.white),
                onPressed: () => EditChapterPage.show(
                  context,
                  database: database,
                  batch: batch,
                  course: course,
                  section: job,
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              child: _buildContents(context, batch, course, section),
            ),
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
          itemBuilder: (context, chapter) => Dismissible(
            key: Key('job-${batch.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) =>
                _deleteConfirm(context, batch, course, section, chapter),
            child: CourceListTile(
              onTap: () =>
                  TopicPageAdmin.show(context, batch, course, section, chapter),
              chapter: chapter,
              course: course,
            ),
          ),
        );
      },
    );
  }
}
