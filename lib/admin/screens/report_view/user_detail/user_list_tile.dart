import 'package:fastguide/admin/screens/report_view/user_detail/user_class/user_class.dart';
import 'package:fastguide/admin/screens/report_view/user_detail/user_online_status/user_active_status.dart';
import 'package:fastguide/admin/screens/report_view/user_detail/verified_student.dart';
import 'package:fastguide/login/data_models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class UserListTile extends StatelessWidget {
  const UserListTile({Key? key, required this.userData, this.onTap})
      : super(key: key);
  final UserData? userData;
  final VoidCallback? onTap;
  void _launchURL({required String url}) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  @override
  Widget build(BuildContext context) {
    return _listTile(context);
  }

  ListTile _listTile(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          verifiedStudent(context, userData!),
          SizedBox(width: 5.0),
          Expanded(
            child: Text(
              userData!.userName,
              style: TextStyle(
                fontFamily: "Poppins",
              ),
            ),
          ),
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          UserActiveStatusPage(userData: userData!),
          SizedBox(width: 5.0),
          Expanded(
            child: SizedBox(
              child: userClassStreamBuilder(context, userData!),
              height: 30.0,
            ),
          ),
          Container(
            child: IconButton(
              color: Colors.black,
              onPressed: () {
                Clipboard.setData(ClipboardData(text: userData!.userName));
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${userData!.userName} Copied !')));
              },
              icon: Icon(
                Icons.copy_sharp,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            child: IconButton(
              color: Colors.black,
              onPressed: () {
                Clipboard.setData(ClipboardData(text: userData!.mobileNo));
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${userData!.mobileNo} Copied !')));
              },
              icon: Icon(
                Icons.copy_sharp,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      trailing: GestureDetector(
          onTap: () => _launchURL(
                url: "tel:${userData!.mobileNo}",
              ),
          child: Text(userData!.mobileNo)),
      onTap: onTap,
    );
  }
}
