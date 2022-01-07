import 'package:fastguide/login/data_models/payment_history.dart';
import 'package:fastguide/login/data_models/user_model.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget totalPaymentMeter(BuildContext context) {
  final database = Provider.of<Database>(context, listen: false);

  return StreamBuilder<List<UserData>>(
    stream: database.UsersStream(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final aaa = snapshot.data!;
        final aaaa = snapshot.data!.first;
        // List<Widget> userList = aaa.map((user) => Text(user.userName)).toList();
        _totalPrice(UserData userData) {
          final sss = StreamBuilder<List<PaymentHistory>>(
            stream: database.paymentsHistoryStream(userData: userData),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final String price = snapshot.data!.first.price;
                return Text(price);
              } else if (snapshot.hasError) {
                return Text("Error");
              }
              return Text("0");
            },
          );
          return sss;
        }
        // _totalMRPOfCourse() {
        //   double sum = 0;
        //   for (var i = 0; i < userList.length; i++) {
        //     sum += userList[i];
        //   }
        //   return sum;
        // }

        print("sdf");
        return ListView(
            //children: userList,
            );
      } else if (snapshot.hasError) {
        return Text("Error");
      }
      return CircularProgressIndicator();
    },
  );
}
