import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/show_alert_dialog.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/show_exception_alert_dialog.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/contents/course_facalties.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';



 class EditCourseFacultiesPage extends StatefulWidget {
  const EditCourseFacultiesPage({
    Key? key,
    required this.database,
    required this.batch,
    required this.course,
    this.courseFaculties,
  }) : super(key: key);
  final Database database;
  final Batch batch;
  final Course course;
  final CourseFaculties? courseFaculties;

  static Future<void> show(
    BuildContext context, {
    Database? database,
    Batch? batch,
    Course? course,
    CourseFaculties? courseFaculties,
  }) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditCourseFacultiesPage(
          database: database!,
          batch: batch!,
          course: course!,
          courseFaculties: courseFaculties,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditCourseFacultiesPageState createState() => _EditCourseFacultiesPageState();
}

class _EditCourseFacultiesPageState extends State<EditCourseFacultiesPage> {
  final _formKey = GlobalKey<FormState>();

  int? _facultieNo;
  String? _name;
  String? _mobileNo;
  String? _imageLink;
  String? _courseName;
  String? _tag;

  @override
  void initState() {
    super.initState();
    if (widget.courseFaculties != null) {
      _name = widget.courseFaculties!.name;
      _facultieNo = widget.courseFaculties!.facultieNo;
      _mobileNo = widget.courseFaculties!.mobileNo;
      _imageLink = widget.courseFaculties!.imageLink;
      _courseName = widget.courseFaculties!.courseName;
      _tag = widget.courseFaculties!.tag;
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
        if (widget.courseFaculties != null) {
          allNames.remove(widget.courseFaculties!.name);
        }
        if (allNames.contains(_name)) {
          showAlertDialog(
            context,
            title: 'Name already used',
            content: 'Please choose a different Section name',
            defaultActionText: 'OK',
          );
        } else {
          final id = widget.courseFaculties?.id ?? documentIdFromCurrentDate();
          final courseFacalties = CourseFaculties(
            id: id,
            facultieNo: _facultieNo!,
            name: _name!,
            mobileNo: _mobileNo!,
            imageLink: _imageLink!,
            courseName: _courseName!,
            tag: _tag!,
          );
          await widget.database.setCourseFaculties(
            batch: widget.batch,
            course: widget.course,
            courseFacalties: courseFacalties,
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
        title: Text(widget.courseFaculties == null
            ? 'New Faculties'
            : 'Edit Faculties'),
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
        decoration: InputDecoration(labelText: 'Faculties No.'),
        initialValue: _facultieNo != null ? '$_facultieNo' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _facultieNo = int.tryParse(value!) ?? 0,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Faculties Name'),
        initialValue: _name,
        validator: (value) =>
            value!.isNotEmpty ? null : 'Faculties Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Image Link'),
        initialValue: _imageLink,
        validator: (value) =>
            value!.isNotEmpty ? null : 'Image Link can\'t be empty',
        onSaved: (value) => _imageLink = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Mobile No.'),
        initialValue: _mobileNo,
        validator: (value) =>
            value!.isNotEmpty ? null : 'Mobile No. Time can\'t be empty',
        onSaved: (value) => _mobileNo = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Course Name'),
        initialValue: _courseName,
        validator: (value) =>
            value!.isNotEmpty ? null : 'Course Name can\'t be empty',
        onSaved: (value) => _courseName = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Tag'),
        initialValue: _tag,
        validator: (value) => value!.isNotEmpty ? null : 'Tag can\'t be empty',
        onSaved: (value) => _tag = value,
      ),
    ];
  }
}
 