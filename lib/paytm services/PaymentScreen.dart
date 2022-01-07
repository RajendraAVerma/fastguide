import 'dart:convert';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/team/model/coderedeemuser.dart';
import 'package:fastguide/app/drawer/subscription/subscription_detail_page.dart';
import 'package:fastguide/login/data_models/payment_history.dart';
import 'package:fastguide/login/data_models/user_model.dart';
import 'package:fastguide/login/data_models/user_subcribe_batch_model.dart';
import 'package:fastguide/login/data_models/user_subcribed_class_model.dart';
import 'package:fastguide/paytm%20services/cart_model.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'Constants.dart';

class PaymentScreen extends StatefulWidget {
  PaymentScreen({
    required this.amount,
    required this.batch,
    required this.database,
    required this.cartModel,
    required this.mobilNo,
  });
  final String amount;
  final String mobilNo;
  final Batch batch;
  final Database database;
  final CartModel cartModel;
  static Future<void> show(
    BuildContext context,
    Batch batch,
    Database database,
    CartModel cartModel,
    String amount,
    String mobilNo,
  ) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => ChangeNotifierProvider(
          create: (context) => CartModel(),
          child: PaymentScreen(
            batch: batch,
            amount: amount,
            cartModel: cartModel,
            database: database,
            mobilNo: mobilNo,
          ),
        ),
      ),
    );
  }

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  WebViewController? _webController;
  bool _loadingPayment = true;
  String _responseStatus = STATUS_LOADING;

  String _loadHTML() {
    return "<html> <body onload='document.f.submit();'> <form id='f' name='f' method='post' action='$PAYMENT_URL'><input type='hidden' name='orderID' value='ORDER_${DateTime.now().millisecondsSinceEpoch}'/>" +
        "<input  type='hidden' name='custID' value='${ORDER_DATA["custID"]}' />" +
        "<input  type='hidden' name='amount' value='${widget.amount}' />" +
        "<input type='hidden' name='custEmail' value='${ORDER_DATA["custEmail"]}' />" +
        "<input type='hidden' name='custPhone' value='${widget.mobilNo}' />" +
        "</form> </body> </html>";
  }

  void getData() {
    _webController!.evaluateJavascript("document.body.innerText").then((data) {
      var decodedJSON = jsonDecode(data);
      Map<String, dynamic> responseJSON = jsonDecode(decodedJSON);
      final checksumResult = responseJSON["status"];
      final paytmResponse = responseJSON["data"];
      if (paytmResponse["STATUS"] == "TXN_SUCCESS") {
        if (checksumResult == 0) {
          _responseStatus = STATUS_SUCCESSFUL;
        } else {
          _responseStatus = STATUS_CHECKSUM_FAILED;
        }
      } else if (paytmResponse["STATUS"] == "TXN_FAILURE") {
        _responseStatus = STATUS_FAILED;
      }
      this.setState(() {});
    });
  }

  Widget getResponseScreen() {
    switch (_responseStatus) {
      case STATUS_SUCCESSFUL:
        return SuccessfullScreenForUserDetail(
          batch: widget.batch,
          cartModel: widget.cartModel,
          database: widget.database,
          payment: widget.amount,
        );
      case STATUS_CHECKSUM_FAILED:
        return CheckSumFailedScreen();
      case STATUS_FAILED:
        return PaymentFailedScreen();
    }
    return SuccessfullScreenForUserDetail(
      batch: widget.batch,
      cartModel: widget.cartModel,
      database: widget.database,
      payment: widget.amount,
    );
  }

  @override
  void dispose() {
    _webController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: WebView(
              debuggingEnabled: false,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) {
                _webController = controller;
                _webController!.loadUrl(
                    new Uri.dataFromString(_loadHTML(), mimeType: 'text/html')
                        .toString());
              },
              onPageFinished: (page) {
                if (page.contains("/process")) {
                  if (_loadingPayment) {
                    this.setState(() {
                      _loadingPayment = false;
                    });
                  }
                }
                if (page.contains("/paymentReceipt")) {
                  getData();
                }
              },
            ),
          ),
          (_loadingPayment)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Center(),
          (_responseStatus != STATUS_LOADING)
              ? Center(child: getResponseScreen())
              : Center()
        ],
      )),
    );
  }
}

class SuccessfullScreenForUserDetail extends StatelessWidget {
  final Batch batch;
  final Database database;
  final CartModel cartModel;
  final String payment;

  const SuccessfullScreenForUserDetail(
      {Key? key,
      required this.batch,
      required this.database,
      required this.cartModel,
      required this.payment})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData?>(
      stream: database.UserStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          return Scaffold(
            body: PaymentSuccessfulScreen(
              batch: batch,
              cartModel: cartModel,
              database: database,
              userData: user!,
              payment: payment,
            ),
          );
        }

        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class PaymentSuccessfulScreen extends StatefulWidget {
  const PaymentSuccessfulScreen(
      {Key? key,
      required this.batch,
      required this.database,
      required this.cartModel,
      required this.userData,
      required this.payment});
  final Batch batch;
  final Database database;
  final CartModel cartModel;
  final UserData userData;
  final String payment;

  @override
  _PaymentSuccessfulScreenState createState() =>
      _PaymentSuccessfulScreenState();
}

class _PaymentSuccessfulScreenState extends State<PaymentSuccessfulScreen> {
  _addToSubcribedClass() async {
    // database ------------
    final userSubcribedBatch = UserSubcribedBatch(
        id: '${widget.batch.id}',
        userBatch: "${widget.batch.batchName} - ${widget.batch.tag}");
    await widget.database.setUserSubcribedBatch(
      userSubcribedBatch: userSubcribedBatch,
      userData: widget.userData,
    );
    //---
    for (var courseId in widget.cartModel.courseIdsList) {
      // ---
      final userSubcribedClassData = UserSubcribedClassData(
        id: "id",
        userSubcribedBatch: '${widget.batch.id}',
        userSubcribedCourse: '${courseId}',
        date: currentDate(),
        payment: widget.payment,
      );
      await widget.database.setUserSubcribedClass(
        userSubcribedClassData: userSubcribedClassData,
        userData: widget.userData,
      );
      print('ADDED To SubCribed Class : $courseId');
      // ---
    }
    // ---------------------------
// --------- payment History ---------
    final paymentHistory = PaymentHistory(
      id: currentDate(),
      price: widget.payment,
      date: currentDate(),
      item: "${widget.batch.batchName} - ${widget.batch.tag}",
    );
    await widget.database.setPaymentHistory(
        paymentHistory: paymentHistory, userData: widget.userData);
// ----------------------------------
    // coupon Code ------------
    if (widget.cartModel.memberList.isNotEmpty) {
      final id = widget.userData.id;
      final codeRedeemUser = CodeRedeemUser(
        id: id,
        mobileNo: int.tryParse(widget.userData.mobileNo)!,
        userName: widget.userData.userName,
        date: currentDate(),
      );
      await widget.database.setCodeRedeemUser(
        member: widget.cartModel.member,
        codeRedeemUser: codeRedeemUser,
      );
    }
    // ---------------------------
  }

  @override
  void initState() {
    _addToSubcribedClass();
    super.initState();
    print("SuccessFully Subscribed");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Great!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "SuccessFully Subscribed!",
                style: TextStyle(fontSize: 30, color: Colors.green),
              ),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                  color: Colors.black,
                  child: Text(
                    "Close",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SubscriptionDetailPage()));
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentFailedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "OOPS!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Payment was not successful, Please try again Later!",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                  color: Colors.black,
                  child: Text(
                    "Close",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.popUntil(context, ModalRoute.withName("/"));
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class CheckSumFailedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Oh Snap!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Problem Verifying Payment, If you balance is deducted please contact our customer support and get your payment verified!",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                  color: Colors.black,
                  child: Text(
                    "Close",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.popUntil(context, ModalRoute.withName("/"));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
