import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/chapter.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/admin/screens/admin_home/models/section.dart';
import 'package:fastguide/admin/screens/admin_home/models/topic.dart';
import 'package:fastguide/admin/screens/admin_home/topic/list_items_builder.dart';
import 'package:fastguide/admin/screens/admin_home/topic/topic_list_tile.dart';
import 'package:fastguide/app/home/screens/batches_pages/topic_lecture_screen_page.dart';
import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
import 'package:fastguide/login/data_models/user_model.dart';
import 'package:fastguide/login/data_models/user_subcribe_batch_model.dart';
import 'package:fastguide/login/data_models/user_subcribed_class_model.dart';
import 'package:fastguide/paytm%20services/cart_page.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget topicListView(
  BuildContext context,
  Batch batch,
  Course course,
  Section section,
  Chapter chapter,
) {
  final database = Provider.of<Database>(context, listen: false);
  Future<void> _subscriptionAlert(BuildContext context) async {
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) => new AlertDialog(
        title: Column(
          children: [
            gradientText(
              text: "Subscribe Now",
              color1: Colors.green,
              color2: Colors.green.shade800,
              fontFamily: "Poppins",
              fontSize: 20.0,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            gradientText(
              text:
                  "You have not subscribed to this topic yet. Subscribe now to continue studying.",
              color1: Colors.black,
              color2: Colors.black87,
              fontFamily: "mukta",
              fontSize: 15,
            ),
            SizedBox(height: 8.0),
            gradientText(
              text:
                  "आपने अभी तक इस विषय की सदस्यता नहीं ली है। पढ़ाई जारी रखने के लिए अभी सदस्यता लें।",
              color1: Colors.black,
              color2: Colors.black87,
              fontFamily: "mukta",
              fontSize: 15,
            ),
          ],
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true)
                        .pop(); // dismisses only the dialog and returns nothing
                  },
                  color: Colors.redAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Poppins",
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: RaisedButton(
                    onPressed: () async {
                      CartPage.show(context, batch);
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    color: Colors.green,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Text(
                        'Subscibe Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Poppins",
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  return StreamBuilder<List<Topic>>(
    stream: database.topicsStream(
      batchId: batch.id,
      courseId: course.id,
      sectionId: section.id,
      chapterId: chapter.id,
    ),
    builder: (context, snapshot) {
      final topicSnapshot = snapshot;
      if (snapshot.hasData) {
        return StreamBuilder<UserData?>(
          stream: database.UserStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              final userData = snapshot.data;
              return StreamBuilder<List<UserSubcribedBatch>>(
                stream: database.UsersSubcribedBatchStream(userData: userData!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final userSubcribed = snapshot.data;

                    final _isSubscribeTheBatch = userSubcribed!
                        .map((item) => item.id)
                        .contains(batch.id);
                    print(_isSubscribeTheBatch);

                    return StreamBuilder<List<UserSubcribedClassData>>(
                      stream: database.UsersSubcribedClassStream(
                        batch: batch,
                        userData: userData,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final userSubscribeCourse = snapshot.data;
                          final _isSubscribeTheCourse = userSubscribeCourse!
                              .map((item) => item.userSubcribedCourse)
                              .contains(course.id);
                          print(_isSubscribeTheCourse);

                          if (_isSubscribeTheCourse) {
                            return ListItemsBuilder<Topic>(
                              snapshot: topicSnapshot,
                              itemBuilder: (context, topic) {
                                return TopicListTile(
                                  isLock: false,
                                  course: course,
                                  topic: topic,
                                  onTap: () => LectureScreenPage.show(
                                    context,
                                    batch,
                                    course,
                                    section,
                                    chapter,
                                    topic,
                                  ),
                                );
                              },
                            );
                          } else {
                            return ListItemsBuilder<Topic>(
                              snapshot: topicSnapshot,
                              itemBuilder: (context, topic) {
                                final _isLock = topic.lock;
                                return TopicListTile(
                                  course: course,
                                  topic: topic,
                                  onTap: () => _isLock != 1
                                      ? _subscriptionAlert(context)
                                      // CartPage.show(context, batch)
                                      : LectureScreenPage.show(
                                          context,
                                          batch,
                                          course,
                                          section,
                                          chapter,
                                          topic,
                                        ),
                                  isLock: _isLock != 1,
                                );
                              },
                            );
                          }
                        } else if (snapshot.hasError) {
                          Container(
                              child: Center(
                                  child: Text('Something Went Wrong !!')));
                        }
                        ;
                        return Center(child: CircularProgressIndicator());
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
            }

            return Center(
              child: CircularProgressIndicator(),
            );
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
