import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/show_alert_dialog.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/show_exception_alert_dialog.dart';
import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
import 'package:fastguide/landing_page.dart';
import 'package:fastguide/login/data_models/user_class_model.dart';
import 'package:fastguide/login/data_models/user_device_model.dart';
import 'package:fastguide/login/data_models/user_model.dart';
import 'package:fastguide/services/auth.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirstTimeUserForm extends StatefulWidget {
  const FirstTimeUserForm({
    Key? key,
    required this.database,
  }) : super(key: key);
  final Database database;

  static Future<void> show(
    BuildContext context, {
    Database? database,
  }) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => FirstTimeUserForm(
          database: database!,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _FirstTimeUserFormState createState() => _FirstTimeUserFormState();
}

class _FirstTimeUserFormState extends State<FirstTimeUserForm> {
  @override
  void dispose() {
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  String? _userName;
  String? _email;
  String? _address;

  String? userDeviceAndroidId;
  String? deviceModel;
  String? deviceManufacture;

  Future<void> _userDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print('Running on ${androidInfo.model}');
    userDeviceAndroidId = androidInfo.id;
    deviceModel = androidInfo.model;
    deviceManufacture = androidInfo.manufacturer;
  }

  @override
  void initState() {
    _userDeviceId();
    super.initState();
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
    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);
    if (_validateAndSaveForm()) {
      try {
        final jobs = await database.UsersStream().first;
        final allNames = jobs.map((job) => job.userName).toList();

        if (allNames.contains(_userName)) {
          showAlertDialog(
            context,
            title: 'Name already used',
            content: 'Please choose a different Chapter name',
            defaultActionText: 'OK',
          );
        } else {
          final id = auth.currentUser.phoneNumber;
          final userData = UserData(
            id: id!,
            userName: _userName!,
            mobileNo: id,
            email: _email!,
            address: _address!,
            registerDate: currentDate().toString(),
          );
          await widget.database.setUser(userData: userData);
          ////-------
          print('ADDED User Data');
          // --- userclass ---

          final userClassData = UserClassData(
            id: "userClassDoc",
            userClass: "firstTime",
          );
          await widget.database.setUserClass(
            userClassData: userClassData,
          );
          print('ADDED To Class');
          // --- user device data Database --------
          final userDeviceData = UserDeviceData(
            id: id,
            mobileNo: id,
            androidId: userDeviceAndroidId!,
            deviceModel: deviceModel!,
            deviceManufacture: deviceManufacture!,
            lastLogin: currentDate(),
          );
          await widget.database.setUserDevice(userDeviceData: userDeviceData);
          print('ADDED User device');
          // --- -- -- -- --
          ///--------
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => LandingPage1()));
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

  _signOut() async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    await auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xffb621fe),
                Color(0xff1fd1f9),
              ],
            ),
          ),
        ),
        elevation: 2.0,
        //title: Text(widget.chapter == null ? 'New Chapter' : 'Edit Chapter'),
        actions: <Widget>[
          FlatButton(
            child: Row(
              children: [
                Text(
                  'Logout',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                SizedBox(width: 5.0),
                Icon(
                  Icons.login,
                  color: Colors.white,
                ),
              ],
            ),
            onPressed: _signOut,
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
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          gradientText(
            text: "Registration",
            color1: Colors.blue.shade900,
            color2: Colors.blueAccent,
            fontFamily: 'Poppins',
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'नाम (Name)'),
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
        decoration: InputDecoration(labelText: 'पता (Address)'),
        initialValue: _address,
        validator: (value) =>
            value!.isNotEmpty ? null : 'Address can\'t be empty',
        onSaved: (value) => _address = value,
      ),
      SizedBox(height: 10.0),
      Text(
        "Fill in the correct full address!! We will send all the notes to this address.",
        style: TextStyle(
          fontSize: 10.0,
          color: Colors.black87,
        ),
      ),
      SizedBox(height: 20.0),
      GestureDetector(
        onTap: _submit,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(0xff1fd1f9).withOpacity(0.3),
                offset: Offset(0.0, 0.0),
                blurRadius: 5.0,
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xffb621fe),
                Color(0xff1fd1f9),
              ],
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Continue जारी रखें',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontFamily: "Mukta",
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
      ),
    ];
  }
}
