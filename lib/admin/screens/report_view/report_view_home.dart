import 'package:fastguide/admin/screens/report_view/user_detail/user_list_page.dart';
import 'package:flutter/material.dart';

class ReportViewHome extends StatelessWidget {
  const ReportViewHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RaisedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserListPage(),
            ),
          ),
          child: Text("User Details"),
        ),
        RaisedButton(
          onPressed: () {},
          child: Text("Payment Details"),
        ),
      ],
    );
  }
}
