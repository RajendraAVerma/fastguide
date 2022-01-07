import 'package:cached_network_image/cached_network_image.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/custom_raised_button.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/app/drawer/subscription/subcription_batch_listitem_builder.dart';
import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
import 'package:fastguide/app/widgets/custom_icon_button.dart';
import 'package:fastguide/login/data_models/user_model.dart';
import 'package:fastguide/login/data_models/user_subcribe_batch_model.dart';
import 'package:fastguide/login/data_models/user_subcribed_class_model.dart';
import 'package:fastguide/services/auth.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionDetailPage extends StatelessWidget {
  const SubscriptionDetailPage({Key? key, required this.userData})
      : super(key: key);
  final UserData userData;

  @override
  Widget build(BuildContext context) {
    return subscribedBatchesListView(context, userData);
  }
}

Widget subscribedBatchesListView(BuildContext context, UserData userData) {
  final database = Provider.of<Database>(context, listen: false);
  return StreamBuilder<List<UserSubcribedBatch>>(
    stream: database.UsersSubcribedBatchStream(userData: userData),
    builder: (context, snapshot) {
      return ListItemsBuilder<UserSubcribedBatch>(
        snapshot: snapshot,
        itemBuilder: (context, userSubcribedBatch) =>
            UserSubcribedBatchListTile(
          userSubcribedBatch: userSubcribedBatch,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserSubcribedCourse(
                userSubcribedBatch: userSubcribedBatch,
                userData: userData,
              ),
            ),
          ),
        ),
      );
    },
  );
}

class UserSubcribedBatchListTile extends StatelessWidget {
  const UserSubcribedBatchListTile(
      {Key? key, required this.userSubcribedBatch, required this.onTap});

  final UserSubcribedBatch userSubcribedBatch;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.verified_rounded,
                color: Colors.green,
                size: 30.0,
              ),
              Container(
                margin: EdgeInsets.all(15.0),
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.green,
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xffD4145A),
                      Color(0xffFBB03B),
                    ],
                  ),
                  shape: BoxShape.rectangle,
                ),
                child: Row(
                  children: [
                    gradientText(
                      text: userSubcribedBatch.userBatch,
                      color2: Colors.white,
                      color1: Colors.white,
                      fontFamily: 'Roboto',
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                    SizedBox(width: 5.0),
                    CustomIconButton(
                      elevation: 2.0,
                      color: Colors.white,
                      onTap: onTap,
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UserSubcribedCourse extends StatelessWidget {
  const UserSubcribedCourse(
      {required this.userSubcribedBatch, required this.userData});
  final UserSubcribedBatch userSubcribedBatch;
  final UserData userData;
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    void _launchURL({required String url}) async => await canLaunch(url)
        ? await launch(url)
        : throw 'Could not launch $url';
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xff764ba2),
                Color(0xff667eea),
              ],
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("Subscription Detail"),
        actions: [
          FlatButton(
              onPressed: () => _launchURL(
                    url: "tel:+917000303658",
                  ),
              child: Row(
                children: [
                  Icon(
                    Icons.call,
                    color: Colors.white,
                    size: 18.0,
                  ),
                  SizedBox(width: 5),
                  Text(
                    "Help",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Poppins",
                        fontSize: 14.0),
                  ),
                ],
              ))
        ],
      ),
      body: subscribedCourseListView(context, userSubcribedBatch, userData),
    );
  }
}

Widget subscribedCourseListView(BuildContext context,
    UserSubcribedBatch userSubcribedBatch, UserData userData) {
  final database = Provider.of<Database>(context, listen: false);

  return StreamBuilder<Batch>(
    stream: database.batchStream(batchId: userSubcribedBatch.id),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final sss = snapshot.data;
        return StreamBuilder<List<UserSubcribedClassData>>(
          stream: database.UsersSubcribedClassStream(
              batch: sss!, userData: userData),
          builder: (context, snapshot) {
            return StreamBuilder<List<UserSubcribedClassData>>(
              stream: database.UsersSubcribedClassStream(
                  batch: sss, userData: userData),
              builder: (context, snapshot) {
                return ListItemsBuilder<UserSubcribedClassData>(
                  snapshot: snapshot,
                  itemBuilder: (context, userSubcribedClassData) =>
                      UserSubcribedCourseListTile(
                    userSubcribedBatch: userSubcribedBatch,
                    onTap: () {},
                    userSubcribedClassData: userSubcribedClassData,
                  ),
                );
              },
            );
          },
        );
      }
      return Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}

class UserSubcribedCourseListTile extends StatelessWidget {
  const UserSubcribedCourseListTile(
      {Key? key,
      required this.userSubcribedBatch,
      required this.onTap,
      required this.userSubcribedClassData});

  final UserSubcribedBatch userSubcribedBatch;
  final UserSubcribedClassData userSubcribedClassData;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<Course>(
      stream: database.courseStream(
        jobId: userSubcribedBatch.id,
        batchId: userSubcribedBatch.id,
        courseId: userSubcribedClassData.id,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final course = snapshot.data;
          return Container(
            margin: EdgeInsets.all(15.0),
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.green,
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xffD4145A),
                  Color(0xffFBB03B),
                ],
              ),
              shape: BoxShape.rectangle,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.0),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 100.0,
                        padding: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.white,
                              Colors.white,
                            ],
                          ),
                        ),
                        child: Center(
                          child: CachedNetworkImage(
                            imageUrl: course!.boxIconLink,
                            imageBuilder: (context, imageProvider) =>
                                Image(image: imageProvider),
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image(
                                height: 100.0,
                                image: AssetImage(
                                    "assets/images/image_placeholder.png"),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20.0),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            gradientText(
                              text: course.courseName,
                              color2: Colors.white,
                              color1: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                            ),
                            Container(
                              alignment: Alignment.bottomLeft,
                              child: SizedBox(
                                width: 200.0,
                                child: Divider(
                                  thickness: 1.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            gradientText(
                              text: 'Purchase Date : ' +
                                  userSubcribedClassData.date.substring(0, 10),
                              color2: Colors.white,
                              color1: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                            SizedBox(height: 5),
                            gradientText(
                              text: "Price :   ₹ " +
                                  course.courseSellingPrice.toString(),
                              color2: Colors.white,
                              color1: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  alignment: Alignment.bottomRight,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.green,
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.white,
                          Colors.white,
                        ],
                      ),
                      shape: BoxShape.rectangle,
                    ),
                    height: 50.0,
                    width: 200.0,
                    child: Center(
                      child: gradientText(
                        text: "Download Certificate",
                        color2: Colors.red,
                        color1: Colors.redAccent,
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
