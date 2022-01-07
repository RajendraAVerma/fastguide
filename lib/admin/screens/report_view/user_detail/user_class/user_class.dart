import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/login/data_models/user_class_model.dart';
import 'package:fastguide/login/data_models/user_model.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

userClassStreamBuilder(BuildContext context, UserData userData) {
  final database = Provider.of<Database>(context, listen: false);

  return StreamBuilder<List<UserClassData>>(
    stream: database.UsersClassStream(userData: userData),
    builder: (context, snapshot) {
      final userClassData = snapshot.data;
      final userClass = userClassData?.first;
      if (snapshot.hasData) {
        // if (userClassData!.isNotEmpty) {

        // }
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
                    return Text(batchName!);
                  } else if (snapshot.hasError) {
                    Container(child: Center(child: Text('error')));
                  }
                  ;
                  return Text("Not Select Class");
                },
              );
            } else if (snapshot.hasError) {
              Container(child: Center(child: Text('Something Went Wrong !!')));
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
