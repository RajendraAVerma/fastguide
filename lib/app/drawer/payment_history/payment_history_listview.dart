import 'package:fastguide/app/drawer/payment_history/payment_history_listtiem_builder.dart';
import 'package:fastguide/login/data_models/payment_history.dart';
import 'package:fastguide/login/data_models/user_model.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget paymentHistoryListView(BuildContext context, UserData userData) {
  final database = Provider.of<Database>(context, listen: false);

  return StreamBuilder<List<PaymentHistory>>(
    stream: database.paymentsHistoryStream(userData: userData),
    builder: (context, snapshot) {
      return ListItemsBuilder<PaymentHistory>(
        snapshot: snapshot,
        itemBuilder: (context, paymentHistory) => PaymentHistoryListTile(
            paymentHistory: paymentHistory, onTap: () {}),
      );
    },
  );
}

class PaymentHistoryListTile extends StatelessWidget {
  const PaymentHistoryListTile(
      {Key? key, required this.paymentHistory, this.onTap})
      : super(key: key);
  final PaymentHistory? paymentHistory;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        paymentHistory!.item,
        style: TextStyle(
          color: Colors.blue.shade800,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w500,
          fontSize: 16.0,
        ),
      ),
      subtitle: Text(
        paymentHistory!.date,
        style: TextStyle(
          color: Colors.black,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w300,
          fontSize: 12.0,
        ),
      ),
      trailing: Text(
        "₹ " + paymentHistory!.price,
        style: TextStyle(
          color: Colors.green,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w700,
          fontSize: 18.0,
        ),
      ),
    );
  }
}
