import 'package:fastguide/login/data_models/user_model.dart';
import 'package:fastguide/login/data_models/user_subcribe_batch_model.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget verifiedStudent(BuildContext context, UserData userData) {
  final database = Provider.of<Database>(context, listen: false);
  return StreamBuilder<List<UserSubcribedBatch>>(
    stream: database.UsersSubcribedBatchStream(userData: userData),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final lenght = snapshot.data!.length;
        if (lenght > 0) {
          return Icon(
            Icons.verified,
            color: Colors.green,
          );
        }
        return SizedBox();
      } else if (snapshot.hasError) {
        return SizedBox();
      }
      return SizedBox();
    },
  );
}
