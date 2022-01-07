import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastguide/admin/screens/admin_home/batches/edit_batches_page.dart';
import 'package:fastguide/admin/screens/admin_home/batches/list_items_builder.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/show_exception_alert_dialog.dart';
import 'package:fastguide/app/widgets/slidder_depart/edit_slidder_page.dart';
import 'package:fastguide/app/widgets/slidder_depart/slidder_image_model.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SlidderPage extends StatelessWidget {
  Future<void> _delete(BuildContext context, SlidderModel slidderModel) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteSlidder();
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
        title: Text('Image Link'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () => EditSlidderPage.show(
              context,
              database: Provider.of<Database>(context, listen: false),
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: _buildContents(context),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<SlidderModel>>(
      stream: database.slidders(),
      builder: (context, snapshot) {
        return ListItemsBuilder<SlidderModel>(
          snapshot: snapshot,
          itemBuilder: (context, slidderModel) => Dismissible(
            key: Key('job-${slidderModel.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, slidderModel),
            child: _buildListTile(
              slidderModel: slidderModel,
              onTap: () {},
            ),
          ),
        );
      },
    );
  }

  _buildListTile(
      {required SlidderModel slidderModel, required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      title: Text(slidderModel.imageLink),
    );
  }
}
