import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/report_view/user_detail/verified_student.dart';
import 'package:fastguide/app/widgets/firebase_contains_widgets/batches_gridViews.dart';
import 'package:fastguide/app/widgets/slidder_depart/image_slidder.dart';
import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradient_title_text.dart';
import 'package:fastguide/app/widgets/firebase_contains_widgets/courses_gridview.dart';
import 'package:fastguide/app/widgets/silverScaffoldBody.dart';
import 'package:fastguide/app/widgets/update_new_version.dart';
import 'package:fastguide/app/widgets/webpage_iframe_page.dart';
import 'package:fastguide/login/data_models/user_class_model.dart';
import 'package:fastguide/login/data_models/user_model.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fastguide/app/widgets/customListTileWidget.dart';
import 'package:fastguide/app/drawer/navigation_drawer.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<UserData?>(
      stream: database.UserStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          return Scaffold(
            body: _scaffoldWidget(
              context: context,
              userData: user!,
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

  Widget _scaffoldWidget({
    required BuildContext context,
    required UserData userData,
  }) {
    void _launchURL({required String url}) async => await canLaunch(url)
        ? await launch(url)
        : throw 'Could not launch $url';
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      body: SilverScaffoldBody(
        body: _buildContent(context, userData),
        firstTitle: titleText('FastGuide'),
        secondTitle: gradientText(
          text: 'FG Academy',
          color1: Colors.black87,
          color2: Colors.black54,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w600,
          fontSize: 18,
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
        bannerText: gradientText(
          text: 'Welcome',
          color1: Colors.black87,
          color2: Colors.black54,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
        bannerSubText: Row(
          children: [
            Expanded(
              child: gradientText(
                text: '${userData.userName}  ',
                color1: Color(0xff0038fe),
                color2: Color(0xff42d1ec),
                fontFamily: "Poppins",
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            verifiedStudent(context, userData),
          ],
        ),
        imageLink:
            'https://fastguide.in/wp-content/uploads/2021/07/Untitled-design-1.png',
      ),
    );
  }

  Widget _buildContent(BuildContext context, UserData userData) {
    final database = Provider.of<Database>(context, listen: false);
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
              //padding: EdgeInsets.symmetric(horizontal: 20.0),
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
                    SizedBox(height: 1.0),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: _userClassStreamBuilder(database, userData),
                    ),
                    SizedBox(height: 2.0),
                    Divider(),
                    SizedBox(height: 20.0),
                    NewVersionReminder(),
                    SizedBox(height: 10.0),
                    _noticeBoard(),
                    SizedBox(height: 10.0),
                    customListTileWidget(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _noticeBoard() {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 15.0),
          padding: EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent),
            // borderRadius: BorderRadius.circular(5.0),
            shape: BoxShape.rectangle,
          ),
          child: ImageSlidder(),
        ),
        Container(
          padding: EdgeInsets.only(left: 15.0),
          alignment: Alignment.centerRight,
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.blue.shade900,
                      Colors.blueAccent.shade700,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: gradientText(
                  text: "Notice Board",
                  color1: Colors.white,
                  color2: Colors.white,
                  fontFamily: "Poppins",
                  fontSize: 15.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _ifClassSelectedWidget(
      String batchName, BuildContext context, Batch batch, UserData userData) {
    return Column(
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(left: 10.0),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: gradientText(
                          text: batch.tag,
                          color1: Colors.white,
                          color2: Colors.white,
                          fontFamily: "Poppins",
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: gradientText(
                          text: batchName,
                          color1: Colors.blue,
                          color2: Colors.blue.shade800,
                          fontFamily: "Poppins",
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 15.0),
              GestureDetector(
                onTap: () => _addToClass(context, userData),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.blueAccent.shade700,
                        Colors.blue.shade900,
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.change_circle,
                        color: Colors.white,
                        size: 21.0,
                      ),
                      SizedBox(height: 5.0),
                      gradientText(
                        text: "Change\n Class",
                        color1: Colors.white,
                        color2: Colors.white,
                        fontFamily: 'Mukta',
                        fontSize: 10.0,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 1.0),
        Divider(),
        coursesGridView(context, batch),
      ],
    );
  }

  _addToClass(BuildContext context, UserData userData) async {
    final database = Provider.of<Database>(context, listen: false);
    final userClassData = UserClassData(
      id: "userClassDoc",
      userClass: "change",
    );
    await database.setUserClass(
      userClassData: userClassData,
    );
    print('ADDED To Class');
  }

  Widget _ifClassNotSelectedWidget(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 30.0),
          gradientText(
            text: "Add To Class To Start Journey!",
            color1: Colors.black,
            color2: Colors.black87,
            fontFamily: "Poppins",
            fontSize: 15.0,
          ),
          SizedBox(height: 15.0),
          gradientText(
            text: "( अपनी कक्षा चुने 😀 )",
            color1: Colors.pink,
            color2: Colors.pinkAccent,
            fontFamily: "Mukta",
            fontSize: 20.0,
            fontWeight: FontWeight.w800,
          ),
          SizedBox(height: 10.0),
          batchesGridViewForSelect(context),
        ],
      ),
    );
  }

  StreamBuilder<List<UserClassData>> _userClassStreamBuilder(
      Database database, UserData userData) {
    return StreamBuilder<List<UserClassData>>(
      stream: database.UsersClassStream(userData: userData),
      builder: (context, snapshot) {
        final userClassData = snapshot.data;
        final userClass = userClassData?.first;
        if (snapshot.hasData) {
          return StreamBuilder<UserClassData>(
            stream: database.UserClassStream(
                userClassData: userClass!, userData: userData),
            builder: (context, snapshot) {
              final userClassDoc = snapshot.data;
              final userClassDocId = userClassDoc?.userClass;
              if (snapshot.hasData) {
                return StreamBuilder<Batch>(
                  stream: database.batchStream(
                    batchId: userClassDocId!,
                  ),
                  builder: (context, snapshot) {
                    final batch = snapshot.data;
                    final batchName = batch?.batchName;
                    if (snapshot.hasData) {
                      return _ifClassSelectedWidget(
                        batchName!,
                        context,
                        batch!,
                        userData,
                      );
                    } else if (snapshot.hasError) {
                      Container(
                          child:
                              Center(child: Text('Something Went Wrong !!')));
                    }
                    ;
                    return _ifClassNotSelectedWidget(context);
                  },
                );
              } else if (snapshot.hasError) {
                Container(
                    child: Center(child: Text('Something Went Wrong !!')));
              }
              ;
              return Center(child: CircularProgressIndicator());
            },
          );
        } else if (snapshot.hasError) {
          Container(child: Center(child: Text('Something Went Wrong !!')));
        }
        ;
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
