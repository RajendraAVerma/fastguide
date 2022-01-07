import 'package:fastguide/admin/admin_dashboard/admin_dashboard.dart';
import 'package:fastguide/admin/screens/report_view/user_detail/user_list_page.dart';
import 'package:fastguide/admin/screens/team/team_page.dart';
import 'package:fastguide/app/widgets/all_type_text_widget.dart/animated_text.dart';
import 'package:fastguide/app/drawer/navigation_drawer.dart';
import 'package:fastguide/app/widgets/slidder_depart/slidder_page.dart';
import 'package:fastguide/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainAdminPage extends StatefulWidget {
  @override
  _MainAdminPageState createState() => _MainAdminPageState();
}

class _MainAdminPageState extends State<MainAdminPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainAdminWidgetModel>(
      create: (context) => MainAdminWidgetModel(),
      child: Consumer<MainAdminWidgetModel>(
        builder: (context, model, child) => Scaffold(
          drawer: NavigationDrawerWidget(),
          body: model.currentScreen,

          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.report_rounded,
                  color: Colors.black,
                ),
                title: Text(
                  "Report",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: Colors.black,
                ),
                title: Text(
                  "Home",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                title: Text(
                  "Team",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.image,
                  color: Colors.black,
                ),
                title: Text(
                  "Image",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
            currentIndex: model.currentTab,
            onTap: (int index) {
              model.currentTab = index;
              print(model.currentTab);
            },
          ),
          //_buildContent(auth, context),
        ),
      ),
    );
  }

  AppBar appBarHome(String admin) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: Builder(
        builder: (context) => GestureDetector(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: Container(
            margin: EdgeInsets.all(6.0),
            child: Icon(Icons.menu),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              gradient: new LinearGradient(
                colors: [
                  const Color(0xFF3366FF),
                  const Color(0xFF00CCFF),
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildContent(AuthBase auth, BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(auth.currentUser.phoneNumber!),
          ),
        ],
      ),
    );
  }
}

class MainAdminWidgetModel extends ChangeNotifier {
  int _currentTab = 1;
  List<Widget> _screens = [
    UserListPage(),
    AdminDashboard(),
    TeamPage(),
    SlidderPage(),
  ];
  set currentTab(int tab) {
    this._currentTab = tab;
    notifyListeners();
  }

  int get currentTab => this._currentTab;
  get currentScreen => this._screens[this._currentTab];
}
