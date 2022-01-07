import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastguide/admin/screens/admin_home/common_widgets/show_exception_alert_dialog.dart';
import 'package:fastguide/admin/screens/team/edit_team_page.dart';
import 'package:fastguide/admin/screens/team/model/coderedeemuser.dart';
import 'package:fastguide/admin/screens/team/model/member.dart';
import 'package:fastguide/admin/screens/team/reedeem_user/code_redeem_user_list_tile.dart';
import 'package:fastguide/admin/screens/team/reedeem_user/edit_code_redeem_user_page.dart';
import 'package:fastguide/admin/screens/team/reedeem_user/list_items_builder.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CodeRedeemUsersPage extends StatelessWidget {
  const CodeRedeemUsersPage({required this.database, required this.member});
  final Database database;
  final Member member;

  static Future<void> show(
    BuildContext context,
    Member member,
  ) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => CodeRedeemUsersPage(
          database: database,
          member: member,
        ),
      ),
    );
  }

  Future<void> _delete(
    BuildContext context,
    Member member,
    CodeRedeemUser codeRedeemUser,
  ) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteCodeRedeemUser(
          member: member, codeRedeemUser: codeRedeemUser);
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
    return StreamBuilder<Member>(
      stream: database.memberStream(member: member),
      builder: (context, snapshot) {
        final job = snapshot.data;
        final jobName = job?.memberName ?? '';
        return Scaffold(
          appBar: AppBar(
            elevation: 2.0,
            title: Text(jobName),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: () => EditTeamPage.show(
                  context,
                  database: database,
                  member: member,
                ),
              ),
              IconButton(
                icon: Icon(Icons.add, color: Colors.white),
                onPressed: () => EditCodeRedeemUsersPage.show(
                  context,
                  database: database,
                  member: member,
                ),
              ),
            ],
          ),
          body: _buildContents(context, member),
        );
      },
    );
  }

  Widget _buildContents(
    BuildContext context,
    Member member,
  ) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<CodeRedeemUser>>(
      stream: database.codeRedeemUsersStream(member: member),
      builder: (context, snapshot) {
        return ListItemsBuilder<CodeRedeemUser>(
          snapshot: snapshot,
          itemBuilder: (context, codeRedeemUser) => Dismissible(
            key: Key('job-${codeRedeemUser.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) =>
                _delete(context, member, codeRedeemUser),
            child: CodeRedeemUsersListTile(
              onTap: () {},
              codeRedeemUser: codeRedeemUser,
            ),
          ),
        );
      },
    );
  }
}
