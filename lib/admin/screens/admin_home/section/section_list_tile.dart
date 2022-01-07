import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/admin/screens/admin_home/models/section.dart';
import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
import 'package:fastguide/app/widgets/firebase_contains_widgets/chapters_listview.dart';
import 'package:flutter/material.dart';

class SectionListTile extends StatelessWidget {
  const SectionListTile({
    Key? key,
    required this.batch,
    required this.course,
    required this.section,
    this.onTap,
  }) : super(key: key);
  final Batch batch;
  final Course course;
  final Section? section;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _mainContent(context);
  }

  ListTile _listTileBuilder() {
    return ListTile(
      title: Text(section!.sectionName),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _mainContent(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              gradientText(
                text: section!.sectionName,
                color1: Colors.black54,
                color2: Colors.black54,
                fontFamily: 'Roboto',
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(height: 10.0),
              chapterListView(context, batch, course, section!),
              SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionListTileAdmin extends StatelessWidget {
  const SectionListTileAdmin({
    Key? key,
    required this.batch,
    required this.course,
    required this.section,
    this.onTap,
  }) : super(key: key);
  final Batch batch;
  final Course course;
  final Section? section;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _listTileBuilder();
  }

  ListTile _listTileBuilder() {
    return ListTile(
      title: Text(section!.sectionName),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
