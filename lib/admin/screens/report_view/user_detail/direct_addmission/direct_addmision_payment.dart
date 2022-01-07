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

class PaymentScreenDirectAddmission extends StatefulWidget {
  PaymentScreenDirectAddmission({
    required this.amount,
    required this.batch,
    required this.database,
    required this.cartModel,
    required this.mobilNo,
    required this.userData,
  });
  final String amount;
  final String mobilNo;
  final Batch batch;
  final Database database;
  final CartModel cartModel;
  final UserData userData;
  static Future<void> show(
    BuildContext context,
    Batch batch,
    Database database,
    CartModel cartModel,
    String amount,
    String mobilNo,
    UserData userData,
  ) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => ChangeNotifierProvider(
          create: (context) => CartModel(),
          child: PaymentScreenDirectAddmission(
            batch: batch,
            amount: amount,
            cartModel: cartModel,
            database: database,
            mobilNo: mobilNo,
            userData: userData,
          ),
        ),
      ),
    );
  }

  @override
  _PaymentScreenDirectAddmissionState createState() =>
      _PaymentScreenDirectAddmissionState();
}

class _PaymentScreenDirectAddmissionState
    extends State<PaymentScreenDirectAddmission> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(),
          body: Center(
            child: RaisedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PaymentSuccessfulScreen(
                    batch: widget.batch,
                    cartModel: widget.cartModel,
                    database: widget.database,
                    payment: widget.amount,
                    userData: widget.userData,
                  ),
                ),
              ),
              child: Text("Confirm"),
            ),
          )),
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
                "SuccessFully Subscribed! - Direct",
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
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
