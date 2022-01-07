import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/show_alert_dialog.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/show_exception_alert_dialog.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/chapter.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/admin/screens/admin_home/models/section.dart';
import 'package:fastguide/admin/screens/admin_home/models/topic.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';

class EditTopicPage extends StatefulWidget {
  const EditTopicPage({
    Key? key,
    required this.database,
    required this.batch,
    required this.course,
    required this.section,
    required this.chapter,
    this.topic,
  }) : super(key: key);
  final Database database;
  final Batch batch;
  final Course course;
  final Section section;
  final Chapter chapter;
  final Topic? topic;

  static Future<void> show(
    BuildContext context, {
    Database? database,
    Batch? batch,
    Course? course,
    Section? section,
    Chapter? chapter,
    Topic? topic,
  }) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditTopicPage(
          database: database!,
          batch: batch!,
          course: course!,
          section: section!,
          chapter: chapter!,
          topic: topic,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditTopicPageState createState() => _EditTopicPageState();
}

class _EditTopicPageState extends State<EditTopicPage> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  int? _topicNo;
  int? _lock;
  int? _totalLecture;
  String? _introLink;
  String? _iconLink;

  @override
  void initState() {
    super.initState();
    if (widget.topic != null) {
      _name = widget.topic!.topicName;
      _lock = widget.topic!.lock;
      _topicNo = widget.topic!.topicNo;
      _totalLecture = widget.topic!.totalLecture;
      _introLink = widget.topic!.introLink;
      _iconLink = widget.topic!.iconLink;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final jobs = await widget.database
            .topicsStream(
              batchId: widget.batch.id,
              courseId: widget.course.id,
              sectionId: widget.section.id,
              chapterId: widget.chapter.id,
            )
            .first;
        final allNames = jobs.map((job) => job.topicName).toList();
        if (widget.topic != null) {
          allNames.remove(widget.topic!.topicName);
        }
        if (allNames.contains(_name)) {
          showAlertDialog(
            context,
            title: 'Name already used',
            content: 'Please choose a different job name',
            defaultActionText: 'OK',
          );
        } else {
          final id = widget.topic?.id ?? documentIdFromCurrentDate();
          final topic = Topic(
            id: id,
            topicName: _name!,
            totalLecture: _totalLecture!,
            iconLink: _iconLink!,
            introLink: _introLink!,
            topicNo: _topicNo!,
            lock: _lock!,
          );
          await widget.database.setTopic(
            batch: widget.batch,
            course: widget.course,
            section: widget.section,
            chapter: widget.chapter,
            topic: topic,
          );
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(
          context,
          title: 'Operation failed',
          exception: e,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.topic == null ? 'New Topic' : 'Edit Topic'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Save',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: _submit,
          ),
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Topic No.'),
        initialValue: _topicNo != null ? '$_topicNo' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _topicNo = int.tryParse(value!) ?? 0,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Topic name'),
        initialValue: _name,
        validator: (value) =>
            value!.isNotEmpty ? null : 'Topic Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Total Lecture'),
        initialValue: _totalLecture != null ? '$_totalLecture' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _totalLecture = int.tryParse(value!) ?? 0,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Intro Link'),
        initialValue: _introLink,
        validator: (value) =>
            value!.isNotEmpty ? null : 'Intro Link can\'t be empty',
        onSaved: (value) => _introLink = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Icon Link'),
        initialValue: _iconLink,
        validator: (value) =>
            value!.isNotEmpty ? null : 'Icon Link can\'t be empty',
        onSaved: (value) => _iconLink = value,
      ),
      TextFormField(
        decoration: InputDecoration(
            labelText: 'Lock', hintText: '0 = lock, 1 = unlock'),
        initialValue: _lock != null ? '$_lock' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _lock = int.tryParse(value!) ?? 0,
      ),
    ];
  }
}
