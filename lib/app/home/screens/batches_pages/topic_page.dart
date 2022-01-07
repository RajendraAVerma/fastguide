import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/chapter.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/admin/screens/admin_home/models/section.dart';
import 'package:fastguide/app/home/screens/batches_pages/common_widget/ask_q_or_subscribe_button.dart';
import 'package:fastguide/app/widgets/all_type_text_widget.dart/animated_text.dart';
import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
import 'package:fastguide/app/widgets/firebase_contains_widgets/contents/chapter_content_listview.dart';
import 'package:fastguide/app/widgets/firebase_contains_widgets/topics_listview.dart';
import 'package:fastguide/app/widgets/silverScaffoldBody.dart';
import 'package:fastguide/app/drawer/navigation_drawer.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class TopicPage extends StatefulWidget {
  TopicPage({
    required this.batch,
    required this.course,
    required this.section,
    required this.chapter,
  });
  final Batch batch;
  final Course course;
  final Section section;
  final Chapter chapter;

  static Future<void> show(
    BuildContext context,
    Batch batch,
    Course course,
    Section section,
    Chapter chapter,
  ) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => TopicPage(
          batch: batch,
          course: course,
          section: section,
          chapter: chapter,
        ),
      ),
    );
  }

  @override
  _TopicPageState createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String themeColor1FromFirebase = widget.course.themeColor1;
    int themeColor1Int = int.parse(themeColor1FromFirebase);
    String themeColor2FromFirebase = widget.course.themeColor2;
    int themeColor2Int = int.parse(themeColor2FromFirebase);
    super.build(context);
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      body: SilverScaffoldBody(
        body: Container(
          color: Colors.white,
          child: _buildContent(context),
        ),
        firstTitle: Text(
          widget.batch.batchName,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 12.0,
          ),
        ),
        secondTitle: gradientText(
          text: widget.chapter.chapterName,
          color1: Colors.black87,
          color2: Colors.black54,
          fontFamily: "Roboto",
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        leadingAppBarIcon: Icon(
          Icons.arrow_back_rounded,
          color: Color(themeColor1Int),
        ),
        leadingAppBarFucntion: 2,
        actionListTileIcon: SizedBox(),
        actionListTileText: askQuestion_or_SubScribe_button(
          context: context,
          batch: widget.batch,
          course: widget.course,
        ),
        actionListTileOnTap: () {},
        imageLink: widget.course.thumnailLink,
        bannerText: Text(
          "",
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Raleway",
            fontSize: 14,
          ),
        ),
        bannerSubText: Row(
          children: [
            Text(
              "Chapter ",
              style: TextStyle(
                color: Colors.black,
                fontFamily: "Raleway",
                fontSize: 14,
              ),
            ),
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(themeColor1Int),
                    Color(themeColor2Int),
                  ],
                ),
              ),
              child: Text(
                widget.chapter.chapterNo.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    String themeColor1FromFirebase = widget.course.themeColor1;
    int themeColor1Int = int.parse(themeColor1FromFirebase);
    String themeColor2FromFirebase = widget.course.themeColor2;
    int themeColor2Int = int.parse(themeColor2FromFirebase);
    super.build(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        children: [
          SizedBox(height: 20.0),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: gradientText(
                      text: widget.chapter.chapterName,
                      color1: Color(themeColor1Int),
                      color2: Color(themeColor2Int),
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        10.0,
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(themeColor1Int),
                          Color(themeColor2Int),
                        ],
                      ),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    tabs: [
                      Tab(
                          text: "Topics",
                          icon: Icon(Icons.subscriptions_outlined)),
                      Tab(
                          text: "Folder",
                          icon: FaIcon(FontAwesomeIcons.folder)),
                      Tab(
                          text: "Test",
                          icon: FaIcon(FontAwesomeIcons.penFancy)),
                    ],
                  ),
                  Expanded(
                    flex: 1,
                    child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              topicListView(
                                  context,
                                  widget.batch,
                                  widget.course,
                                  widget.section,
                                  widget.chapter),
                              SizedBox(height: 10.0),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              chapterContentListView(
                                context,
                                widget.batch,
                                widget.course,
                                widget.section,
                                widget.chapter,
                              ),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          child: Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(height: 10.0),
                                Container(
                                    height:
                                        MediaQuery.of(context).size.height / 4,
                                    width: MediaQuery.of(context).size.width,
                                    child: Image(
                                        image: AssetImage(
                                            'assets/images/coming_soon.png'))),
                                animatedHeaderText_1("Coming Soon", 27),
                                gradientText(
                                  text: " जल्द आ रहा है ",
                                  color1: Colors.blue.shade800,
                                  color2: Colors.blue.shade700,
                                  fontFamily: 'Mukta',
                                  fontSize: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
