import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/show_alert_dialog.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/show_exception_alert_dialog.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/admin/screens/admin_home/models/section.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';

class EditSectionPage extends StatefulWidget {
  const EditSectionPage({
    Key? key,
    required this.database,
    required this.batch,
    required this.course,
    this.section,
  }) : super(key: key);
  final Database database;
  final Batch batch;
  final Course course;
  final Section? section;

  static Future<void> show(
    BuildContext context, {
    Database? database,
    Batch? batch,
    Course? course,
    Section? section,
  }) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditSectionPage(
          database: database!,
          batch: batch!,
          course: course!,
          section: section,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditSectionPageState createState() => _EditSectionPageState();
}

class _EditSectionPageState extends State<EditSectionPage> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  int? _totalSection;
  int? _sectionNo;

  @override
  void initState() {
    super.initState();
    if (widget.section != null) {
      _name = widget.section!.sectionName;
      _totalSection = widget.section!.totalSection;
      _sectionNo = widget.section!.sectionNo;
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
        if (widget.section != null) {
          allNames.remove(widget.section!.sectionName);
        }
        if (allNames.contains(_name)) {
          showAlertDialog(
            context,
            title: 'Name already used',
            content: 'Please choose a different Section name',
            defaultActionText: 'OK',
          );
        } else {
          final id = widget.section?.id ?? documentIdFromCurrentDate();
          final section = Section(
            id: id,
            sectionName: _name!,
            totalSection: _totalSection!,
            sectionNo: _sectionNo!,
          );
          await widget.database.setSection(
            batch: widget.batch,
            course: widget.course,
            section: section,
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
        title: Text(widget.section == null ? 'New Section' : 'Edit Section'),
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
        decoration: InputDecoration(labelText: 'Section No.'),
        initialValue: _sectionNo != null ? '$_sectionNo' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _sectionNo = int.tryParse(value!) ?? 0,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Section name'),
        initialValue: _name,
        validator: (value) =>
            value!.isNotEmpty ? null : 'Section Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Total Chapter'),
        initialValue: _totalSection != null ? '$_totalSection' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _totalSection = int.tryParse(value!) ?? 0,
      ),
    ];
  }
}
