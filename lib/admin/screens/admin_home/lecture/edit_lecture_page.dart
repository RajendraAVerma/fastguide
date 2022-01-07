import 'package:fastguide/admin/screens/admin_home/common_widgets/show_alert_dialog.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/show_exception_alert_dialog.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/chapter.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/admin/screens/admin_home/models/lecture.dart';
import 'package:fastguide/admin/screens/admin_home/models/section.dart';
import 'package:fastguide/admin/screens/admin_home/models/topic.dart';
import 'package:fastguide/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditLecturePage extends StatefulWidget {
  const EditLecturePage({
    Key? key,
    required this.database,
    required this.batch,
    required this.course,
    required this.section,
    required this.chapter,
    required this.topic,
    this.lecture,
  }) : super(key: key);
  final Database database;
  final Batch batch;
  final Course course;
  final Section section;
  final Chapter chapter;
  final Topic topic;
  final Lecture? lecture;

  static Future<void> show(
    BuildContext context, {
    Database? database,
    Batch? batch,
    Course? course,
    Section? section,
    Chapter? chapter,
    Topic? topic,
    Lecture? lecture,
  }) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditLecturePage(
          database: database!,
          batch: batch!,
          course: course!,
          section: section!,
          chapter: chapter!,
          topic: topic!,
          lecture: lecture,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditLecturePageState createState() => _EditLecturePageState();
}

class _EditLecturePageState extends State<EditLecturePage> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  int? _lectureNo;
  int? _lectureType;
  String? _lectureIcon;
  String? _lectureVideoLink;
  String? _lectureButtonLink1;
  String? _lectureButtonLink2;
  String? _lectureButtonLink3;
  String? _lectureDiscription;

  @override
  void initState() {
    super.initState();
    if (widget.lecture != null) {
      _name = widget.lecture!.lectureName;
      _lectureNo = widget.lecture!.lectureNo;
      _lectureType = widget.lecture!.lectureType;
      _lectureIcon = widget.lecture!.lectureIcon;
      _lectureVideoLink = widget.lecture!.lectureVideoLink;
      _lectureButtonLink1 = widget.lecture!.lectureButtonLink1;
      _lectureButtonLink2 = widget.lecture!.lectureButtonLink2;
      _lectureButtonLink3 = widget.lecture!.lectureButtonLink3;
      _lectureDiscription = widget.lecture!.lectureDiscription;
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
            .lecturesStream(
                batchId: widget.batch.id,
                courseId: widget.course.id,
                sectionId: widget.section.id,
                chapterId: widget.course.id,
                topicId: widget.topic.id)
            .first;
        final allNames = jobs.map((job) => job.lectureName).toList();
        if (widget.lecture != null) {
          allNames.remove(widget.lecture!.lectureName);
        }
        if (allNames.contains(_name)) {
          showAlertDialog(
            context,
            title: 'Name already used',
            content: 'Please choose a different job name',
            defaultActionText: 'OK',
          );
        } else {
          final id = widget.lecture?.id ?? documentIdFromCurrentDate();
          final lecture = Lecture(
            id: id,
            lectureName: _name!,
            lectureNo: _lectureNo!,
            lectureIcon: _lectureIcon!,
            lectureType: _lectureType!,
            lectureVideoLink: _lectureVideoLink!,
            lectureButtonLink1: _lectureButtonLink1!,
            lectureButtonLink2: _lectureButtonLink2!,
            lectureButtonLink3: _lectureButtonLink3!,
            lectureDiscription: _lectureDiscription!,
          );
          await widget.database.setLecture(
              batch: widget.batch,
              course: widget.course,
              section: widget.section,
              chapter: widget.chapter,
              topic: widget.topic,
              lecture: lecture);
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
        title: Text(widget.lecture == null ? 'New Lecture' : 'Edit Lecture'),
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
        decoration: InputDecoration(labelText: 'Lecture No.'),
        initialValue: _lectureNo != null ? '$_lectureNo' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _lectureNo = int.tryParse(value!) ?? 0,
      ),
      TextFormField(
        decoration: InputDecoration(
            labelText: 'Lecture Type',
            hintText: '0 - Video Type, 1 - Animation Type'),
        initialValue: _lectureType != null ? '$_lectureType' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _lectureType = int.tryParse(value!) ?? 0,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Lecture name'),
        initialValue: _name,
        validator: (value) =>
            value!.isNotEmpty ? null : 'Lecture Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Lecture Icon'),
        initialValue: _lectureIcon,
        validator: (value) => value!.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _lectureIcon = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Lecture Video Link'),
        initialValue: _lectureVideoLink,
        validator: (value) => value!.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _lectureVideoLink = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Lecture Button 1 Link'),
        initialValue: _lectureButtonLink1,
        validator: (value) => value!.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _lectureButtonLink1 = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Button 2 Link (SLIDE PDF) '),
        initialValue: _lectureButtonLink2,
        validator: (value) => value!.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _lectureButtonLink2 = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Button 3 Link (NOTES PDF)'),
        initialValue: _lectureButtonLink3,
        validator: (value) =>
            value!.isNotEmpty ? null : 'Lecture Name can\'t be empty',
        onSaved: (value) => _lectureButtonLink3 = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Lecture Discription'),
        initialValue: _lectureDiscription,
        validator: (value) =>
            value!.isNotEmpty ? null : 'Lecture Discription can\'t be empty',
        onSaved: (value) => _lectureDiscription = value,
      ),
    ];
  }
}
