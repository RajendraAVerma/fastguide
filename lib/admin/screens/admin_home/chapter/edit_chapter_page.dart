import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/show_alert_dialog.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/show_exception_alert_dialog.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/chapter.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/admin/screens/admin_home/models/section.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';

class EditChapterPage extends StatefulWidget {
  const EditChapterPage({
    Key? key,
    required this.database,
    required this.batch,
    required this.course,
    required this.section,
    this.chapter,
  }) : super(key: key);
  final Database database;
  final Batch batch;
  final Course course;
  final Section section;
  final Chapter? chapter;

  static Future<void> show(
    BuildContext context, {
    Database? database,
    Batch? batch,
    Course? course,
    Section? section,
    Chapter? chapter,
  }) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditChapterPage(
          database: database!,
          batch: batch!,
          course: course!,
          section: section!,
          chapter: chapter,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditChapterPageState createState() => _EditChapterPageState();
}

class _EditChapterPageState extends State<EditChapterPage> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  int? _chapterNo;
  int? _totalTopic;
  int? _totalLecture;

  @override
  void initState() {
    super.initState();
    if (widget.chapter != null) {
      _name = widget.chapter!.chapterName;
      _chapterNo = widget.chapter!.chapterNo;
      _totalTopic = widget.chapter!.totalTopic;
      _totalLecture = widget.chapter!.totalLecture;
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
            .chaptersStream(
              batchId: widget.batch.id,
              courseId: widget.course.id,
              sectionId: widget.section.id,
            )
            .first;
        final allNames = jobs.map((job) => job.chapterName).toList();
        if (widget.chapter != null) {
          allNames.remove(widget.chapter!.chapterName);
        }
        if (allNames.contains(_name)) {
          showAlertDialog(
            context,
            title: 'Name already used',
            content: 'Please choose a different Chapter name',
            defaultActionText: 'OK',
          );
        } else {
          final id = widget.chapter?.id ?? documentIdFromCurrentDate();
          final chapter = Chapter(
            id: id,
            chapterName: _name!,
            totalTopic: _totalTopic!,
            totalLecture: _totalLecture!,
            chapterNo: _chapterNo!,
          );
          await widget.database.setChapter(
            batch: widget.batch,
            course: widget.course,
            section: widget.section,
            chapter: chapter,
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
        title: Text(widget.chapter == null ? 'New Chapter' : 'Edit Chapter'),
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
        decoration: InputDecoration(labelText: 'Chapter No.'),
        initialValue: _chapterNo != null ? '$_chapterNo' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _chapterNo = int.tryParse(value!) ?? 0,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Chapter name'),
        initialValue: _name,
        validator: (value) =>
            value!.isNotEmpty ? null : 'Chapter Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Total Topic'),
        initialValue: _totalTopic != null ? '$_totalTopic' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _totalTopic = int.tryParse(value!) ?? 0,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Total Video'),
        initialValue: _totalLecture != null ? '$_totalLecture' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _totalLecture = int.tryParse(value!) ?? 0,
      ),
    ];
  }
}
