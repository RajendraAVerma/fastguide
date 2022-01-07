
import 'package:fastguide/admin/screens/team/model/member.dart';
import 'package:flutter/material.dart';

class MemberListTile extends StatelessWidget {
  const MemberListTile({Key? key, required this.member, this.onTap})
      : super(key: key);
  final Member? member;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _listTile(context);
  }

  Widget _listTile(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        title: Text(member!.memberName),
        subtitle: Text(
          member!.memberMobileNo.toString(),
        ),
        trailing: Text(member!.couponCode),
      ),
    );
  }
}
