import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastguide/admin/admin_dashboard/widgets/total_member_meter.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/show_exception_alert_dialog.dart';
import 'package:fastguide/admin/screens/team/edit_team_page.dart';
import 'package:fastguide/admin/screens/team/list_item_builder.dart';
import 'package:fastguide/admin/screens/team/member_profile_page.dart';
import 'package:fastguide/admin/screens/team/model/member.dart';
import 'package:fastguide/admin/screens/team/team_list_tile.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeamPage extends StatelessWidget {
  Future<void> _delete(BuildContext context, Member member) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteMember(member: member);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  Future<void> _deleteConfirm(BuildContext context, Member member) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Confirm'),
        content: Text('Soch Le !!'),
        actions: <Widget>[
          FlatButton(
            onPressed: () async {
              await _delete(context, member);
              Navigator.of(context, rootNavigator: true)
                  .pop(); // dismisses only the dialog and returns nothing
            },
            child: new Text('Delete'),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true)
                  .pop(); // dismisses only the dialog and returns nothing
            },
            child: new Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make Team Member'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () => EditTeamPage.show(
              context,
              database: Provider.of<Database>(context, listen: false),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: Column(
            children: [
              totalMemberMeter(context),
              _buildContents(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Member>>(
      stream: database.membersStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<Member>(
          snapshot: snapshot,
          itemBuilder: (context, job) => Dismissible(
            key: Key('job-${job.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _deleteConfirm(context, job),
            child: MemberListTile(
                member: job,
                onTap: () => TeamMemberProfilePageAdmin.show(context, job)),
          ),
        );
      },
    );
  }
}
