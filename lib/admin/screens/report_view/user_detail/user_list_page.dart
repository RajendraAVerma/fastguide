import 'package:fastguide/admin/admin_dashboard/widgets/total_student_meter.dart';
import 'package:fastguide/admin/screens/report_view/user_detail/list_item_builder.dart';
import 'package:fastguide/admin/screens/report_view/user_detail/user_list_search_page.dart';
import 'package:fastguide/admin/screens/report_view/user_detail/user_list_tile.dart';
import 'package:fastguide/admin/screens/report_view/user_detail/user_profile/user_profile_page.dart';
import 'package:fastguide/login/data_models/user_model.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  bool _isSort = false;
  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: TextField(
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white, fontFamily: "Roboto"),
                controller: _controller,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search",
                    hintStyle:
                        TextStyle(color: Colors.white, fontFamily: "Poppins")),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UserListSearchPageName(
                      searchName: _controller.text,
                    ))),
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UserListSearchPageMobileNo(
                      searchName: _controller.text,
                    ))),
            icon: Icon(Icons.phone),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: totalStudentMeter(context)),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isSort == false ? _isSort = true : _isSort = false;
                      });
                    },
                    icon: Icon(
                      Icons.sort,
                      color: _isSort ? Colors.blue : Colors.black,
                    ),
                  ),
                ],
              ),
              Container(
                child: Text(
                  _isSort
                      ? "Sort By Alphabet"
                      : "Sort By Time Of Registration/Update",
                  style: TextStyle(fontFamily: "Poppins"),
                ),
              ),
              Divider(),
              _isSort
                  ? _buildContentsByAlphabet(context)
                  : _buildContentsByTime(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentsByTime(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<UserData>>(
      stream: database.UsersStream(),
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

  Widget _buildContentsByAlphabet(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<UserData>>(
      stream: database.UsersStreamSortByAlphabet(),
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
