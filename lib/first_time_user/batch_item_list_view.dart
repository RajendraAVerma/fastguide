// import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
// import 'package:fastguide/first_time_user/batch_list_item_builder.dart';
// import 'package:fastguide/first_time_user/first_time_user_batch_select_gridview.dart';
// import 'package:fastguide/services/database.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// Widget batchesGridViewForClassSelect(BuildContext context) {
//   final database = Provider.of<Database>(context, listen: false);
//   return StreamBuilder<List<Batch>>(
//     stream: database.batchesStream(),
//     builder: (context, snapshot) {
//       return ListItemsBuilder<Batch>(
//         snapshot: snapshot,
//         itemBuilder: (context, batch) => BatchListTileForFirstTimeUser(
//           batch: batch,
//         ),
//       );
//     },
//   );
// }
