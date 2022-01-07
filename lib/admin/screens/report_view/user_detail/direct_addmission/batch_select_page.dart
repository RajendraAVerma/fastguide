import 'package:fastguide/admin/screens/admin_home/batches/list_items_builder.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/report_view/user_detail/direct_addmission/direct_addmission_page.dart';
import 'package:fastguide/login/data_models/user_model.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BatchesPageForDirectAddmission extends StatelessWidget {
  const BatchesPageForDirectAddmission({Key? key, required this.userData})
      : super(key: key);
  final UserData userData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Batches'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: _buildContents(context),
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
          itemBuilder: (context, batch) => BatchListTile(
            batch: batch,
            onTap: () =>
                CartPageDirectAddmission.show(context, batch, userData),
          ),
        );
      },
    );
  }
}

class BatchListTile extends StatelessWidget {
  const BatchListTile({Key? key, required this.batch, this.onTap})
      : super(key: key);
  final Batch? batch;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _listTile(context);
  }

  _listTile(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(batch!.batchName),
      subtitle: Text(batch!.tag),
    );
  }
}
