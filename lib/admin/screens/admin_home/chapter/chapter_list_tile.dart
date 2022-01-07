import 'dart:ui';

import 'package:fastguide/admin/screens/admin_home/models/chapter.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/app/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';

class CourceListTile extends StatelessWidget {
  const CourceListTile(
      {Key? key, required this.chapter, this.onTap, required this.course})
      : super(key: key);
  final Chapter? chapter;
  final Course course;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return listTile();
  }

  Widget listTile() {
    String themeColor1FromFirebase = course.themeColor1;
    int themeColor1Int = int.parse(themeColor1FromFirebase);
    String themeColor2FromFirebase = course.themeColor2;
    int themeColor2Int = int.parse(themeColor2FromFirebase);
    return Container(
      margin: EdgeInsets.only(bottom: 15.0),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
              Color(themeColor1Int).withOpacity(0.3), BlendMode.dstIn),
          alignment: Alignment.bottomRight,
          image: AssetImage("assets/images/bg.png"),
        ),
        borderRadius: BorderRadius.circular(10.0),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(themeColor1Int),
            Color(themeColor2Int),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(themeColor2Int),
            offset: Offset(0, 0),
            blurRadius: 3.0,
          ),
        ],
      ),
      child: ListTile(
        leading: CustomIconButton2(
          elevation: 2.0,
          color: Colors.white,
          onTap: onTap!,
          child: Text(
            chapter!.chapterNo.toString(),
            style: TextStyle(
              color: Color(themeColor1Int),
              fontFamily: "Roboto",
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        title: Text(
          chapter!.chapterName,
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Roboto",
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: Text(
          chapter!.totalTopic.toString() +
              " Topic  | " +
              chapter!.totalLecture.toString() +
              " Videos",
          style: TextStyle(color: Colors.white, fontSize: 10.0),
        ),
        trailing: CustomIconButton(
          elevation: 2.0,
          color: Colors.white,
          onTap: onTap!,
          child: Icon(
            Icons.arrow_forward_rounded,
            color: Color(themeColor1Int),
          ),
        ),
        onTap: onTap,
      ),
    );
  }



}
