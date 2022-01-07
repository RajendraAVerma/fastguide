import 'package:fastguide/admin/screens/admin_home/batches/batches_page.dart';
import 'package:fastguide/landing_page.dart';
import 'package:flutter/material.dart';

AppBar AdminAppBar(BuildContext context) {
  return AppBar(
    elevation: 0.0,
    leading: IconButton(
      onPressed: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LandingPage())),
      icon: Icon(
        Icons.home,
        color: Colors.white,
      ),
    ),
    title: Text(
      "Admin DashBoard",
      style: TextStyle(
        color: Colors.white,
        fontFamily: "Poppins",
      ),
    ),
    flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.red,
            Colors.redAccent,
          ],
        ),
      ),
    ),
    backgroundColor: Colors.transparent,
    actions: [
      FlatButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => BatchesPage())),
        child: Text(
          "Batches",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      )
    ],
  );
}
