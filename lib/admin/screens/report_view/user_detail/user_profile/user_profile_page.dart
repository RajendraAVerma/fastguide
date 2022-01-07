import 'package:fastguide/admin/screens/report_view/user_detail/direct_addmission/batch_select_page.dart';
import 'package:fastguide/admin/screens/report_view/user_detail/user_class/user_class.dart';
import 'package:fastguide/admin/screens/report_view/user_detail/user_device/user_device_page.dart';
import 'package:fastguide/admin/screens/report_view/user_detail/user_subscribe_courses/user_subscribe_page.dart';

import 'package:fastguide/app/drawer/payment_history/payment_history_listview.dart';
import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
import 'package:fastguide/login/data_models/user_class_model.dart';
import 'package:fastguide/login/data_models/user_model.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class UserProfilePageAdmin extends StatelessWidget {
  const UserProfilePageAdmin({required this.database, required this.userData});
  final Database database;
  final UserData userData;

  static Future<void> show(BuildContext context, UserData userData) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) =>
            UserProfilePageAdmin(database: database, userData: userData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(userData.userName),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BatchesPageForDirectAddmission(
                        userData: userData,
                      ))),
              icon: Icon(
                Icons.shopping_bag,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildContent(userData, context),
          ],
        ),
      ),
    );
  }
}

_buildContent(UserData userData, BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 30.0),
    color: Colors.white,
    alignment: Alignment.center,
    child: Container(
      child: Column(
        children: [
          SizedBox(height: 40.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 50.0,
                child: gradientText(
                  text: userData.userName,
                  color1: Colors.blue.shade600,
                  color2: Colors.indigo.shade300,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w800,
                  fontSize: 25,
                ),
              ),
              Container(
                child: IconButton(
                  color: Colors.black,
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: userData.userName));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('${userData.userName} Copied !')));
                  },
                  icon: Icon(
                    Icons.copy_sharp,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: gradientText(
                  text: "Class Selected",
                  color1: Colors.black87,
                  color2: Colors.indigo,
                  fontFamily: "Poppins",
                  fontSize: 14,
                ),
              ),
              SizedBox(width: 20.0),
              Expanded(
                child: SizedBox(
                  child: userClassStreamBuilder(context, userData),
                  height: 30.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Row(
            children: [
              Icon(Icons.call),
              SizedBox(width: 20.0),
              Expanded(
                child: gradientText(
                  text: userData.mobileNo,
                  color1: Colors.black87,
                  color2: Colors.indigo,
                  fontFamily: "Poppins",
                  fontSize: 14,
                ),
              ),
              Container(
                child: IconButton(
                  color: Colors.black,
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: userData.mobileNo));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('${userData.mobileNo} Copied !')));
                  },
                  icon: Icon(
                    Icons.copy_sharp,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Row(
            children: [
              Icon(Icons.email),
              SizedBox(width: 20.0),
              Expanded(
                child: gradientText(
                  text: userData.email,
                  color1: Colors.black87,
                  color2: Colors.indigo,
                  fontFamily: "Poppins",
                  fontSize: 14,
                ),
              ),
              Container(
                child: IconButton(
                  color: Colors.black,
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: userData.email));
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${userData.email} Copied !')));
                  },
                  icon: Icon(
                    Icons.copy_sharp,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Row(
            children: [
              Icon(Icons.home),
              SizedBox(width: 20.0),
              Expanded(
                child: gradientText(
                  text: userData.address,
                  color1: Colors.black87,
                  color2: Colors.indigo,
                  fontFamily: "Poppins",
                  fontSize: 14,
                ),
              ),
              Container(
                child: IconButton(
                  color: Colors.black,
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: userData.address));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('${userData.address} Copied !')));
                  },
                  icon: Icon(
                    Icons.copy_sharp,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Row(
            children: [
              Expanded(
                child: gradientText(
                  text: "Firebase User Id",
                  color1: Colors.black87,
                  color2: Colors.black,
                  fontFamily: "Poppins",
                  fontSize: 14,
                ),
              ),
              SizedBox(width: 20.0),
              Expanded(
                child: gradientText(
                  text: userData.id,
                  color1: Colors.black87,
                  color2: Colors.indigo,
                  fontFamily: "Poppins",
                  fontSize: 14,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Row(
            children: [
              Expanded(
                child: gradientText(
                  text: "<<< Last Time Profile Update or Account Create>>>",
                  color1: Colors.black87,
                  color2: Colors.black,
                  fontFamily: "Poppins",
                  fontSize: 14,
                ),
              ),
              SizedBox(width: 20.0),
              Expanded(
                child: gradientText(
                  text: userData.registerDate,
                  color1: Colors.black87,
                  color2: Colors.indigo,
                  fontFamily: "Poppins",
                  fontSize: 14,
                ),
              ),
            ],
          ),
          UserdevicePage(userData: userData),
          gradientText(
            text: "<<< Subscribed Batches >>>",
            color1: Colors.black87,
            color2: Colors.black,
            fontFamily: "Poppins",
            fontSize: 14,
          ),
          SubscriptionDetailPage(userData: userData),
          gradientText(
            text: "<<< Payment History >>>",
            color1: Colors.black87,
            color2: Colors.black,
            fontFamily: "Poppins",
            fontSize: 14,
          ),
          SizedBox(height: 20.0),
          paymentHistoryListView(
            context,
            userData,
          ),
        ],
      ),
    ),
  );
}
