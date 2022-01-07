import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/show_alert_dialog.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/show_exception_alert_dialog.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/contents/course_key_points.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';

class EditCourseKeyPointsPage extends StatefulWidget {
  const EditCourseKeyPointsPage({
    Key? key,
    required this.database,
    required this.batch,
    required this.course,
    this.courseKeyPoints,
  }) : super(key: key);
  final Database database;
  final Batch batch;
  final Course course;
  final CourseKeyPoints? courseKeyPoints;

  static Future<void> show(
    BuildContext context, {
    Database? database,
    Batch? batch,
    Course? course,
    CourseKeyPoints? courseKeyPoints,
  }) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditCourseKeyPointsPage(
          database: database!,
          batch: batch!,
          course: course!,
          courseKeyPoints: courseKeyPoints,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditCourseKeyPointsPageState createState() =>
      _EditCourseKeyPointsPageState();
}

class _EditCourseKeyPointsPageState extends State<EditCourseKeyPointsPage> {
  final _formKey = GlobalKey<FormState>();

  int? _keyPointsNo;
  String? _keyPoint;

  @override
  void initState() {
    super.initState();
    if (widget.courseKeyPoints != null) {
      _keyPoint = widget.courseKeyPoints!.keyPoint;
      _keyPointsNo = widget.courseKeyPoints!.keyPointsNo;
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
        if (widget.courseKeyPoints != null) {
          allNames.remove(widget.courseKeyPoints!.keyPoint);
        }
        if (allNames.contains(_keyPoint)) {
          showAlertDialog(
            context,
            title: 'Name already used',
            content: 'Please choose a different Section name',
            defaultActionText: 'OK',
          );
        } else {
          final id = widget.courseKeyPoints?.id ?? documentIdFromCurrentDate();
          final courseKeyPoints = CourseKeyPoints(
            id: id,
            keyPointsNo: _keyPointsNo!,
            keyPoint: _keyPoint!,
          );
          await widget.database.setCourseKeyPoint(
            batch: widget.batch,
            course: widget.course,
            courseKeyPoints: courseKeyPoints,
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
        title: Text(widget.courseKeyPoints == null
            ? 'New Key Point'
            : 'Edit Key Point'),
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
        decoration: InputDecoration(labelText: 'Key Point No.'),
        initialValue: _keyPointsNo != null ? '$_keyPointsNo' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _keyPointsNo = int.tryParse(value!) ?? 0,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Key Point'),
        initialValue: _keyPoint,
        validator: (value) =>
            value!.isNotEmpty ? null : 'Key Point can\'t be empty',
        onSaved: (value) => _keyPoint = value,
      ),
    ];
  }
}
