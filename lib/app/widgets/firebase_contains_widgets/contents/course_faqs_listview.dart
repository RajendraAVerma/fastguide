import 'package:fastguide/admin/screens/admin_home/cource/contents/course_faqs/course_faqs_list_tile.dart';
import 'package:fastguide/admin/screens/admin_home/cource/contents/course_faqs/list_items_builder.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/contents/course_faqs.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget courseFAQsListView(
  BuildContext context,
  Batch batch,
  Course course,
) {
  final database = Provider.of<Database>(context, listen: false);
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      gradientText(
        text: "FAQ&As ( सामान्यतः पूछे जाने वाले प्रश्न )",
        color1: Colors.red,
        color2: Colors.redAccent,
        fontFamily: "Mukta",
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      StreamBuilder<List<CourseFAQs>>(
        stream:
            database.courseFAQsStream(batchId: batch.id, courseId: course.id),
        builder: (context, snapshot) {
          return ListItemsBuilder<CourseFAQs>(
            snapshot: snapshot,
            itemBuilder: (context, courseFAQs) => CourseFAQsListTileAdmin(
              onTap: () {},
              batch: batch,
              course: course,
              courseFAQs: courseFAQs,
            ),
          );
        },
      ),
    ],
  );
}
