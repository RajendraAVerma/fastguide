import 'package:fastguide/admin/screens/report_view/user_detail/user_subscribe_courses/user_subscribe_page.dart';
import 'package:fastguide/app/drawer/user_profile/user_profile_edit.dart';
import 'package:fastguide/app/home/main_app_page.dart';
import 'package:fastguide/app/widgets/custom_icon_button.dart';
import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
import 'package:fastguide/login/data_models/user_model.dart';
import 'package:fastguide/services/auth.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _userDetail(),
    );
  }

  Widget _userDetail() {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    final admin = auth.currentUser.phoneNumber;
    void _launchURL({required String url}) async => await canLaunch(url)
        ? await launch(url)
        : throw 'Could not launch $url';
    return StreamBuilder<UserData?>(
      stream: database.UserStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          final userName = user?.userName;
          return NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  pinned: true,
                  floating: false,
                  expandedHeight: 200.0,
                  backgroundColor: Colors.white,
                  elevation: 0.0,
                  title: _titleMethod(user!),
                  flexibleSpace: flexibleSpaceMethod(
                    AssetImage("assets/images/login_bg.png"),
                    Text("data"),
                    Text("hhdfhdfhd"),
                  ),
                ),
              ];
            },
            body: Container(
              child: _buildContent(user!),
            ),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  LayoutBuilder flexibleSpaceMethod(
    ImageProvider? imageProvider,
    Text? bannerText,
    Text? bannerSubText,
  ) {
    var top = 0.0;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        top = constraints.biggest.height;

        return FlexibleSpaceBar(
          collapseMode: CollapseMode.parallax,
          centerTitle: true,
          title: AnimatedOpacity(
            curve: Curves.easeInQuad,
            duration: Duration(milliseconds: 200),
            opacity: top >= 150 ? 1.0 : 0.0,
          ),
          background: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                alignment: Alignment.topRight,
                image: imageProvider == null
                    ? AssetImage("assets/images/bg.png")
                    : imageProvider,
              ),
            ),
          ),
        );
      },
    );
  }

  Row _titleMethod(UserData userData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // CustomIconButton(
        //   color: Colors.blue,
        //   elevation: 2.0,
        //   onTap: () => Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => MainAppPage(),
        //     ),
        //   ),
        //   child: Icon(Icons.arrow_back),
        // ),
        Spacer(),
        CustomIconButton(
          color: Colors.blue,
          elevation: 2.0,
          onTap: () => EditUserProfilePage.show(context, userData: userData),
          child: Icon(Icons.edit),
        ),
      ],
    );
  }
}

_buildContent(UserData userData) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 30.0),
    color: Colors.white,
    alignment: Alignment.center,
    child: Column(
      children: [
        SizedBox(height: 40.0),
        Container(
          height: 50.0,
          child: gradientText(
            text: userData.userName,
            color1: Colors.blue.shade600,
            color2: Colors.indigo.shade300,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w800,
            fontSize: 25,
          ),
        ),
        Row(
          children: [
            Icon(Icons.call),
            SizedBox(width: 20.0),
            Expanded(
              child: gradientText(
                text: userData.mobileNo,
                color1: Colors.black87,
                color2: Colors.indigo,
                fontFamily: "Poppins",
                fontSize: 14,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.0),
        Row(
          children: [
            Icon(Icons.email),
            SizedBox(width: 20.0),
            Expanded(
              child: gradientText(
                text: userData.email,
                color1: Colors.black87,
                color2: Colors.indigo,
                fontFamily: "Poppins",
                fontSize: 14,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.0),
        Row(
          children: [
            Icon(Icons.home),
            SizedBox(width: 20.0),
            Expanded(
              child: gradientText(
                text: userData.address,
                color1: Colors.black87,
                color2: Colors.indigo,
                fontFamily: "Poppins",
                fontSize: 14,
              ),
            ),
          ],
        ),
        SubscriptionDetailPage(userData: userData)
      ],
    ),
  );
}
