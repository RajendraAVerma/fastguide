import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/show_alert_dialog.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/show_exception_alert_dialog.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';

class EditCoursePage extends StatefulWidget {
  const EditCoursePage({
    Key? key,
    required this.database,
    required this.batch,
    this.course,
  }) : super(key: key);
  final Database database;
  final Batch batch;
  final Course? course;

  static Future<void> show(
    BuildContext context, {
    Database? database,
    Batch? batch,
    Course? course,
  }) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditCoursePage(
          database: database!,
          course: course,
          batch: batch!,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditCoursePageState createState() => _EditCoursePageState();
}

class _EditCoursePageState extends State<EditCoursePage> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  int? _totalChapter;
  int? _courseMRP;
  int? _courseSellingPrice;
  // design ----
  String? _themeColor1;
  String? _themeColor2;
  String? _boxIconLink;
  String? _thumnailLink;
  String? _teacher;

  @override
  void initState() {
    super.initState();
    if (widget.course != null) {
      _name = widget.course!.courseName;
      _courseMRP = widget.course!.courseMRP;
      _courseSellingPrice = widget.course!.courseSellingPrice;
      _totalChapter = widget.course!.totalChapter;
      // design ----
      _themeColor1 = widget.course!.themeColor1;
      _themeColor2 = widget.course!.themeColor2;
      _boxIconLink = widget.course!.boxIconLink;
      _thumnailLink = widget.course!.thumnailLink;
      _teacher = widget.course!.teacher;
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
        final jobs =
            await widget.database.coursesStream(batchId: widget.batch.id).first;
        final allNames = jobs.map((job) => job.courseName).toList();
        if (widget.course != null) {
          allNames.remove(widget.course!.courseName);
        }
        if (allNames.contains(_name)) {
          showAlertDialog(
            context,
            title: 'Name already used',
            content: 'Please choose a different job name',
            defaultActionText: 'OK',
          );
        } else {
          final id = widget.course?.id ?? documentIdFromCurrentDate();
          final course = Course(
            id: id,
            courseName: _name!,
            totalChapter: _totalChapter!,
            boxIconLink: _boxIconLink!,
            teacher: _teacher!,
            themeColor1: _themeColor1!,
            themeColor2: _themeColor2!,
            thumnailLink: _thumnailLink!,
            courseMRP: _courseMRP!,
            courseSellingPrice: _courseSellingPrice!,
          );
          await widget.database.setCourse(course: course, batch: widget.batch);
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
        title: Text(widget.course == null ? 'New Course' : 'Edit Course'),
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
        decoration: InputDecoration(labelText: 'Course name'),
        initialValue: _name,
        validator: (value) =>
            value!.isNotEmpty ? null : 'Course Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Course MRP'),
        initialValue: _courseMRP != null ? '$_courseMRP' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _courseMRP = int.tryParse(value!) ?? 0,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Course Selling Price'),
        initialValue:
            _courseSellingPrice != null ? '$_courseSellingPrice' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _courseSellingPrice = int.tryParse(value!) ?? 0,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Total Chapter'),
        initialValue: _totalChapter != null ? '$_totalChapter' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _totalChapter = int.tryParse(value!) ?? 0,
      ),
      // ---design -----
      TextFormField(
        decoration: InputDecoration(labelText: 'Theme Color 1'),
        initialValue: _themeColor1,
        validator: (value) => value!.isNotEmpty ? null : 'Can\'t be empty',
        onSaved: (value) => _themeColor1 = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Theme Color 2'),
        initialValue: _themeColor2,
        validator: (value) => value!.isNotEmpty ? null : 'Can\'t be empty',
        onSaved: (value) => _themeColor2 = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Box Icon Link'),
        initialValue: _boxIconLink,
        validator: (value) => value!.isNotEmpty ? null : 'Can\'t be empty',
        onSaved: (value) => _boxIconLink = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Thumnail Link'),
        initialValue: _thumnailLink,
        validator: (value) => value!.isNotEmpty ? null : 'Can\'t be empty',
        onSaved: (value) => _thumnailLink = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Teacher'),
        initialValue: _teacher,
        validator: (value) => value!.isNotEmpty ? null : 'Can\'t be empty',
        onSaved: (value) => _teacher = value,
      ),
    ];
  }
}
