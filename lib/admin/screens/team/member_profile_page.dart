import 'package:fastguide/admin/screens/admin_home/common_widgets/show_exception_alert_dialog.dart';
import 'package:fastguide/admin/screens/team/edit_team_page.dart';
import 'package:fastguide/admin/screens/team/model/coderedeemuser.dart';
import 'package:fastguide/admin/screens/team/model/member.dart';
import 'package:fastguide/admin/screens/team/reedeem_user/code_redeem_user_list_tile.dart';
import 'package:fastguide/admin/screens/team/reedeem_user/list_items_builder.dart';
import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
import 'package:fastguide/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TeamMemberProfilePageAdmin extends StatelessWidget {
  const TeamMemberProfilePageAdmin({
    Key? key,
    required this.database,
    required this.member,
  }) : super(key: key);
  final Database database;
  final Member member;

  static Future<void> show(BuildContext context, Member member) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) =>
            TeamMemberProfilePageAdmin(database: database, member: member),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(member.memberName),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => EditTeamPage.show(
              context,
              database: database,
              member: member,
            ),
            icon: Icon(
              Icons.edit,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildContent(member, context),
          ],
        ),
      ),
    );
  }

  _buildContent(Member member, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      color: Colors.white,
      alignment: Alignment.center,
      child: Container(
        child: Column(
          children: [
            SizedBox(height: 40.0),
            Container(
              height: 50.0,
              child: gradientText(
                text: member.memberName,
                color1: Colors.red,
                color2: Colors.redAccent,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w800,
                fontSize: 25,
              ),
            ),
            Row(
              children: [
                Icon(Icons.call),
                SizedBox(width: 20.0),
                Expanded(
                  child: gradientText(
                    text: member.memberMobileNo,
                    color1: Colors.indigo,
                    color2: Colors.indigoAccent,
                    fontFamily: "Poppins",
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                Icon(Icons.credit_card),
                SizedBox(width: 20.0),
                Expanded(
                  child: gradientText(
                    text: member.upi,
                    color1: Colors.indigoAccent,
                    color2: Colors.indigo,
                    fontFamily: "Poppins",
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                Text("<<<< Member Firebase Id >>>>"),
                SizedBox(width: 20.0),
                Expanded(
                  child: gradientText(
                    text: member.id,
                    color1: Colors.indigoAccent,
                    color2: Colors.indigo,
                    fontFamily: "Poppins",
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            _couponCodeDetail(member),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                gradientText(
                  text: "Total Code Reedeem User",
                  color1: Colors.green.shade700,
                  color2: Colors.green.shade900,
                  fontFamily: "Poppins",
                  fontSize: 15.0,
                ),
                _totalCodeRedeemedUser(context, member),
              ],
            ),
            SizedBox(height: 20.0),
            _codeRedeemedUser(context, member),
          ],
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

  Widget _codeRedeemedUser(
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
            child: CodeRedeemUsersListTileAdmin(
              onTap: () {},
              codeRedeemUser: codeRedeemUser,
            ),
          ),
        );
      },
    );
  }

  Widget _totalCodeRedeemedUser(
    BuildContext context,
    Member member,
  ) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<CodeRedeemUser>>(
      stream: database.codeRedeemUsersStream(member: member),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final totalRedeemUser = snapshot.data!.length.toString();
          return Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green.shade800,
            ),
            child: Text(
              totalRedeemUser,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
            ),
          );
        } else if (snapshot.hasError) {
          return Text("Error");
        }
        return CircularProgressIndicator();
      },
    );
  }

  Container _couponCodeDetail(Member member) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Coupon Code"),
                Text(
                  member.couponCode,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Percentage Off"),
                Text(
                  member.percentage.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
