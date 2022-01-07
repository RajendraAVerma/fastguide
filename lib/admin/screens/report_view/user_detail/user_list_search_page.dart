
import 'package:fastguide/admin/screens/report_view/user_detail/list_item_builder.dart';
import 'package:fastguide/admin/screens/report_view/user_detail/user_list_tile.dart';
import 'package:fastguide/admin/screens/report_view/user_detail/user_profile/user_profile_page.dart';
import 'package:fastguide/login/data_models/user_model.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserListSearchPageName extends StatelessWidget {
  const UserListSearchPageName({Key? key, required this.searchName})
      : super(key: key);
  final String searchName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(searchName),
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: Column(
            children: [
              _buildContents(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<UserData>>(
      stream: database.UsersStreamForSearchName(searchName: searchName),
      builder: (context, snapshot) {
        return ListItemsBuilder<UserData>(
          snapshot: snapshot,
          itemBuilder: (context, userData) => UserListTile(
            userData: userData,
            onTap: () => UserProfilePageAdmin.show(context, userData),
          ),
        );
      },
    );
  }
}

class UserListSearchPageMobileNo extends StatelessWidget {
  const UserListSearchPageMobileNo({Key? key, required this.searchName})
      : super(key: key);
  final String searchName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(searchName),
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: Column(
            children: [
              _buildContents(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<UserData>>(
      stream: database.UsersStreamForSearchMobileNo(searchName: searchName),
      builder: (context, snapshot) {
        return ListItemsBuilder<UserData>(
          snapshot: snapshot,
          itemBuilder: (context, userData) => UserListTile(
            userData: userData,
            onTap: () => UserProfilePageAdmin.show(context, userData),
          ),
        );
      },
    );
  }
}