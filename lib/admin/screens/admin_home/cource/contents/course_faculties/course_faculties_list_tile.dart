import 'package:cached_network_image/cached_network_image.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/contents/course_facalties.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CourseFacultiesListTile extends StatelessWidget {
  const CourseFacultiesListTile({
    Key? key,
    required this.batch,
    required this.course,
    required this.courseFaculties,
    this.onTap,
  }) : super(key: key);
  final Batch batch;
  final Course course;
  final CourseFaculties? courseFaculties;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _listTileBuilder();
  }

  Widget _listTileBuilder() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: 120.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.black38),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              height: 150.0,
              width: 120.0,
              child: CachedNetworkImage(
                imageUrl: courseFaculties!.imageLink,
                imageBuilder: (context, imageProvider) => ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: Image(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
                placeholder: (context, url) => SizedBox(
                  height: 100.0,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade400,
                    highlightColor: Colors.white,
                    child: Image(
                      height: 100.0,
                      image: AssetImage("assets/images/image_placeholder.png"),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Image(
                  height: 100.0,
                  image: AssetImage("assets/images/image_placeholder.png"),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: gradientText(
                        text: courseFaculties!.name,
                        color1: Colors.black,
                        color2: Colors.black,
                        fontFamily: "Mukta",
                        fontSize: 14.0,
                      ),
                    ),
                    Expanded(
                      child: gradientText(
                        text: '( ' + courseFaculties!.courseName + ' )',
                        color1: Colors.black,
                        color2: Colors.black,
                        fontFamily: "Mukta",
                        fontSize: 11.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseFacultiesListTileAdmin extends StatelessWidget {
  const CourseFacultiesListTileAdmin({
    Key? key,
    required this.batch,
    required this.course,
    required this.courseFaculties,
    this.onTap,
  }) : super(key: key);
  final Batch batch;
  final Course course;
  final CourseFaculties? courseFaculties;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _listTileBuilder();
  }

  Widget _listTileBuilder() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ListTile(
        onTap: onTap,
        title: Text(courseFaculties!.name),
        subtitle: Text(courseFaculties!.courseName),
      ),
    );
  }
}
