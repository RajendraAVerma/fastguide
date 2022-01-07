import 'package:fastguide/app/drawer/payment_history/payment_history_listview.dart';
import 'package:fastguide/login/data_models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentHistory extends StatelessWidget {
  const PaymentHistory({Key? key, required this.userData}) : super(key: key);
  final UserData userData;

  @override
  Widget build(BuildContext context) {
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
        title: Text("Payment History"),
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
      body: Container(
        child: Column(
          children: [
            ListTile(
              title: Text(
                "Item",
                style: TextStyle(
                  color: Colors.blue.shade800,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                ),
              ),
              subtitle: Text(
                "Date",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w300,
                  fontSize: 12.0,
                ),
              ),
              trailing: Text(
                "Amount",
                style: TextStyle(
                  color: Colors.green,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w700,
                  fontSize: 18.0,
                ),
              ),
            ),
            Expanded(
              child: paymentHistoryListView(
                context,
                userData,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
