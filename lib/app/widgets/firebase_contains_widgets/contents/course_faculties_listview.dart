import 'package:fastguide/admin/screens/admin_home/cource/contents/course_faculties/course_faculties_list_tile.dart';
import 'package:fastguide/admin/screens/admin_home/cource/contents/course_faculties/list_items_builder.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/contents/course_facalties.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget courseFacultiesListView(
  BuildContext context,
  Batch batch,
  Course course,
) {
  final database = Provider.of<Database>(context, listen: false);
  return Container(
    height: 270.0,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        gradientText(
          text: "Teachers : ",
          color1: Colors.red,
          color2: Colors.redAccent,
          fontFamily: "Mukta",
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        Expanded(
          flex: 1,
          child: StreamBuilder<List<CourseFaculties>>(
            stream: database.courseFacultiesStream(
                batchId: batch.id, courseId: course.id),
            builder: (context, snapshot) {
              return ListItemsBuilder<CourseFaculties>(
                snapshot: snapshot,
                itemBuilder: (context, courseFaculties) =>
                    CourseFacultiesListTile(
                  onTap: () {},
                  batch: batch,
                  course: course,
                  courseFaculties: courseFaculties,
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}
