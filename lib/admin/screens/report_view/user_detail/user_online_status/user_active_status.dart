import 'package:fastguide/login/data_models/user_model.dart';
import 'package:fastguide/login/data_models/user_online_model.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserActiveStatusPage extends StatelessWidget {
  const UserActiveStatusPage({Key? key, required this.userData})
      : super(key: key);
  final UserData userData;

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<UserStatusData>(
      stream: database.userStatus(userData: userData),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final userStatusData = snapshot.data;
          return _buildContent(userStatusData!);
        } else if (snapshot.hasError) {
          return Center(
            child: Icon(
              Icons.circle,
              color: Colors.black,
              size: 10.0,
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Container _buildContent(UserStatusData userStatusData) {
    return Container(
      child: Row(
        children: [
          userStatusData.status.contains("online")
              ? Icon(
                  Icons.circle,
                  color: Colors.green,
                  size: 10.0,
                )
              : Icon(
                  Icons.circle,
                  color: Colors.red,
                  size: 10.0,
                ),
          SizedBox(width: 10.0),
          // userStatusData.status.contains("online")
          //     ? Text(
          //         "Online",
          //         style: TextStyle(color: Colors.green),
          //       )
          //     : Text(
          //         "Offline",
          //         style: TextStyle(color: Colors.red),
          //       ),
        ],
      ),
    );
  }
}
