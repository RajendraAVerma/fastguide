import 'package:fastguide/app/drawer/user_profile/user_profile_page.dart';
import 'package:fastguide/app/home/screens/explore_page/explore_page.dart';
import 'package:fastguide/app/home/screens/home_page/home_page.dart';
import 'package:fastguide/app/drawer/navigation_drawer.dart';
import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
import 'package:fastguide/login/data_models/user_online_model.dart';
import 'package:fastguide/services/auth.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';

class MainAppPage extends StatefulWidget {
  @override
  _MainAppPageState createState() => _MainAppPageState();
}

class _MainAppPageState extends State<MainAppPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    print('initial app >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    final newVersion = NewVersion(
      androidId: 'com.fastguide.fastguide',
    );
    const simpleBehavior = true;

    if (simpleBehavior) {
      basicStatusCheck(newVersion);
    } else {
      advancedStatusCheck(newVersion);
    }
  }

  basicStatusCheck(NewVersion newVersion) {
    newVersion.showAlertIfNecessary(context: context);
  }

  advancedStatusCheck(NewVersion newVersion) async {
    final status = await newVersion.getVersionStatus();
    debugPrint(status!.releaseNotes);
    debugPrint(status.appStoreLink);
    debugPrint(status.localVersion);
    debugPrint(status.storeVersion);
    debugPrint(status.canUpdate.toString());
    newVersion.showUpdateDialog(
      allowDismissal: true,
      context: context,
      versionStatus: status,
      dialogTitle: 'Update Available',
      dialogText:
          'You Should Update App from Version ${status.localVersion} to Version ${status.storeVersion}.\nआपको इस ऐप को अभी अपडेट करना चाहिए |',
    );
  }

  _setOnlineStatus() async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    final userStatusData = await UserStatusData(
        id: auth.currentUser.phoneNumber!, status: "online");
    await database.setUserstatus(userStatusData: userStatusData);
    print('user Online >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
  }

  _setOfflineStatus() async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);

    final userStatusData = await UserStatusData(
        id: auth.currentUser.phoneNumber!, status: "offline");
    await database.setUserstatus(userStatusData: userStatusData);
    print('user Offline >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('user Active >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    if (state == AppLifecycleState.resumed) {
      _setOnlineStatus();
    } else {
      _setOfflineStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    return ChangeNotifierProvider<MainWidgetModel>(
      create: (context) => MainWidgetModel(),
      child: Consumer<MainWidgetModel>(
        builder: (context, model, child) => Scaffold(
          drawer: NavigationDrawerWidget(),
          body: model.currentScreen,
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.red,
            selectedLabelStyle: TextStyle(fontFamily: 'Poppins'),
            unselectedLabelStyle: TextStyle(fontFamily: 'Poppins'),
            enableFeedback: true,
            elevation: 0.8,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.explore),
                // Container(
                //   child: Image(
                //     height: 30.0,
                //     image: AssetImage("assets/images/explore.png"),
                //   ),
                // ),
                label: "Explore",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.subscriptions),
                //  Container(
                //   child: Image(
                //     height: 30.0,
                //     image: AssetImage("assets/images/my_class.png"),
                //   ),
                // ),
                label: "My Class",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                // Container(
                //   child: Image(
                //     height: 30.0,
                //     image: AssetImage("assets/images/settings.png"),
                //   ),
                // ),
                label: "Profile",
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

class MainWidgetModel extends ChangeNotifier {
  int _currentTab = 1;
  List<Widget> _screens = [
    ExplorePage(),
    HomePage(),
    UserProfilePage(),
  ];
  set currentTab(int tab) {
    this._currentTab = tab;
    notifyListeners();
  }

  int get currentTab => this._currentTab;
  get currentScreen => this._screens[this._currentTab];
}
