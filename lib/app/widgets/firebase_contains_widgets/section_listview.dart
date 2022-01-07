
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/admin/screens/admin_home/models/section.dart';
import 'package:fastguide/admin/screens/admin_home/section/list_items_builder.dart';
import 'package:fastguide/admin/screens/admin_home/section/section_list_tile.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget SectionListView(
  BuildContext context,
  Batch batch,
  Course course,
) {
  final database = Provider.of<Database>(context, listen: false);
  return StreamBuilder<List<Section>>(
    stream: database.sectionsStream(batchId: batch.id, courseId: course.id),
    builder: (context, snapshot) {
      return ListItemsBuilder<Section>(
        snapshot: snapshot,
        itemBuilder: (context, section) => SectionListTile(
          onTap: () {},
          section: section,
          batch: batch,
          course: course,
        ),
      );
    },
  );
}
