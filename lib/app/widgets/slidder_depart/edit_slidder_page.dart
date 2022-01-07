import 'package:fastguide/admin/screens/admin_home/common_widgets/show_alert_dialog.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/show_exception_alert_dialog.dart';
import 'package:fastguide/app/widgets/slidder_depart/slidder_image_model.dart';
import 'package:fastguide/services/database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class EditSlidderPage extends StatefulWidget {
  const EditSlidderPage({Key? key, required this.database, this.slidderModel})
      : super(key: key);
  final Database database;
  final SlidderModel? slidderModel;

  static Future<void> show(BuildContext context,
      {Database? database, SlidderModel? slidderModel}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) =>
            EditSlidderPage(database: database!, slidderModel: slidderModel),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditSlidderPageState createState() => _EditSlidderPageState();
}

class _EditSlidderPageState extends State<EditSlidderPage> {
  final _formKey = GlobalKey<FormState>();

  String? _imageLink;

  @override
  void initState() {
    super.initState();
    if (widget.slidderModel != null) {
      _imageLink = widget.slidderModel!.imageLink;
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
        if (widget.slidderModel != null) {
          allNames.remove(widget.slidderModel!.imageLink);
        }
        if (allNames.contains(_imageLink)) {
          showAlertDialog(
            context,
            title: 'Name already used',
            content: 'Please choose a different',
            defaultActionText: 'OK',
          );
        } else {
          final id = widget.slidderModel?.id ?? documentIdFromCurrentDate();
          final slidderModel = SlidderModel(
              id: id,
              imageLink: _imageLink!,
              link: 'https://www.youtube.com/channel/UC1bcb3PYpI2lf9FFK1lj3Kg',);
          await widget.database.setSlidder(slidderModel: slidderModel);
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
        title: Text(
            widget.slidderModel == null ? 'New Image Link' : 'Edit Image Link'),
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
        decoration: InputDecoration(labelText: 'Link', hintText: 'Image Link'),
        initialValue: _imageLink,
        validator: (value) => value!.isNotEmpty ? null : 'Can\'t be empty',
        onSaved: (value) => _imageLink = value,
      ),
    ];
  }
}
