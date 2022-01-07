import 'package:fastguide/admin/screens/admin_home/common_widgets/show_alert_dialog.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/show_exception_alert_dialog.dart';

import 'package:fastguide/admin/screens/team/model/member.dart';
import 'package:fastguide/services/database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class EditTeamPage extends StatefulWidget {
  const EditTeamPage({Key? key, required this.database, this.member})
      : super(key: key);
  final Database database;
  final Member? member;

  static Future<void> show(BuildContext context,
      {Database? database, Member? member}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditTeamPage(database: database!, member: member),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditTeamPageState createState() => _EditTeamPageState();
}

class _EditTeamPageState extends State<EditTeamPage> {
  final _formKey = GlobalKey<FormState>();

  String? _memberName;
  String? _memberMobileNo;
  int? _percentage;
  String? _couponCode;
  String? _upi;

  @override
  void initState() {
    super.initState();
    if (widget.member != null) {
      _memberName = widget.member!.memberName;
      _memberMobileNo = widget.member!.memberMobileNo;
      _couponCode = widget.member!.couponCode;
      _percentage = widget.member!.percentage;
      _upi = widget.member!.upi;
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
        final jobs = await widget.database.membersStream().first;
        final allNames = jobs.map((job) => job.memberName).toList();
        if (widget.member != null) {
          allNames.remove(widget.member!.memberName);
        }
        if (allNames.contains(_memberName)) {
          showAlertDialog(
            context,
            title: 'Name already used',
            content: 'Please choose a different job name',
            defaultActionText: 'OK',
          );
        } else {
          final id = widget.member?.id ?? documentIdFromCurrentDate();
          final member = Member(
            id: id,
            memberName: _memberName!,
            memberMobileNo: _memberMobileNo!,
            couponCode: _couponCode!,
            percentage: _percentage!,
            upi: _upi!,
          );
          await widget.database.setMember(member: member);
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
        title: Text(widget.member == null ? 'New Member' : 'Edit Member'),
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
        decoration: InputDecoration(labelText: 'Member Name'),
        initialValue: _memberName,
        validator: (value) =>
            value!.isNotEmpty ? null : 'Member Name can\'t be empty',
        onSaved: (value) => _memberName = value,
      ),
      TextFormField(
        decoration: InputDecoration(
            labelText: 'Registered Mobile No.', hintText: "+917000303658"),
        initialValue: _memberMobileNo,
        validator: (value) =>
            value!.isNotEmpty ? null : 'Registered Mobile No. can\'t be empty',
        onSaved: (value) => _memberMobileNo = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Coupon Code'),
        initialValue: _couponCode,
        validator: (value) =>
            value!.isNotEmpty ? null : 'Coupon Code can\'t be empty',
        onSaved: (value) => _couponCode = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Percentage OFF'),
        initialValue: _percentage != null ? '$_percentage' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _percentage = int.tryParse(value!) ?? 0,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'UPI'),
        initialValue: _upi,
        validator: (value) => value!.isNotEmpty ? null : 'UPI can\'t be empty',
        onSaved: (value) => _upi = value,
      ),
    ];
  }
}
