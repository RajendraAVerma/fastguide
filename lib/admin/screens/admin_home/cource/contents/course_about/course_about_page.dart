import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/show_exception_alert_dialog.dart';
import 'package:fastguide/admin/screens/admin_home/cource/contents/course_about/course_about_list_tile.dart';
import 'package:fastguide/admin/screens/admin_home/cource/contents/course_about/edit_course_about_page.dart';
import 'package:fastguide/admin/screens/admin_home/cource/contents/course_about/list_items_builder.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/contents/course_about.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CourseAboutPageAdmin extends StatelessWidget {
  const CourseAboutPageAdmin({
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
        builder: (context) => CourseAboutPageAdmin(
          database: database,
          batch: batch,
          course: course,
        ),
      ),
    );
  }

  Future<void> _delete(BuildContext context, Batch batch, Course course,
      CourseAbout courseAbout) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteCourseAbout(batch, course, courseAbout);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  Future<void> _deleteConfirm(BuildContext context, Batch batch, Course course,
      CourseAbout courseAbout) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Confirm'),
        content: Text('Soch Le !!'),
        actions: <Widget>[
          FlatButton(
            onPressed: () async {
              await _delete(context, batch, course, courseAbout);
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
            title: Text(jobName + ' - About Page'),
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
                onPressed: () => EditCourseAboutPage.show(
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
    return StreamBuilder<List<CourseAbout>>(
      stream:
          database.courseAboutsStream(batchId: batch.id, courseId: course.id),
      builder: (context, snapshot) {
        return ListItemsBuilder<CourseAbout>(
          snapshot: snapshot,
          itemBuilder: (context, courseAbout) => Dismissible(
            key: Key('job-${batch.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _deleteConfirm(
              context,
              batch,
              course,
              courseAbout,
            ),
            child: CourseAboutListTileAdmin(
              onTap: () => EditCourseAboutPage.show(
                context,
                database: database,
                batch: batch,
                course: course,
                courseAbout: courseAbout,
              ),
              batch: batch,
              course: course,
              courseAbout: courseAbout,
            ),
          ),
        );
      },
    );
  }
}
