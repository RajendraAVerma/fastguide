import 'package:fastguide/admin/screens/admin_home/batches/batches_list_tile.dart';
import 'package:fastguide/admin/screens/admin_home/batches/batches_listtile_for_select.dart';
import 'package:fastguide/admin/screens/admin_home/batches/list_items_builder.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/app/home/screens/batches_pages/course_page_home.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget batchesGridView(BuildContext context) {
  final database = Provider.of<Database>(context, listen: false);
  return StreamBuilder<List<Batch>>(
    stream: database.batchesStream(),
    builder: (context, snapshot) {
      return ListItemsBuilder<Batch>(
        snapshot: snapshot,
        itemBuilder: (context, batch) => BatchListTile(
          batch: batch,
          onTap: () => CoursePage.show(context, batch),
        ),
      );
    },
  );
}

Widget batchesGridViewForSelect(BuildContext context) {
  final database = Provider.of<Database>(context, listen: false);
  return StreamBuilder<List<Batch>>(
    stream: database.batchesStream(),
    builder: (context, snapshot) {
      return ListItemsBuilder<Batch>(
        snapshot: snapshot,
        itemBuilder: (context, batch) => BatchListTileForSelect(
          batch: batch,
          onTap: () => CoursePage.show(context, batch),
        ),
      );
    },
  );
}
