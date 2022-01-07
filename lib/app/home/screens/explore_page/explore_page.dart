import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradient_title_text.dart';
import 'package:fastguide/app/widgets/silverScaffoldBody.dart';
import 'package:fastguide/app/widgets/customListTileWidget.dart';
import 'package:fastguide/app/widgets/firebase_contains_widgets/batches_gridViews.dart';
import 'package:fastguide/app/drawer/navigation_drawer.dart';
import 'package:fastguide/app/widgets/webpage_iframe_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ExplorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _launchURL({required String url}) async => await canLaunch(url)
        ? await launch(url)
        : throw 'Could not launch $url';
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      body: SilverScaffoldBody(
        body: _buildContent(context),
        firstTitle: titleText('FastGuide'),
        secondTitle: gradientText(
          text: 'Explore',
          color1: Color(0xff0038fe),
          color2: Color(0xff42d1ec),
          fontFamily: "Poppins",
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
        leadingAppBarIcon: Icon(
          Icons.menu,
          color: Colors.blue,
        ),
        leadingAppBarFucntion: 1,
        actionListTileIcon: Icon(Icons.call),
        actionListTileText: Text(
          "CONTACT",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
            fontFamily: 'Fredoka One',
          ),
        ),
        actionListTileOnTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => WebPageViewiFrame(
              url: 'https://fastguide.in/contact-us-app/',
              color: Colors.blue.shade700,
              title: 'Contact Us',
            ),
          ),
        ),
        imageLink: 'https://fastguide.in/wp-content/uploads/2021/07/bg.png',
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(height: 20.0),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(2.0, 2.0),
                    blurRadius: 5.0,
                  ),
                ],
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: 50.0,
                      child: Divider(
                        color: Colors.blue.shade100,
                        thickness: 5.0,
                      ),
                    ),
                    batchesGridView(context),
                    SizedBox(height: 10.0),
                    Divider(),
                    SizedBox(height: 10.0),
                    customListTileWidget(),
                    SizedBox(height: 10.0),
                    Divider(),
                    SizedBox(height: 10.0),
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
