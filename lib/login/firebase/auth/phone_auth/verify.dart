import 'package:device_info/device_info.dart';
import 'package:fastguide/app/home/main_app_page.dart';
import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
import 'package:fastguide/landing_page.dart';
import 'package:fastguide/login/data_models/user_device_model.dart';
import 'package:fastguide/login/providers/phone_auth.dart';
import 'package:fastguide/login/utils/back_button.dart';
import 'package:fastguide/login/utils/bottom_bar_login_page.dart';
import 'package:fastguide/login/utils/constants.dart';
import 'package:fastguide/login/utils/widgets.dart';
import 'package:fastguide/services/auth.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhoneAuthVerify extends StatefulWidget {
  final Color cardBackgroundColor = Color(0xFFFCA967);
  final String logo = Assets.firebase;
  final String appName = "Awesome app";

  @override
  _PhoneAuthVerifyState createState() => _PhoneAuthVerifyState();
}

class _PhoneAuthVerifyState extends State<PhoneAuthVerify> {
  double? _height, _width, _fixedPadding;

  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  FocusNode focusNode5 = FocusNode();
  FocusNode focusNode6 = FocusNode();
  String code = "";
  String otpCode = "";

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

  final scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: "scaffold-verify-phone");
  bool _waitForSecond = false;
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fixedPadding = _height! * 0.025;

    final phoneAuthDataProvider =
        Provider.of<PhoneAuthDataProvider>(context, listen: false);

    phoneAuthDataProvider.setMethods(
      onStarted: onStarted,
      onError: onError,
      onFailed: onFailed,
      onVerified: onVerified,
      onCodeResent: onCodeResent,
      onCodeSent: onCodeSent,
      onAutoRetrievalTimeout: onAutoRetrievalTimeOut,
    );
    return Scaffold(
      key: scaffoldKey,
      bottomNavigationBar: BottomBarLoginPage(),
      backgroundColor: Colors.white.withOpacity(0.95),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/login_bg.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _getBody(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getBody() =>
      Container(alignment: Alignment.center, child: _getColumnBody());

  Widget _getColumnBody() => Column(
        children: <Widget>[
          SizedBox(height: 100.0),
          Container(
            child: Column(
              children: [
                gradientText(
                  text: "OTP Sent !",
                  color1: Colors.indigo.shade500,
                  color2: Colors.blue.shade500,
                  fontFamily: "Poppins",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0, left: _fixedPadding! + 50.0),
            child: Container(
              child: Align(
                alignment: Alignment.centerLeft,
                child: gradientText(
                  text: "Enter OTP",
                  color1: Colors.black87,
                  color2: Colors.black87,
                  fontFamily: "Roboto",
                  fontSize: 14,
                ),
              ),
            ),
          ),
          SizedBox(height: 25.0),
          Padding(
            padding: EdgeInsets.only(
                left: _fixedPadding! + 50.0, right: _fixedPadding! + 50.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.blue.shade100,
              ),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      height: 50.0,
                      width: 50.0,
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5.0),
                            bottomLeft: Radius.circular(5.0)),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.indigo,
                            Colors.blue,
                          ],
                        ),
                        shape: BoxShape.rectangle,
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: TextField(
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w300,
                      ),
                      onChanged: (value) {
                        setState(() {
                          otpCode = value;
                        });
                      },
                      autofocus: false,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: "OTP",
                        border: InputBorder.none,
                        errorMaxLines: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 32.0),
          GestureDetector(
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LandingPage(),
              ),
            ),
            child: gradientText(
              text: "Change Mobile Number",
              color1: Colors.indigo.shade500,
              color2: Colors.blue.shade500,
              fontFamily: "Roboto",
              fontSize: 15,
              textDecoration: TextDecoration.underline,
            ),
          ),
          // Row(
          //   mainAxisSize: MainAxisSize.min,
          //   children: <Widget>[
          //     getPinField(key: "1", focusNode: focusNode1),
          //     SizedBox(width: 5.0),
          //     getPinField(key: "2", focusNode: focusNode2),
          //     SizedBox(width: 5.0),
          //     getPinField(key: "3", focusNode: focusNode3),
          //     SizedBox(width: 5.0),
          //     getPinField(key: "4", focusNode: focusNode4),
          //     SizedBox(width: 5.0),
          //     getPinField(key: "5", focusNode: focusNode5),
          //     SizedBox(width: 5.0),
          //     getPinField(key: "6", focusNode: focusNode6),
          //     SizedBox(width: 5.0),
          //   ],
          // ),

          _waitForSecond ? Text("Please Wait ... ") : Text(""),
          SizedBox(height: 32.0),
          GestureDetector(
            onTap: signIn,
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
                child: Text(
                  'Verify',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  _showSnackBar(String text) {
    final snackBar = SnackBar(
      content: Text('$text'),
      duration: Duration(seconds: 2),
    );
    // if (mounted) Scaffold.of(context).showSnackBar(snackBar);
    scaffoldKey.currentState!.showSnackBar(snackBar);
  }

  signIn() {
    if (otpCode.length != 6) {
      _showSnackBar("Enter Correct OTP");
    }
    if (otpCode.length == 6) {
      _showSnackBar("Verifying ...");
      Provider.of<PhoneAuthDataProvider>(context, listen: false)
          .verifyOTPAndLogin(smsCode: otpCode);
    }
  }

  // This will return pin field - it accepts only single char
  Widget getPinField({String? key, FocusNode? focusNode}) => SizedBox(
        height: 40.0,
        width: 35.0,
        child: TextField(
          key: Key(key!),
          expands: false,
//          autofocus: key.contains("1") ? true : false,
          autofocus: false,
          focusNode: focusNode,
          onChanged: (String value) {
            if (value.length == 1) {
              code += value;
              switch (code.length) {
                case 1:
                  FocusScope.of(context).requestFocus(focusNode2);
                  break;
                case 2:
                  FocusScope.of(context).requestFocus(focusNode3);
                  break;
                case 3:
                  FocusScope.of(context).requestFocus(focusNode4);
                  break;
                case 4:
                  FocusScope.of(context).requestFocus(focusNode5);
                  break;
                case 5:
                  FocusScope.of(context).requestFocus(focusNode6);
                  break;
                default:
                  FocusScope.of(context).requestFocus(FocusNode());
                  break;
              }
            }
          },
          maxLengthEnforced: false,
          textAlign: TextAlign.center,
          cursorColor: Colors.white,
          keyboardType: TextInputType.number,
          style: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.white),
//          decoration: InputDecoration(
//              contentPadding: const EdgeInsets.only(
//                  bottom: 10.0, top: 10.0, left: 4.0, right: 4.0),
//              focusedBorder: OutlineInputBorder(
//                  borderRadius: BorderRadius.circular(5.0),
//                  borderSide:
//                      BorderSide(color: Colors.blueAccent, width: 2.25)),
//              border: OutlineInputBorder(
//                  borderRadius: BorderRadius.circular(5.0),
//                  borderSide: BorderSide(color: Colors.white))),
        ),
      );

  onStarted() {
    _showSnackBar("PhoneAuth started");
//    _showSnackBar(phoneAuthDataProvider.message);
  }

  onCodeSent() {
    _showSnackBar("OTP sent");
//    _showSnackBar(phoneAuthDataProvider.message);
  }

  onCodeResent() {
    _showSnackBar("OTP resent");
//    _showSnackBar(phoneAuthDataProvider.message);
  }

  onVerified() async {
    _waitForSecond = true;
    await Future.delayed(Duration(seconds: 3), () {
      print("Start >>>>>>>>>>>>>>>>>>>>>");
    });
    final auth = await Provider.of<AuthBase>(context, listen: false);
    final database = await Provider.of<Database>(context, listen: false);
    _showSnackBar(
        "${Provider.of<PhoneAuthDataProvider>(context, listen: false).message}");
    _waitForSecond = false;

    // --- user device data Database --------
    final userDeviceData = await UserDeviceData(
      id: auth.currentUser.phoneNumber!,
      mobileNo: auth.currentUser.phoneNumber!,
      androidId: userDeviceAndroidId!,
      deviceModel: deviceModel!,
      deviceManufacture: deviceManufacture!,
      lastLogin: currentDate(),
    );
    await database.setUserDevice(userDeviceData: userDeviceData);
    print('user loging >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');

    // --- -- -- -- --

    Navigator.of(context).pushReplacement(
      CupertinoPageRoute(
        builder: (context) => LandingPage1(),
      ),
    );
  }

  onFailed() async {
//    _showSnackBar(phoneAuthDataProvider.message);
    _showSnackBar("PhoneAuth failed");
    await Future.delayed(Duration(seconds: 3), () {});
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LandingPage(),
      ),
    );
  }

  onError() {
//    _showSnackBar(phoneAuthDataProvider.message);
    _showSnackBar(
        "PhoneAuth error ${Provider.of<PhoneAuthDataProvider>(context, listen: false).message}");
  }

  onAutoRetrievalTimeOut() async {
    _showSnackBar("OTP Timeout");
    await Future.delayed(Duration(seconds: 3), () {});
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LandingPage(),
      ),
    );
  }
}
