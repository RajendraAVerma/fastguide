import 'package:fastguide/admin/screens/admin_home/common_widgets/show_alert_dialog.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/show_exception_alert_dialog.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/services/database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class EditBatchPage extends StatefulWidget {
  const EditBatchPage({Key? key, required this.database, this.job})
      : super(key: key);
  final Database database;
  final Batch? job;

  static Future<void> show(BuildContext context,
      {Database? database, Batch? job}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditBatchPage(database: database!, job: job),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditBatchPageState createState() => _EditBatchPageState();
}

class _EditBatchPageState extends State<EditBatchPage> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  int? _totalCourse;
// design ----
  String? _themeColor1;
  String? _themeColor2;
  String? _boxIconLink;
  String? _thumnailLink;
  String? _tag;

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job!.batchName;
      _totalCourse = widget.job!.totalCourse;
      // design ----
      _themeColor1 = widget.job!.themeColor1;
      _themeColor2 = widget.job!.themeColor2;
      _boxIconLink = widget.job!.boxIconLink;
      _thumnailLink = widget.job!.thumnailLink;
      _tag = widget.job!.tag;
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
        final jobs = await widget.database.batchesStream().first;
        final allNames = jobs.map((job) => job.batchName).toList();
        if (widget.job != null) {
          allNames.remove(widget.job!.batchName);
        }
        if (allNames.contains(_name)) {
          showAlertDialog(
            context,
            title: 'Name already used',
            content: 'Please choose a different job name',
            defaultActionText: 'OK',
          );
        } else {
          final id = widget.job?.id ?? documentIdFromCurrentDate();
          final job = Batch(
              id: id,
              batchName: _name!,
              totalCourse: _totalCourse!,
              boxIconLink: _boxIconLink!,
              tag: _tag!,
              themeColor1: _themeColor1!,
              themeColor2: _themeColor2!,
              thumnailLink: _thumnailLink!);
          await widget.database.setBatch(job);
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
        title: Text(widget.job == null ? 'New Batch' : 'Edit Batch'),
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
        decoration: InputDecoration(labelText: 'Batch name'),
        initialValue: _name,
        validator: (value) =>
            value!.isNotEmpty ? null : 'Batch Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Total Course'),
        initialValue: _totalCourse != null ? '$_totalCourse' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _totalCourse = int.tryParse(value!) ?? 0,
      ),
      // ---design -----
      TextFormField(
        decoration:
            InputDecoration(labelText: 'Theme Color 1', hintText: '0xff'),
        initialValue: _themeColor1,
        validator: (value) => value!.isNotEmpty ? null : 'Can\'t be empty',
        onSaved: (value) => _themeColor1 = value,
      ),
      TextFormField(
        decoration:
            InputDecoration(labelText: 'Theme Color 2', hintText: '0xff'),
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
        decoration: InputDecoration(labelText: 'Tags'),
        initialValue: _tag,
        validator: (value) => value!.isNotEmpty ? null : 'Can\'t be empty',
        onSaved: (value) => _tag = value,
      ),
    ];
  }
}
