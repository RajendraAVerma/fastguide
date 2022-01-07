import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastguide/admin/screens/admin_home/chapter/contents/chapter_contents/chapter_content_page.dart';
import 'package:fastguide/admin/screens/admin_home/chapter/edit_chapter_page.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/show_exception_alert_dialog.dart';
import 'package:fastguide/admin/screens/admin_home/lecture/lecture_page.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/chapter.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/admin/screens/admin_home/models/section.dart';
import 'package:fastguide/admin/screens/admin_home/models/topic.dart';
import 'package:fastguide/admin/screens/admin_home/topic/edit_topic_page.dart';
import 'package:fastguide/admin/screens/admin_home/topic/list_items_builder.dart';
import 'package:fastguide/admin/screens/admin_home/topic/topic_list_tile.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopicPageAdmin extends StatelessWidget {
  const TopicPageAdmin({
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

  static Future<void> show(BuildContext context, Batch batch, Course course,
      Section section, Chapter chapter) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => TopicPageAdmin(
            database: database,
            batch: batch,
            course: course,
            section: section,
            chapter: chapter),
      ),
    );
  }

  Future<void> _delete(BuildContext context, Batch batch, Course course,
      Section section, Chapter chapter, Topic topic) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteTopic(batch, course, section, chapter, topic);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  Future<void> _deleteConfirm(BuildContext context, Batch batch, Course course,
      Section section, Chapter chapter, Topic topic) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Confirm'),
        content: Text('Soch Le !!'),
        actions: <Widget>[
          FlatButton(
            onPressed: () async {
              await _delete(context, batch, course, section, chapter, topic);
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
    return StreamBuilder<Chapter>(
      stream: database.chapterStream(
        jobId: batch.id,
        batchId: batch.id,
        courseId: course.id,
        sectionId: section.id,
        chapterId: chapter.id,
      ),
      builder: (context, snapshot) {
        final job = snapshot.data;
        final jobName = job?.chapterName ?? '';
        return Scaffold(
          appBar: AppBar(
            elevation: 2.0,
            title: Text(jobName),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: () => EditChapterPage.show(
                  context,
                  database: database,
                  batch: batch,
                  course: course,
                  section: section,
                  chapter: job,
                ),
              ),
              IconButton(
                icon: Icon(Icons.add, color: Colors.white),
                onPressed: () => EditTopicPage.show(
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
            child: Column(
              children: [
                ListTile(
                  title: Text("Chapter Content"),
                  trailing: IconButton(
                    onPressed: () => ChapterContentPageAdmin.show(
                      context,
                      batch,
                      course,
                      section,
                      chapter,
                    ),
                    icon: Icon(Icons.picture_as_pdf),
                  ),
                ),
                Expanded(
                    child: _buildContents(
                        context, batch, course, section, chapter)),
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
    Section section,
    Chapter chapter,
  ) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Topic>>(
      stream: database.topicsStream(
          batchId: batch.id,
          courseId: course.id,
          sectionId: section.id,
          chapterId: chapter.id),
      builder: (context, snapshot) {
        return ListItemsBuilder<Topic>(
          snapshot: snapshot,
          itemBuilder: (context, topic) => Dismissible(
            key: Key('job-${batch.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) =>
                _deleteConfirm(context, batch, course, section, chapter, topic),
            child: TopicListTileAdmin(
              onTap: () => LecturePage.show(
                  context, batch, course, section, chapter, topic),
              topic: topic, course: course,
              // => JobEntriesPage.show(context, batch),
            ),
          ),
        );
      },
    );
  }
}
