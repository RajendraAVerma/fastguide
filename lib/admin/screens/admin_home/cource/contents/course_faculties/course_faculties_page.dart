import 'package:fastguide/admin/screens/admin_home/common_widgets/show_exception_alert_dialog.dart';
import 'package:fastguide/admin/screens/admin_home/cource/contents/course_faculties/course_faculties_list_tile.dart';
import 'package:fastguide/admin/screens/admin_home/cource/contents/course_faculties/edit_course_faculties_page.dart';
import 'package:fastguide/admin/screens/admin_home/cource/contents/course_faculties/list_items_builder_admin.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/contents/course_facalties.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CourseFacultiesPageAdmin extends StatelessWidget {
  const CourseFacultiesPageAdmin({
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
        builder: (context) => CourseFacultiesPageAdmin(
          database: database,
          batch: batch,
          course: course,
        ),
      ),
    );
  }

  Future<void> _delete(BuildContext context, Batch batch, Course course,
      CourseFaculties courseFaculties) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteCourseFacultie(batch, course, courseFaculties);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  Future<void> _deleteConfirm(BuildContext context, Batch batch, Course course,
      CourseFaculties courseFaculties) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Confirm'),
        content: Text('Soch Le !!'),
        actions: <Widget>[
          FlatButton(
            onPressed: () async {
              await _delete(context, batch, course, courseFaculties);
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
            title: Text(jobName + ' - Faculties Page'),
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
                onPressed: () => EditCourseFacultiesPage.show(
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
    return StreamBuilder<List<CourseFaculties>>(
      stream: database.courseFacultiesStream(
          batchId: batch.id, courseId: course.id),
      builder: (context, snapshot) {
        return ListItemsBuilder<CourseFaculties>(
          snapshot: snapshot,
          itemBuilder: (context, courseFaculties) => Dismissible(
            key: Key('job-${batch.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) =>
                _deleteConfirm(context, batch, course, courseFaculties),
            child: CourseFacultiesListTileAdmin(
              onTap: () => EditCourseFacultiesPage.show(
                context,
                database: database,
                batch: batch,
                course: course,
                courseFaculties: courseFaculties,
              ),
              batch: batch,
              course: course,
              courseFaculties: courseFaculties,
            ),
          ),
        );
      },
    );
  }
}
