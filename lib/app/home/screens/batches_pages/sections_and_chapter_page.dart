import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/app/home/screens/batches_pages/common_widget/ask_q_or_subscribe_button.dart';
import 'package:fastguide/app/home/screens/batches_pages/common_widget/is_subcribed_course.dart';
import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
import 'package:fastguide/app/widgets/firebase_contains_widgets/contents/course_about_listview.dart';
import 'package:fastguide/app/widgets/firebase_contains_widgets/contents/course_content_listview.dart';
import 'package:fastguide/app/widgets/firebase_contains_widgets/contents/course_faculties_listview.dart';
import 'package:fastguide/app/widgets/firebase_contains_widgets/contents/course_faqs_listview.dart';
import 'package:fastguide/app/widgets/firebase_contains_widgets/contents/course_keypoint_listview.dart';
import 'package:fastguide/app/widgets/firebase_contains_widgets/section_listview.dart';
import 'package:fastguide/app/widgets/silverScaffoldBody.dart';
import 'package:fastguide/app/drawer/navigation_drawer.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SectionAndChapterPage extends StatefulWidget {
  SectionAndChapterPage({
    required this.batch,
    required this.course,
  });
  final Batch batch;
  final Course course;

  static Future<void> show(
    BuildContext context,
    Batch batch,
    Course course,
  ) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => SectionAndChapterPage(
          batch: batch,
          course: course,
        ),
      ),
    );
  }

  @override
  _SectionAndChapterPageState createState() => _SectionAndChapterPageState();
}

class _SectionAndChapterPageState extends State<SectionAndChapterPage>
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
          child: _buildContent(
            context,
            themeColor1Int: themeColor1Int,
            themeColor2Int: themeColor1Int,
          ),
        ),
        firstTitle: Text(''),
        secondTitle: gradientText(
          text: widget.course.courseName,
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
        bannerText: gradientText(
          text: widget.course.courseName,
          color1: Color(themeColor1Int),
          color2: Color(themeColor2Int),
          fontFamily: "Roboto",
          fontWeight: FontWeight.w900,
          fontSize: 17,
        ),
        bannerSubText: gradientText(
          text: widget.batch.batchName,
          color1: Colors.black87,
          color2: Colors.black54,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context, {
    required int themeColor1Int,
    required int themeColor2Int,
  }) {
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
                  isSubcribeCourse(
                    context: context,
                    batch: widget.batch,
                    course: widget.course,
                    isSubSuscribedWidget: gradientText(
                      text: "Your Are Premium Student Now 👑",
                      color1: Color(0xff4481eb),
                      color2: Color(0xff04befe),
                      fontFamily: "Roboto",
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                    isNotSubSuscribedWidget: gradientText(
                      text: "You Haven't Subscribed !!",
                      color1: Color(0xff4481eb),
                      color2: Color(0xff04befe),
                      fontFamily: "Roboto",
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
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
                          text: "Chapters",
                          icon: Icon(Icons.subscriptions_outlined)),
                      Tab(
                          text: "Folder",
                          icon: FaIcon(FontAwesomeIcons.folder)),
                      Tab(
                          text: "About",
                          icon: FaIcon(FontAwesomeIcons.listAlt)),
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
                              SectionListView(
                                  context, widget.batch, widget.course),
                              SizedBox(height: 10.0),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              courseContentListView(
                                context,
                                widget.batch,
                                widget.course,
                              ),
                              SizedBox(height: 10.0),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Divider(),
                              courseAboutListView(
                                context,
                                widget.batch,
                                widget.course,
                              ),
                              SizedBox(height: 10.0),
                              Divider(),
                              SizedBox(height: 10.0),
                              courseFacultiesListView(
                                context,
                                widget.batch,
                                widget.course,
                              ),
                              SizedBox(height: 10.0),
                              Divider(),
                              SizedBox(height: 10.0),
                              courseKeyPointListView(
                                context,
                                widget.batch,
                                widget.course,
                              ),
                              SizedBox(height: 10.0),
                              Divider(),
                              SizedBox(height: 10.0),
                              courseFAQsListView(
                                context,
                                widget.batch,
                                widget.course,
                              ),
                              SizedBox(height: 10.0),
                              SizedBox(height: 10.0),
                            ],
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
