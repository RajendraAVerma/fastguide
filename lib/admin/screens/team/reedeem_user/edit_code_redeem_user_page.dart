import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/show_alert_dialog.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/show_exception_alert_dialog.dart';
import 'package:fastguide/admin/screens/team/model/coderedeemuser.dart';
import 'package:fastguide/admin/screens/team/model/member.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';

class EditCodeRedeemUsersPage extends StatefulWidget {
  const EditCodeRedeemUsersPage({
    Key? key,
    required this.database,
    required this.member,
    this.codeRedeemUser,
  }) : super(key: key);
  final Database database;
  final Member member;
  final CodeRedeemUser? codeRedeemUser;

  static Future<void> show(
    BuildContext context, {
    Database? database,
    Member? member,
    CodeRedeemUser? codeRedeemUser,
  }) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditCodeRedeemUsersPage(
          database: database!,
          member: member!,
          codeRedeemUser: codeRedeemUser,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditCodeRedeemUsersPageState createState() =>
      _EditCodeRedeemUsersPageState();
}

class _EditCodeRedeemUsersPageState extends State<EditCodeRedeemUsersPage> {
  final _formKey = GlobalKey<FormState>();

  int? _mobileNo;
  String? _userName;

  @override
  void initState() {
    super.initState();
    if (widget.codeRedeemUser != null) {
      _userName = widget.codeRedeemUser!.userName;
      _mobileNo = widget.codeRedeemUser!.mobileNo;
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
            .codeRedeemUsersStream(member: widget.member)
            .first;
        final allNames = jobs.map((job) => job.userName).toList();
        if (widget.codeRedeemUser != null) {
          allNames.remove(widget.codeRedeemUser!.userName);
        }
        if (allNames.contains(_mobileNo)) {
          showAlertDialog(
            context,
            title: 'Name already used',
            content: 'Please choose a different job name',
            defaultActionText: 'OK',
          );
        } else {
          final id = widget.codeRedeemUser?.id ?? documentIdFromCurrentDate();
          final codeRedeemUser = CodeRedeemUser(
            id: id,
            mobileNo: _mobileNo!,
            userName: _userName!,
            date: documentIdFromCurrentDate(),
          );
          await widget.database.setCodeRedeemUser(
            member: widget.member,
            codeRedeemUser: codeRedeemUser,
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
        title: Text(widget.codeRedeemUser == null
            ? 'New Code Reedeem User'
            : 'Edit Code Reedeem User'),
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
        decoration: InputDecoration(labelText: 'UserName'),
        initialValue: _userName,
        validator: (value) =>
            value!.isNotEmpty ? null : 'UserName can\'t be empty',
        onSaved: (value) => _userName = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'User Mobile No'),
        initialValue: _mobileNo != null ? '$_mobileNo' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _mobileNo = int.tryParse(value!) ?? 0,
      ),
    ];
  }
}
