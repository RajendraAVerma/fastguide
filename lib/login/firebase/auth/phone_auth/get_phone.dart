import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
import 'package:fastguide/login/firebase/auth/phone_auth/select_country.dart';
import 'package:fastguide/login/firebase/auth/phone_auth/verify.dart';
import 'package:fastguide/login/providers/countries.dart';
import 'package:fastguide/login/providers/phone_auth.dart';
import 'package:fastguide/login/utils/back_button.dart';
import 'package:fastguide/login/utils/bottom_bar_login_page.dart';
import 'package:fastguide/login/utils/constants.dart';
import 'package:fastguide/login/utils/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneAuthGetPhone extends StatefulWidget {
  final Color? cardBackgroundColor = Colors.white;
  final String? logo = Assets.firebase;
  final String? appName = "FastGuide";

  @override
  _PhoneAuthGetPhoneState createState() => _PhoneAuthGetPhoneState();
}

class _PhoneAuthGetPhoneState extends State<PhoneAuthGetPhone> {
  double? _height, _width, _fixedPadding;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: "scaffold-get-phone");

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fixedPadding = _height! * 0.025;
    final countriesProvider = Provider.of<CountryProvider>(context);
    final loader = Provider.of<PhoneAuthDataProvider>(context).loading;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomBarLoginPage(),
      body: Container(
        width: double.infinity,
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
              loader
                  ? Container(child: CircularProgressIndicator())
                  : _getBody(countriesProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getBody(CountryProvider countriesProvider) => Container(
        alignment: Alignment.center,
        child: countriesProvider.countries.length > 0
            ? _getColumnBody(countriesProvider)
            : Center(
                child: CircularProgressIndicator(),
              ),
      );

  Widget _getColumnBody(CountryProvider countriesProvider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 100.0),
        Container(
          child: Column(
            children: [
              gradientText(
                text: "Welcome Back !",
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
          padding: EdgeInsets.only(top: 20.0, left: _fixedPadding! + 30.0),
          child: Container(
            child: Align(
              alignment: Alignment.centerLeft,
              child: gradientText(
                text: "Enter Mobile Number",
                color1: Colors.black87,
                color2: Colors.black87,
                fontFamily: "Roboto",
                fontSize: 14,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: 10.0,
              left: _fixedPadding! + 30,
              right: _fixedPadding! + 30,
              bottom: _fixedPadding!),
          child: Container(
            child: PhoneNumberField(
              controller:
                  Provider.of<PhoneAuthDataProvider>(context, listen: false)
                      .phoneNumberController,
              prefix: countriesProvider.selectedCountry.dialCode ?? "+91",
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(width: _fixedPadding),
            Icon(Icons.info, color: Colors.white, size: 20.0),
            SizedBox(width: 10.0),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'We will send ',
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w400)),
                    TextSpan(
                        text: 'OTP',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700)),
                    TextSpan(
                        text: ' to this mobile number',
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
            ),
            SizedBox(width: _fixedPadding),
          ],
        ),
        SizedBox(height: _fixedPadding! * 1.5),
        GestureDetector(
          onTap: startPhoneAuth,
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
                'Send OTP',
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
  }

  _showSnackBar(String text) {
    final snackBar = SnackBar(
      content: Text('$text'),
    );
//    if (mounted) Scaffold.of(context).showSnackBar(snackBar);
    scaffoldKey.currentState!.showSnackBar(snackBar);
  }

  startPhoneAuth() async {
    final phoneAuthDataProvider =
        Provider.of<PhoneAuthDataProvider>(context, listen: false);

    phoneAuthDataProvider.loading = true;
    await Future.delayed(Duration(seconds: 1), () {});
    var countryProvider = Provider.of<CountryProvider>(context, listen: false);
    bool validPhone = await phoneAuthDataProvider.instantiate(
      dialCode: countryProvider.selectedCountry.dialCode,
      onCodeSent: () {
        Navigator.of(context).pushReplacement(CupertinoPageRoute(
            builder: (BuildContext context) => PhoneAuthVerify()));
      },
      onFailed: () {
        _showSnackBar(phoneAuthDataProvider.message!);
      },
      onError: () {
        _showSnackBar(phoneAuthDataProvider.message!);
      },
    );
    if (!validPhone) {
      phoneAuthDataProvider.loading = false;
      _showSnackBar("Oops! Number seems invaild");
      return;
    }

    phoneAuthDataProvider.loading = false;
  }
}
