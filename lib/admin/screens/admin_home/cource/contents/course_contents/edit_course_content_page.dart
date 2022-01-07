import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/show_alert_dialog.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/show_exception_alert_dialog.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/contents/course_content.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';


class EditCourseContentPage extends StatefulWidget {
  const EditCourseContentPage({
    Key? key,
    required this.database,
    required this.batch,
    required this.course,
    this.courseContent,
  }) : super(key: key);
  final Database database;
  final Batch batch;
  final Course course;
  final CourseContent? courseContent;

  static Future<void> show(
    BuildContext context, {
    Database? database,
    Batch? batch,
    Course? course,
    CourseContent? courseContent,
  }) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditCourseContentPage(
          database: database!,
          batch: batch!,
          course: course!,
          courseContent: courseContent,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditCourseContentPageState createState() => _EditCourseContentPageState();
}

class _EditCourseContentPageState extends State<EditCourseContentPage> {
  final _formKey = GlobalKey<FormState>();

  String? _title;
  int? _contentNo;
  int? _type;
  String? _time;
  String? _link;

  @override
  void initState() {
    super.initState();
    if (widget.courseContent != null) {
      _title = widget.courseContent!.title;
      _contentNo = widget.courseContent!.contentNo;
      _type = widget.courseContent!.type;
      _time = widget.courseContent!.time;
      _link = widget.courseContent!.link;
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
            .sectionsStream(
              batchId: widget.batch.id,
              courseId: widget.course.id,
            )
            .first;
        final allNames = jobs.map((job) => job.sectionName).toList();
        if (widget.courseContent != null) {
          allNames.remove(widget.courseContent!.title);
        }
        if (allNames.contains(_title)) {
          showAlertDialog(
            context,
            title: 'Name already used',
            content: 'Please choose a different Section name',
            defaultActionText: 'OK',
          );
        } else {
          final id = widget.courseContent?.id ?? documentIdFromCurrentDate();
          final courseContent = CourseContent(
            id: id,
            contentNo: _contentNo!,
            title: _title!,
            type: _type!,
            time: _time!,
            link: _link!,
          );
          await widget.database.setCourseContent(
            batch: widget.batch,
            course: widget.course,
            courseContent: courseContent,
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
        title:
            Text(widget.courseContent == null ? 'New Content' : 'Edit Content'),
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
        decoration: InputDecoration(labelText: 'Course Content No.'),
        initialValue: _contentNo != null ? '$_contentNo' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _contentNo = int.tryParse(value!) ?? 0,
      ),
      SizedBox(height: 15.0),
      Text("0 = PDF, 1 = Image, 2 = Link, 3 = Text"),
      SizedBox(height: 15.0),
      TextFormField(
        decoration: InputDecoration(labelText: 'Course Content Type'),
        initialValue: _type != null ? '$_type' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _type = int.tryParse(value!) ?? 0,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Content Name'),
        initialValue: _title,
        validator: (value) =>
            value!.isNotEmpty ? null : 'Content Name can\'t be empty',
        onSaved: (value) => _title = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Link'),
        initialValue: _link,
        validator: (value) =>
            value!.isNotEmpty ? null : 'Content Link can\'t be empty',
        onSaved: (value) => _link = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Time'),
        initialValue: _time,
        validator: (value) =>
            value!.isNotEmpty ? null : 'Content Time can\'t be empty',
        onSaved: (value) => _time = value,
      ),
    ];
  }
}









