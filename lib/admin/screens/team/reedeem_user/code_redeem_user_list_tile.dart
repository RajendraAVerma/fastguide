import 'package:fastguide/admin/screens/team/model/coderedeemuser.dart';
import 'package:flutter/material.dart';

class CodeRedeemUsersListTile extends StatelessWidget {
  const CodeRedeemUsersListTile(
      {Key? key, required this.codeRedeemUser, this.onTap})
      : super(key: key);
  final CodeRedeemUser? codeRedeemUser;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _listTile();
  }

  ListTile _listTile() {
    return ListTile(
      title: Text(codeRedeemUser!.userName),
      subtitle: Text(
          '+' + codeRedeemUser!.mobileNo.toString().substring(0, 7) + '*****'),
      trailing: Text(codeRedeemUser!.date),
      onTap: onTap,
    );
  }
}

class CodeRedeemUsersListTileAdmin extends StatelessWidget {
  const CodeRedeemUsersListTileAdmin(
      {Key? key, required this.codeRedeemUser, this.onTap})
      : super(key: key);
  final CodeRedeemUser? codeRedeemUser;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _listTile();
  }

  ListTile _listTile() {
    return ListTile(
      title: Text(codeRedeemUser!.userName),
      subtitle: Text('+' + codeRedeemUser!.mobileNo.toString()),
      trailing: Text(codeRedeemUser!.date),
      onTap: onTap,
    );
  }
}
