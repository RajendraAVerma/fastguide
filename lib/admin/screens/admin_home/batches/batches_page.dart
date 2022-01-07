import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastguide/admin/screens/admin_home/batches/batches_list_tile.dart';
import 'package:fastguide/admin/screens/admin_home/batches/edit_batches_page.dart';
import 'package:fastguide/admin/screens/admin_home/batches/list_items_builder.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/show_exception_alert_dialog.dart';
import 'package:fastguide/admin/screens/admin_home/cource/courses_page.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BatchesPage extends StatelessWidget {
  Future<void> _delete(BuildContext context, Batch batch) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteBatch(batch);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Batches'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () => EditBatchPage.show(
              context,
              database: Provider.of<Database>(context, listen: false),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: _buildContents(context),
        ),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Batch>>(
      stream: database.batchesStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<Batch>(
          snapshot: snapshot,
          itemBuilder: (context, job) => BatchListTile(
            batch: job,
            onTap: () => CoursePage.show(context, job),
          ),
        );
      },
    );
  }
}
