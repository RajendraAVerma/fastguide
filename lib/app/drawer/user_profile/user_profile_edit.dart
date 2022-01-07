import 'package:fastguide/admin/screens/admin_home/common_widgets/show_alert_dialog.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/show_exception_alert_dialog.dart';
import 'package:fastguide/login/data_models/user_model.dart';
import 'package:fastguide/services/auth.dart';
import 'package:fastguide/services/database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditUserProfilePage extends StatefulWidget {
  const EditUserProfilePage({Key? key, required this.database, this.userData})
      : super(key: key);
  final Database database;
  final UserData? userData;

  static Future<void> show(BuildContext context, {UserData? userData}) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) =>
            EditUserProfilePage(database: database, userData: userData),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditUserProfilePageState createState() => _EditUserProfilePageState();
}

class _EditUserProfilePageState extends State<EditUserProfilePage> {
  final _formKey = GlobalKey<FormState>();

  String? _userName;
  String? _mobileNo;
  String? _email;
  String? _address;

  @override
  void initState() {
    super.initState();
    if (widget.userData != null) {
      _userName = widget.userData!.userName;
      _mobileNo = widget.userData!.mobileNo;
      _email = widget.userData!.email;
      _address = widget.userData!.address;
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
        final users = await widget.database.UsersStream().first;
        final allNames = users.map((users) => users.userName).toList();
        if (widget.userData != null) {
          allNames.remove(widget.userData!.userName);
        }
        if (allNames.contains(_userName)) {
          showAlertDialog(
            context,
            title: 'Name already used',
            content: 'Please choose a different name',
            defaultActionText: 'OK',
          );
        } else {
          final id = widget.userData?.id ?? documentIdFromCurrentDate();
          final userData = UserData(
            id: id,
            userName: _userName!,
            mobileNo: _mobileNo!,
            email: _email!,
            address: _address!,
            registerDate: currentDate(),
          );
          await widget.database.setUser(userData: userData);
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
        title: Text(widget.userData == null ? 'Fill Detail' : 'Update Profile'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Update',
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
        decoration: InputDecoration(labelText: 'Name'),
        initialValue: _userName,
        validator: (value) => value!.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _userName = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'E - Mail'),
        initialValue: _email,
        validator: (value) =>
            value!.isNotEmpty ? null : 'E - Mail can\'t be empty',
        onSaved: (value) => _email = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Full Address'),
        initialValue: _address,
        validator: (value) =>
            value!.isNotEmpty ? null : 'Address can\'t be empty',
        onSaved: (value) => _address = value,
      ),
      Text(
        "Fill Correct Full Address !! We Will Send All Notes in This Address",
        style: TextStyle(
          fontSize: 10.0,
          color: Colors.black87,
        ),
      ),
    ];
  }
}
