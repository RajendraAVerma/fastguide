import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/login/data_models/user_model.dart';
import 'package:fastguide/login/data_models/user_subcribe_batch_model.dart';
import 'package:fastguide/login/data_models/user_subcribed_class_model.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

isSubcribeCourse({
  required BuildContext context,
  required Batch batch,
  required Course course,
  required Widget isSubSuscribedWidget,
  required Widget isNotSubSuscribedWidget,
}) {
  final database = Provider.of<Database>(context, listen: false);
  return StreamBuilder<UserData?>(
    stream: database.UserStream(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.active) {
        final userData = snapshot.data;
        return StreamBuilder<List<UserSubcribedBatch>>(
          stream: database.UsersSubcribedBatchStream(userData: userData!),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return StreamBuilder<List<UserSubcribedClassData>>(
                stream: database.UsersSubcribedClassStream(
                    batch: batch, userData: userData),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final userSubscribeCourse = snapshot.data;
                    final _isSubscribeTheCourse = userSubscribeCourse!
                        .map((item) => item.userSubcribedCourse)
                        .contains(course.id);

                    if (_isSubscribeTheCourse) {
                      return isSubSuscribedWidget;
                    } else {
                      return isNotSubSuscribedWidget;
                    }
                  } else if (snapshot.hasError) {
                    Container(
                        child: Center(child: Text('Something Went Wrong !!')));
                  }
                  ;
                  return Center(
                      child: SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(color: Colors.white),
                  ));
                },
              );
            } else if (snapshot.hasError) {
              Container(child: Center(child: Text('Something Went Wrong !!')));
            }
            ;
            return Center(
                child: SizedBox(
              height: 20.0,
              width: 20.0,
              child: CircularProgressIndicator(color: Colors.white),
            ));
          },
        );
      }

      return Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}
