import 'package:fastguide/admin/main_admin_page.dart';
import 'package:fastguide/app/drawer/member_page.dart';
import 'package:fastguide/app/drawer/payment_history/payment_history.dart';
import 'package:fastguide/app/drawer/subscription/subscription_detail_page.dart';
import 'package:fastguide/app/drawer/user_profile/user_profile_page.dart';
import 'package:fastguide/app/home/main_app_page.dart';
import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
import 'package:fastguide/app/widgets/custom_icon_button.dart';
import 'package:fastguide/app/widgets/webpage_iframe_page.dart';
import 'package:fastguide/login/data_models/user_model.dart';
import 'package:fastguide/services/auth.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigationDrawerWidget extends StatefulWidget {
  @override
  _NavigationDrawerWidgetState createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  @override
  void dispose() {
    super.dispose();
  }

  _signOut() async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    await auth.signOut();
    // Navigator.of(context).pushReplacement(
    //   CupertinoPageRoute(
    //     builder: (context) => LandingPage(),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.indigo.withOpacity(1), BlendMode.dstIn),
                alignment: Alignment.topLeft,
                image: AssetImage("assets/images/bg1.png"),
              ),
              color: Colors.white),
          child: _userDetail(),
        ),
      ),
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
          final userData = snapshot.data;
          final userName = userData?.userName;
          return Column(
            children: [
              _topBar(userData!),
              _middleBar(context, admin!, userData),
              _bottomBar(),
            ],
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _middleBar(BuildContext context, String admin, UserData userData) {
    void _launchURL({required String url}) async => await canLaunch(url)
        ? await launch(url)
        : throw 'Could not launch $url';
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          child: Column(
            children: <Widget>[
              SizedBox(height: 5.0),
              buildMenuItem(
                text: 'Home',
                icon: Icons.home,
                onClicked: () => selectedItem(context, 0),
              ),
              buildMenuItem(
                text: 'Telegram Group',
                icon: Icons.group,
                onClicked: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => WebPageViewiFrame(
                          url: 'https://fastguide.in/telegram-group/',
                          color: Colors.blue.shade700,
                          title: 'Telegram Group',
                        ))),
              ),
              buildMenuItem(
                text: 'Subscription Detail',
                icon: Icons.subscriptions_rounded,
                onClicked: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SubscriptionDetailPage())),
              ),
              buildMenuItem(
                text: 'Purchase History',
                icon: Icons.credit_card,
                onClicked: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PaymentHistory(
                          userData: userData,
                        ))),
              ),
              buildMenuItem(
                text: 'Partner',
                icon: Icons.card_membership,
                onClicked: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Team())),
              ),
              buildMenuItem(
                text: 'About App',
                icon: Icons.apps,
                onClicked: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => WebPageViewiFrame(
                          url: 'https://fastguide.in/about/',
                          color: Colors.blue.shade700,
                          title: 'About App',
                        ))),
              ),
              //buildMenuItem(text: 'Conatact', icon: Icons.call),

              buildMenuItem(
                text: 'Share App',
                icon: Icons.share,
                onClicked: () => Share.share(
                    'Download FastGuide App :-  https://fastguide.in/download-app',
                    subject: 'FastGuide - Self Directed Learning App !'),
              ),
              buildMenuItem(
                text: 'Rate App',
                icon: Icons.rate_review,
                onClicked: () => _launchURL(
                  url: "https://fastguide.in/app/",
                ),
              ),

              buildMenuItem(
                text: 'Terms and Condition',
                icon: Icons.info,
                onClicked: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => WebPageViewiFrame(
                          url: 'https://fastguide.in/app-terms-and-condition/',
                          color: Colors.blue.shade700,
                          title: 'Terms And Conditions',
                        ))),
              ),
              admin == "+919109796860"
                  ? buildMenuItem(
                      text: 'Admin Area',
                      icon: Icons.admin_panel_settings,
                      onClicked: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => MainAdminPage(),
                          ),
                        );
                      })
                  : SizedBox(),
              admin == "+917000303658"
                  ? buildMenuItem(
                      text: 'Admin Area',
                      icon: Icons.admin_panel_settings,
                      onClicked: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => MainAdminPage(),
                          ),
                        );
                      })
                  : SizedBox(),
              buildMenuItem(
                text: 'Logout',
                icon: Icons.logout,
                onClicked: _signOut,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topBar(UserData userData) {
    return Container(
      height: 145,
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Container(
        margin: EdgeInsets.only(top: 50.0),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Image(
                image: NetworkImage(
                  "https://image.flaticon.com/icons/png/512/3237/3237472.png",
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  gradientText(
                    text: userData.userName,
                    color1: Colors.black,
                    color2: Colors.black54,
                    fontFamily: "Poppins",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    userData.mobileNo,
                    style: TextStyle(
                      color: Colors.black54,
                      fontFamily: "Poppins",
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconButton(
              color: Colors.white,
              elevation: 20.0,
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => UserProfilePage())),
              child: Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomBar() {
    void _launchURL({required String url}) async => await canLaunch(url)
        ? await launch(url)
        : throw 'Could not launch $url';
    return Container(
      height: 80.0,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: GestureDetector(
        onTap: () => _launchURL(
          url: "tel:+917000303658",
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xffD4145A),
                Color(0xffFBB03B),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 0),
                blurRadius: 5.0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.call, color: Colors.white),
              SizedBox(width: 10),
              Text(
                "Enquire Now",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Poppins",
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildMenuItem1({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.black;
    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(text),
      onTap: onClicked,
    );
  }

  buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.blue;
    return GestureDetector(
      onTap: onClicked,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 30,
            ),
            SizedBox(width: 25.0),
            Expanded(
              child: gradientText(
                text: text,
                color1: Colors.black87,
                color2: Colors.black54,
                fontFamily: "Poppins",
                fontSize: 14,
              ),
            ),
            SizedBox(width: 5.0),
          ],
        ),
      ),
    );
  }

  selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();
    switch (index) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MainAppPage(),
          ),
        );
        break;
    }
  }
}
