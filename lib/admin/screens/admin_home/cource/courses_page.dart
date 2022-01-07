import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastguide/admin/screens/admin_home/batches/edit_batches_page.dart';
import 'package:fastguide/admin/screens/admin_home/batches/list_items_builder.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/show_exception_alert_dialog.dart';
import 'package:fastguide/admin/screens/admin_home/cource/course_list_tile.dart';
import 'package:fastguide/admin/screens/admin_home/cource/edit_courses_page.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/admin/screens/admin_home/section/section_page.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({required this.database, required this.job});
  final Database database;
  final Batch job;

  static Future<void> show(BuildContext context, Batch job) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => CoursePage(database: database, job: job),
      ),
    );
  }

  Future<void> _delete(BuildContext context, Batch batch, Course course) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteCourse(batch, course);
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
              await _delete(context, batch, course);
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
    return StreamBuilder<Batch>(
      stream: database.batchStream(batchId: job.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final job = snapshot.data;
          final jobName = job?.batchName ?? '';
          return Scaffold(
            appBar: AppBar(
              elevation: 2.0,
              title: Text(jobName),
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.white),
                  onPressed: () => EditBatchPage.show(
                    context,
                    database: database,
                    job: job,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.white),
                  onPressed: () => EditCoursePage.show(
                    context,
                    database: database,
                    batch: job,
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                ListTile(
                  title: Text("Admin Course Page"),
                ),
                Expanded(child: _buildContents(context, job!)),
              ],
            ),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildContents(
    BuildContext context,
    Batch batch,
  ) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Course>>(
      stream: database.coursesStream(batchId: batch.id),
      builder: (context, snapshot) {
        return ListItemsBuilder<Course>(
          snapshot: snapshot,
          itemBuilder: (context, course) => Dismissible(
            key: Key('job-${job.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _deleteConfirm(context, batch, course),
            child: CourceListTileAdmin(
              onTap: () => SectionPageAdmin.show(context, job, course),
              course: course,
              // => JobEntriesPage.show(context, batch),
            ),
          ),
        );
      },
    );
  }
}
