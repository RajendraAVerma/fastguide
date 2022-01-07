import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradient_title_text.dart';
import 'package:fastguide/app/widgets/customListTileWidget.dart';
import 'package:fastguide/app/widgets/firebase_contains_widgets/courses_gridview.dart';
import 'package:fastguide/app/widgets/silverScaffoldBody.dart';
import 'package:fastguide/app/drawer/navigation_drawer.dart';
import 'package:fastguide/login/data_models/user_class_model.dart';
import 'package:fastguide/login/data_models/user_model.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CoursePage extends StatelessWidget {
  CoursePage({required this.batch, this.database});
  final Batch batch;
  final Database? database;

  static Future<void> show(BuildContext context, Batch batch) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => CoursePage(
          batch: batch,
          database: database,
        ),
      ),
    );
  }

  _addToClass(UserData userData) async {
    final userClassData = UserClassData(
      id: "userClassDoc",
      userClass: "${batch.id}",
    );
    await database!.setUserClass(
      userClassData: userClassData,
     
    );
    print('ADDED To Class');
  }

  @override
  Widget build(BuildContext context) {
    String themeColor1FromFirebase = batch.themeColor1;
    int themeColor1Int = int.parse(themeColor1FromFirebase);
    String themeColor2FromFirebase = batch.themeColor2;
    int themeColor2Int = int.parse(themeColor2FromFirebase);

    return _mainBuildContent(context, themeColor1Int, themeColor2Int);
  }

  Scaffold _mainBuildContent(
      BuildContext context, int themeColor1Int, int themeColor2Int) {
    void _launchURL({required String url}) async => await canLaunch(url)
        ? await launch(url)
        : throw 'Could not launch $url';
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      body: SilverScaffoldBody(
        body: Container(
          color: Colors.white,
          child: _buildContent(context),
        ),
        firstTitle: titleText(''),
        secondTitle: gradientText(
          text: batch.batchName,
          color1: Color(themeColor1Int),
          color2: Color(themeColor2Int),
          fontFamily: "Poppins",
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
        leadingAppBarIcon: Icon(
          Icons.arrow_back_rounded,
          color: Color(themeColor2Int),
        ),
        leadingAppBarFucntion: 2,
        actionListTileIcon: Icon(Icons.call),
        actionListTileText: Text(
          "CONTACT",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
            fontFamily: 'Fredoka One',
          ),
        ),
        actionListTileOnTap: () => _launchURL(
          url: "tel:+917000303658",
        ),
        imageLink: batch.thumnailLink,
        bannerText: gradientText(
          text: batch.batchName,
          color1: Color(themeColor1Int),
          color2: Color(themeColor2Int),
          fontFamily: "Poppins",
          fontWeight: FontWeight.w900,
          fontSize: 20,
        ),
        bannerSubText: gradientText(
          text: batch.tag,
          color1: Color(themeColor1Int),
          color2: Color(themeColor2Int),
          fontFamily: "Poppins",
          fontWeight: FontWeight.w700,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
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
                    coursesGridView(context, batch),
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
          Container(
            color: Colors.blue.shade50,
            width: double.infinity,
            height: 50,
            child: _isAddedClass(context),
          ),
        ],
      ),
    );
  }

  _isAddedClass(BuildContext context) {
    String themeColor1FromFirebase = batch.themeColor1;
    int themeColor1Int = int.parse(themeColor1FromFirebase);
    String themeColor2FromFirebase = batch.themeColor2;
    int themeColor2Int = int.parse(themeColor2FromFirebase);
    return StreamBuilder<UserData?>(
      stream: database!.UserStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final userData = snapshot.data;
          return StreamBuilder<List<UserClassData>>(
            stream: database!.UsersClassStream(userData: userData!),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final userClassData = snapshot.data;
                final userClass = userClassData?.first;

                return StreamBuilder<UserClassData>(
                  stream: database!.UserClassStream(
                      userClassData: userClass!, userData: userData),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final userClassDoc = snapshot.data;
                      final userClassDocId = userClassDoc?.userClass;
                      return GestureDetector(
                        onTap: () => _addToClass(userData),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(2.0, 2.0),
                                blurRadius: 5.0,
                              ),
                            ],
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(themeColor1Int),
                                Color(themeColor2Int),
                              ],
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50.0),
                              topRight: Radius.circular(50.0),
                            ),
                          ),
                          child: Center(
                            child: Container(
                              child: userClassDocId == batch.id
                                  ? Text(
                                      "Added 🤩",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15.0,
                                      ),
                                    )
                                  : Text(
                                      'Add To My Class😀',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15.0,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                Container(
                    child: Center(
                        child: Text('Something Went Wrong in Course!!')));
              }
              ;
              return Center(child: CircularProgressIndicator());
            },
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
