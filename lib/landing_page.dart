import 'package:device_info/device_info.dart';
import 'package:fastguide/app/home/main_app_page.dart';
import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
import 'package:fastguide/first_time_user/first_time_user_login_form.dart';
import 'package:fastguide/login/data_models/user_device_model.dart';
import 'package:fastguide/login/data_models/user_model.dart';
import 'package:fastguide/login/firebase/auth/phone_auth/get_phone.dart';
import 'package:fastguide/services/auth.dart';
import 'package:fastguide/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            return PhoneAuthGetPhone();
          } else {
            return FirstTimeLoginAddedToDataBase(context: context);
          }
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class LandingPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          return Provider<Database>(
            create: (_) => FirestoreDatabase(UserId: user!.uid),
            child: MaterialApp(
              theme: ThemeData(fontFamily: 'Roboto'),
              home: LandingPage(),
              debugShowCheckedModeBanner: false,
            ),
          );
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class FirstTimeLoginAddedToDataBase extends StatelessWidget {
  final BuildContext context;

  const FirstTimeLoginAddedToDataBase({Key? key, required this.context})
      : super(key: key);
  @override
  Widget build(context) {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<UserData?>(
      stream: database.UserStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          final userName = user?.userName;
          if (user == null) {
            print(userName);
            return FirstTimeUserForm(
              database: database,
            );
          } else {
            return DeviceCheckup(context: context);

            // MainAppPage();
          }
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class DeviceCheckup extends StatefulWidget {
  final BuildContext context;

  const DeviceCheckup({Key? key, required this.context}) : super(key: key);

  @override
  _DeviceCheckupState createState() => _DeviceCheckupState();
}

class _DeviceCheckupState extends State<DeviceCheckup> {
  String? userDeviceAndroidId;
  String? deviceModel;
  String? deviceManufacture;

  Future<void> _userDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print('Running on >>>>>>>>>>>>>>>>>>> ${androidInfo.model}');
    userDeviceAndroidId = androidInfo.id;
    deviceModel = androidInfo.model;
    deviceManufacture = androidInfo.manufacturer;
  }

  @override
  void initState() {
    _userDeviceId();
    super.initState();
  }

  @override
  Widget build(context) {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);

    return StreamBuilder<UserData?>(
      stream: database.UserStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final userData = snapshot.data;
          return StreamBuilder<UserDeviceData?>(
            stream: database.userDeviceStream(userData: userData!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                final user = snapshot.data;
                final userAndroidId = user?.androidId;
                if (userAndroidId!.contains(userDeviceAndroidId!)) {
                  return
                      //MainAdminPage();
                      MainAppPage();
                } else {
                  return _security_alert_page(context, userData, user!);
                }
              }
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          );
        }

        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Scaffold _security_alert_page(
    BuildContext context,
    UserData userData,
    UserDeviceData userDeviceData,
  ) {
    void _signOut() async {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
      // Navigator.of(context).pushReplacement(
      //   CupertinoPageRoute(
      //     builder: (context) => LandingPage(),
      //   ),
      // );
    }

    final String accountNo = userData.mobileNo;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        leading: IconButton(
            icon: FaIcon(FontAwesomeIcons.shieldAlt), onPressed: () {}),
        title: Text("Security Alert"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10.0),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: MediaQuery.of(context).size.height / 6,
                      child:
                          Image(image: AssetImage('assets/images/secure.png')),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 10.0,
                      ),
                      child: Column(
                        children: [
                          gradientText(
                            text: "Mobile No. - ${accountNo}",
                            color1: Colors.black,
                            color2: Colors.black,
                            fontFamily: "Mukta",
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: 10.0),
                          gradientText(
                            text:
                                "It looks like you have logged in to this account on another device as well.",
                            color1: Colors.black,
                            color2: Colors.black,
                            fontFamily: "Mukta",
                            fontSize: 15.0,
                          ),
                          SizedBox(height: 10.0),
                          gradientText(
                            text:
                                "If you want to log in your account on this device then we need to logout from other device.",
                            color1: Colors.black,
                            color2: Colors.black,
                            fontFamily: "Mukta",
                            fontSize: 15.0,
                          ),
                          SizedBox(height: 10.0),
                          SizedBox(height: 10.0),
                          gradientText(
                            text:
                                "ऐसा लगता है कि आपने इस खाते को किसी अन्य डिवाइस पर भी लॉग इन किया है।",
                            color1: Colors.black,
                            color2: Colors.black,
                            fontFamily: "Mukta",
                            fontSize: 18.0,
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            children: [
                              gradientText(
                                text:
                                    "Device Manufacture - ${userDeviceData.deviceManufacture}",
                                color1: Colors.black,
                                color2: Colors.black,
                                fontFamily: "Mukta",
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              gradientText(
                                text:
                                    "Device Model - ${userDeviceData.deviceModel}",
                                color1: Colors.black,
                                color2: Colors.black,
                                fontFamily: "Mukta",
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          gradientText(
                            text:
                                "For More Information Contact - +91 7000303658",
                            color1: Colors.black,
                            color2: Colors.black,
                            fontFamily: "Mukta",
                            fontSize: 14.0,
                          ),
                          SizedBox(height: 10.0),
                          gradientText(
                            text: "Click on the button to Continue.",
                            color1: Colors.black,
                            color2: Colors.black,
                            fontFamily: "Mukta",
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: 10.0),
                          gradientText(
                            text: "जारी रखने के लिए बटन पर क्लिक करें |",
                            color1: Colors.black,
                            color2: Colors.black,
                            fontFamily: "Mukta",
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {
                        return _signOut();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Continue",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: FaIcon(
                              FontAwesomeIcons.shieldAlt,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              return _signOut();
                            },
                          ),
                        ],
                      ),
                      color: Colors.green.shade700,
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          gradientText(
                            text: "Secured By -  ",
                            color1: Colors.black87,
                            color2: Colors.black87,
                            fontFamily: "Roboto",
                            fontSize: 18.0,
                          ),
                          gradientText(
                            text: "PICCOZONE",
                            color1: Colors.blue.shade900,
                            color2: Colors.blue.shade800,
                            fontFamily: "Poppins",
                            fontSize: 18.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
