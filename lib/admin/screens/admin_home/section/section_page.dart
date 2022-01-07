import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastguide/admin/screens/admin_home/chapter/chapter_page.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/show_exception_alert_dialog.dart';
import 'package:fastguide/admin/screens/admin_home/cource/contents/course_about/course_about_page.dart';
import 'package:fastguide/admin/screens/admin_home/cource/contents/course_contents/course_content_page.dart';
import 'package:fastguide/admin/screens/admin_home/cource/contents/course_faculties/course_faculties_page.dart';
import 'package:fastguide/admin/screens/admin_home/cource/contents/course_faqs/course_faqs_page.dart';
import 'package:fastguide/admin/screens/admin_home/cource/contents/course_key_points/course_key_points_page.dart';
import 'package:fastguide/admin/screens/admin_home/cource/edit_courses_page.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/admin/screens/admin_home/models/section.dart';
import 'package:fastguide/admin/screens/admin_home/section/edit_section_page.dart';
import 'package:fastguide/admin/screens/admin_home/section/list_items_builder.dart';
import 'package:fastguide/admin/screens/admin_home/section/section_list_tile.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SectionPageAdmin extends StatelessWidget {
  const SectionPageAdmin({
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
        builder: (context) => SectionPageAdmin(
          database: database,
          batch: batch,
          course: course,
        ),
      ),
    );
  }

  Future<void> _delete(
      BuildContext context, Batch batch, Course course, Section section) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteSection(batch, course, section);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  Future<void> _deleteConfirm(
      BuildContext context, Batch batch, Course course, Section section) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Confirm'),
        content: Text('Soch Le !!'),
        actions: <Widget>[
          FlatButton(
            onPressed: () async {
              await _delete(context, batch, course, section);
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
            title: Text(jobName),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: () => EditCoursePage.show(
                  context,
                  database: database,
                  batch: batch,
                  course: job,
                ),
              ),
              IconButton(
                icon: Icon(Icons.add, color: Colors.white),
                onPressed: () => EditSectionPage.show(
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
            child: Column(
              children: [
                ListTile(
                  title: Text("Course Content Page"),
                  trailing: IconButton(
                    onPressed: () =>
                        CourseContentPageAdmin.show(context, batch, course),
                    icon: Icon(Icons.picture_as_pdf),
                  ),
                ),
                ListTile(
                  title: Text("Course About Page"),
                  trailing: IconButton(
                    onPressed: () =>
                        CourseAboutPageAdmin.show(context, batch, course),
                    icon: Icon(Icons.picture_as_pdf),
                  ),
                ),
                ListTile(
                  title: Text("Course FAQs Page"),
                  trailing: IconButton(
                    onPressed: () =>
                        CourseFAQsPageAdmin.show(context, batch, course),
                    icon: Icon(Icons.picture_as_pdf),
                  ),
                ),
                ListTile(
                  title: Text("Course Faculties Page"),
                  trailing: IconButton(
                    onPressed: () =>
                        CourseFacultiesPageAdmin.show(context, batch, course),
                    icon: Icon(Icons.picture_as_pdf),
                  ),
                ),
                ListTile(
                  title: Text("Course Key Points Page"),
                  trailing: IconButton(
                    onPressed: () =>
                        CourseKeyPointsPageAdmin.show(context, batch, course),
                    icon: Icon(Icons.picture_as_pdf),
                  ),
                ),
                Expanded(child: buildContents),
              ],
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
  ) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Section>>(
      stream: database.sectionsStream(batchId: batch.id, courseId: course.id),
      builder: (context, snapshot) {
        return ListItemsBuilder<Section>(
          snapshot: snapshot,
          itemBuilder: (context, section) => Dismissible(
            key: Key('job-${batch.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) =>
                _deleteConfirm(context, batch, course, section),
            child: SectionListTileAdmin(
              onTap: () =>
                  ChapterPageAdmin.show(context, batch, course, section),
              batch: batch,
              course: course,
              section: section,
            ),
          ),
        );
      },
    );
  }
}
