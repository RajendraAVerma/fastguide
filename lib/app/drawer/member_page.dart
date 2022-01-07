import 'dart:ui';

import 'package:fastguide/admin/screens/team/model/coderedeemuser.dart';
import 'package:fastguide/admin/screens/team/model/member.dart';
import 'package:fastguide/admin/screens/team/reedeem_user/code_redeem_user_list_tile.dart';
import 'package:fastguide/admin/screens/team/reedeem_user/list_items_builder.dart';
import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
import 'package:fastguide/services/auth.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Team extends StatelessWidget {
  const Team({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    final authMobile = auth.currentUser.phoneNumber;
    void _launchURL({required String url}) async => await canLaunch(url)
        ? await launch(url)
        : throw 'Could not launch $url';
    return StreamBuilder<List<Member>>(
      stream: database.membersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final memberList = snapshot.data;
          final memberMobile = memberList!.first.memberMobileNo;

          final _checkingMember = memberList
              .map((item) => item.memberMobileNo)
              .contains(auth.currentUser.phoneNumber);

          if (_checkingMember) {
            final memberIter = memberList.where((oldValue) =>
                auth.currentUser.phoneNumber! == (oldValue.memberMobileNo));

            final member = memberIter.first;
            final memberMobileNo = memberIter.first.memberMobileNo.toString();

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blue.shade900,
                title: Text("Partner Program"),
                actions: [
                  FlatButton(
                      onPressed: () => _launchURL(
                            url: "tel:+917000303658",
                          ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.call,
                            color: Colors.white,
                            size: 18.0,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Help",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Poppins",
                                fontSize: 14.0),
                          ),
                        ],
                      ))
                ],
              ),
              body: membershipWidget(database: database, member: member),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blue.shade900,
                title: Text("Partner Program"),
              ),
              body: Container(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 50.0),
                      gradientText(
                        text: "You Are Not Joined Our Partner Program Yet 😥",
                        color1: Colors.blue.shade900,
                        color2: Colors.blue,
                        fontFamily: 'Roboto',
                        fontSize: 16,
                      ),
                      SizedBox(height: 50.0),
                      Container(
                        child: Image(
                          height: 100.0,
                          image: AssetImage(
                            "assets/images/whatsapp.png",
                          ),
                        ),
                      ),
                      SizedBox(height: 50.0),
                      gradientText(
                        text: "WhatsApp",
                        color1: Colors.green.shade900,
                        color2: Colors.green,
                        fontFamily: 'Roboto',
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                      SizedBox(height: 20.0),
                      gradientText(
                        text: "+91 8103833029",
                        color1: Colors.green.shade900,
                        color2: Colors.green,
                        fontFamily: 'Roboto',
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                      SizedBox(height: 20.0),
                      Center(
                        child: GestureDetector(
                          onTap: () => _launchURL(
                            url: "https://wa.me/qr/L3PT27P3CFNHK1",
                          ),
                          child: Container(
                            height: 70,
                            width: 300,
                            padding: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade700,
                              borderRadius: BorderRadius.circular(10.0),
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xff128C7E),
                                  Color(0xff25D366),
                                ],
                              ),
                            ),
                            child: Center(
                                child: Text(
                              "Click Here",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Poppins",
                                fontSize: 20.0,
                              ),
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        } else if (snapshot.hasError) {
          Scaffold(
            body: Container(
                child: Center(child: Text('Something Went Wrong !!'))),
          );
        }
        ;
        return Scaffold(
          body: Container(child: Center(child: CircularProgressIndicator())),
        );
      },
    );
  }
}

class membershipWidget extends StatelessWidget {
  const membershipWidget({
    Key? key,
    required this.database,
    required this.member,
  }) : super(key: key);

  final Database database;
  final Member member;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            SizedBox(height: 20.0),
            Center(
              child: gradientText(
                text: "Congrutulation! 🎉 You Are FastGuide Partner",
                color1: Colors.green.shade900,
                color2: Colors.green,
                fontFamily: 'Roboto',
                fontSize: 16,
              ),
            ),
            StreamBuilder<List<CodeRedeemUser>>(
              stream: database.codeRedeemUsersStream(member: member),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final totalCodeRedeemUser =
                      snapshot.data!.length != 0 ? snapshot.data!.length : 0;

                  return Column(
                    children: [
                      _totalStudentNoWidget(totalCodeRedeemUser),
                    ],
                  );
                } else {
                  final totalCodeRedeemUser = 0;

                  return Column(
                    children: [
                      _totalStudentNoWidget(totalCodeRedeemUser),
                    ],
                  );
                }
              },
            ),
            _couponCodeWidget(context),
            SizedBox(height: 20.0),
            gradientText(
              text: "Your Referral Student",
              color2: Colors.blue,
              color1: Colors.indigo,
              fontFamily: "Poppins",
              fontSize: 20.0,
              fontWeight: FontWeight.w800,
            ),
            SizedBox(height: 20.0),
            StreamBuilder<List<CodeRedeemUser>>(
              stream: database.codeRedeemUsersStream(member: member),
              builder: (context, snapshot) {
                return ListItemsBuilder<CodeRedeemUser>(
                  snapshot: snapshot,
                  itemBuilder: (context, codeRedeemUser) =>
                      CodeRedeemUsersListTile(
                    onTap: () {},
                    codeRedeemUser: codeRedeemUser,
                  ),
                );
              },
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Stack _couponCodeWidget(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(15.0),
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.green,
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.blue.shade900,
                Colors.blue.shade500,
              ],
            ),
            shape: BoxShape.rectangle,
          ),
          child: Column(
            children: [
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: gradientText(
                      text: member.percentage.toString() + ' % OFF',
                      color2: Colors.white,
                      color1: Colors.white,
                      fontFamily: 'Roboto',
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Container(
                      width: 150.0,
                      height: 50.0,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Center(
                        child: gradientText(
                          text: member.couponCode,
                          color2: Colors.red,
                          color1: Colors.redAccent,
                          fontFamily: 'Roboto',
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      )),
                  Container(
                    child: IconButton(
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: member.couponCode));
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Coupon Code Copied !')));
                      },
                      icon: Icon(
                        Icons.copy_sharp,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20.0),
              Container(
                child: Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10.0),
                    gradientText(
                      text: 'Name :  ' + member.memberName,
                      color2: Colors.white,
                      color1: Colors.white,
                      fontFamily: 'Roboto',
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                child: Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet_rounded,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10.0),
                    gradientText(
                      text: 'UPI :  ' + member.upi,
                      color2: Colors.white,
                      color1: Colors.white,
                      fontFamily: 'Roboto',
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.green,
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.pink.shade200,
                  Colors.pink.shade400,
                ],
              ),
              shape: BoxShape.rectangle,
            ),
            child: Text(
              "Your Coupon Details",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container _totalStudentNoWidget(int totalCodeRedeemUser) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          gradientText(
              text: "Total Student Join",
              color2: Colors.blue,
              color1: Colors.indigo,
              fontFamily: "Poppins",
              fontSize: 20.0,
              fontWeight: FontWeight.w800),
          Container(
            padding: EdgeInsets.all(30.0),
            decoration: BoxDecoration(
              color: Colors.green,
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.green,
                  Colors.green.shade800,
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: gradientText(
              text: totalCodeRedeemUser.toString(),
              color2: Colors.white,
              color1: Colors.white,
              fontFamily: "Roboto",
              fontSize: 30.0,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
