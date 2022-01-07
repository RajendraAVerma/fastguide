import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/show_alert_dialog.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/show_exception_alert_dialog.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/contents/course_content.dart';
import 'package:fastguide/admin/screens/admin_home/models/contents/course_faqs.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';

class EditCourseFAQsPage extends StatefulWidget {
  const EditCourseFAQsPage({
    Key? key,
    required this.database,
    required this.batch,
    required this.course,
    this.courseFAQs,
  }) : super(key: key);
  final Database database;
  final Batch batch;
  final Course course;
  final CourseFAQs? courseFAQs;

  static Future<void> show(
    BuildContext context, {
    Database? database,
    Batch? batch,
    Course? course,
    CourseFAQs? courseFAQs,
  }) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditCourseFAQsPage(
          database: database!,
          batch: batch!,
          course: course!,
          courseFAQs: courseFAQs,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditCourseFAQsPageState createState() => _EditCourseFAQsPageState();
}

class _EditCourseFAQsPageState extends State<EditCourseFAQsPage> {
  final _formKey = GlobalKey<FormState>();

  int? _faqsNo;
  String? _question;
  String? _answer;

  @override
  void initState() {
    super.initState();
    if (widget.courseFAQs != null) {
      _faqsNo = widget.courseFAQs!.faqsNo;
      _question = widget.courseFAQs!.question;
      _answer = widget.courseFAQs!.question;
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
        if (widget.courseFAQs != null) {
          allNames.remove(widget.courseFAQs!.question);
        }
        if (allNames.contains(_question)) {
          showAlertDialog(
            context,
            title: 'Name already used',
            content: 'Please choose a different Section name',
            defaultActionText: 'OK',
          );
        } else {
          final id = widget.courseFAQs?.id ?? documentIdFromCurrentDate();
          final courseFAQs = CourseFAQs(
            id: id,
            faqsNo: _faqsNo!,
            answer: _answer!,
            question: _question!,
          );
          await widget.database.setCourseFAQs(
            batch: widget.batch,
            course: widget.course,
            courseFAQs: courseFAQs,
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
        title: Text(widget.courseFAQs == null ? 'New FAQs' : 'Edit FAQs'),
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
        decoration: InputDecoration(labelText: 'FAQs No.'),
        initialValue: _faqsNo != null ? '$_faqsNo' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _faqsNo = int.tryParse(value!) ?? 0,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Question'),
        initialValue: _question,
        validator: (value) =>
            value!.isNotEmpty ? null : 'Question can\'t be empty',
        onSaved: (value) => _question = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Answer'),
        initialValue: _answer,
        validator: (value) =>
            value!.isNotEmpty ? null : 'Answer can\'t be empty',
        onSaved: (value) => _answer = value,
      ),
    ];
  }
}
