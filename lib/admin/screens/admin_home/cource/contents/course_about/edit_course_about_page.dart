import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/show_alert_dialog.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/show_exception_alert_dialog.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/contents/course_about.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';

class EditCourseAboutPage extends StatefulWidget {
  const EditCourseAboutPage({
    Key? key,
    required this.database,
    required this.batch,
    required this.course,
    this.courseAbout,
  }) : super(key: key);
  final Database database;
  final Batch batch;
  final Course course;
  final CourseAbout? courseAbout;

  static Future<void> show(
    BuildContext context, {
    Database? database,
    Batch? batch,
    Course? course,
    CourseAbout? courseAbout,
  }) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditCourseAboutPage(
          database: database!,
          batch: batch!,
          course: course!,
          courseAbout: courseAbout,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditCourseAboutPageState createState() => _EditCourseAboutPageState();
}

class _EditCourseAboutPageState extends State<EditCourseAboutPage> {
  final _formKey = GlobalKey<FormState>();

  String? _videoLink;
  String? _imgLink1;
  String? _imgLink2;
  String? _discription;

  @override
  void initState() {
    super.initState();
    if (widget.courseAbout != null) {
      _videoLink = widget.courseAbout!.videoLink;
      _discription = widget.courseAbout!.discription;

      _imgLink1 = widget.courseAbout!.imgLink1;
      _imgLink2 = widget.courseAbout!.imgLink2;
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
        if (widget.courseAbout != null) {
          allNames.remove(widget.courseAbout!.discription);
        }
        if (allNames.contains(_videoLink)) {
          showAlertDialog(
            context,
            title: 'Name already used',
            content: 'Please choose a different Section name',
            defaultActionText: 'OK',
          );
        } else {
          final id = widget.courseAbout?.id ?? documentIdFromCurrentDate();
          final courseAbout = CourseAbout(
            id: id,
            discription: _discription!,
            imgLink1: _imgLink1!,
            imgLink2: _imgLink2!,
            videoLink: _videoLink!,
          );
          await widget.database.setCourseAbout(
            batch: widget.batch,
            course: widget.course,
            courseAbout: courseAbout,
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
        title: Text(widget.courseAbout == null ? 'New About' : 'Edit About'),
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
        decoration: InputDecoration(labelText: 'Course Discription'),
        initialValue: _discription,
        validator: (value) =>
            value!.isNotEmpty ? null : 'Course Discription can\'t be empty',
        onSaved: (value) => _discription = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Youtube Video ID ONLY'),
        initialValue: _videoLink,
        validator: (value) =>
            value!.isNotEmpty ? null : 'Youtube Video ID ONLY can\'t be empty',
        onSaved: (value) => _videoLink = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Image Banner Link 1'),
        initialValue: _imgLink1,
        validator: (value) =>
            value!.isNotEmpty ? null : 'Image Banner Link 1 can\'t be empty',
        onSaved: (value) => _imgLink1 = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Image Banner Link 2'),
        initialValue: _imgLink2,
        validator: (value) =>
            value!.isNotEmpty ? null : 'Image Banner Link 2 can\'t be empty',
        onSaved: (value) => _imgLink2 = value,
      ),
    ];
  }
}
