import 'package:fastguide/admin/screens/admin_home/common_widgets/show_exception_alert_dialog.dart';
import 'package:fastguide/admin/screens/admin_home/cource/contents/course_faqs/course_faqs_list_tile.dart';
import 'package:fastguide/admin/screens/admin_home/cource/contents/course_faqs/edit_course_faqs_page.dart';
import 'package:fastguide/admin/screens/admin_home/cource/contents/course_faqs/list_items_builder.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/contents/course_faqs.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CourseFAQsPageAdmin extends StatelessWidget {
  const CourseFAQsPageAdmin({
    required this.database,
    required this.batch,
    required this.course,
  });
  final Database database;
  final Batch batch;
  final Course course;

  static Future<void> show(
    BuildContext context,
    Batch batch,
    Course course,
  ) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => CourseFAQsPageAdmin(
          database: database,
          batch: batch,
          course: course,
        ),
      ),
    );
  }

  Future<void> _delete(BuildContext context, Batch batch, Course course,
      CourseFAQs courseFAQs) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteCourseFAQ(batch, course, courseFAQs);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  Future<void> _deleteConfirm(BuildContext context, Batch batch, Course course,
      CourseFAQs courseFAQs) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Confirm'),
        content: Text('Soch Le !!'),
        actions: <Widget>[
          FlatButton(
            onPressed: () async {
              await _delete(context, batch, course, courseFAQs);
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
        var buildContents = _buildContents(context, batch, course);
        return Scaffold(
          appBar: AppBar(
            elevation: 2.0,
            title: Text(jobName + ' - FAQs Page'),
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
                onPressed: () => EditCourseFAQsPage.show(
                  context,
                  database: database,
                  batch: batch,
                  course: course,
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
  ) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<CourseFAQs>>(
      stream: database.courseFAQsStream(batchId: batch.id, courseId: course.id),
      builder: (context, snapshot) {
        return ListItemsBuilder<CourseFAQs>(
          snapshot: snapshot,
          itemBuilder: (context, courseFAQs) => Dismissible(
            key: Key('job-${batch.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) =>
                _deleteConfirm(context, batch, course, courseFAQs),
            child: CourseFAQsListTileAdmin(
              onTap: () => EditCourseFAQsPage.show(
                context,
                database: database,
                batch: batch,
                course: course,
                courseFAQs: courseFAQs,
              ),
              batch: batch,
              course: course,
              courseFAQs: courseFAQs,
            ),
          ),
        );
      },
    );
  }
}
