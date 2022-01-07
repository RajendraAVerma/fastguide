import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/app/home/screens/batches_pages/common_widget/is_subcribed_course.dart';
import 'package:fastguide/app/widgets/webpage_iframe_page.dart';
import 'package:fastguide/paytm%20services/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

askQuestion_or_SubScribe_button({
  required BuildContext context,
  required Batch batch,
  required Course course,
}) {
  return isSubcribeCourse(
    context: context,
    batch: batch,
    course: course,
    isSubSuscribedWidget: GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => WebPageViewiFrame(
                url: 'https://fastguide.in/ask-questions/',
                color: Colors.blue.shade700,
                title: 'Ask Question',
              ))),
      child: Row(
        children: [
          Text(
            "Ask Question  ",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontFamily: 'Fredoka One',
            ),
          ),
          Icon(
            Icons.question_answer,
            color: Colors.white,
          )
        ],
      ),
    ),
    isNotSubSuscribedWidget: GestureDetector(
      onTap: () => CartPage.show(context, batch),
      child: Row(
        children: [
          Text(
            "Subscribe Now  ",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontFamily: 'Fredoka One',
            ),
          ),
          Icon(
            Icons.shopping_cart_outlined,
            color: Colors.white,
          )
        ],
      ),
    ),
  );
}
