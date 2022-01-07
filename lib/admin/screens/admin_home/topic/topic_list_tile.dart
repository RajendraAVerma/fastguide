
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/admin/screens/admin_home/models/topic.dart';
import 'package:fastguide/app/widgets/listtile_widget.dart';
import 'package:flutter/material.dart';

class TopicListTile extends StatelessWidget {
  const TopicListTile({
    Key? key,
    required this.topic,
    required this.onTap,
    required this.course,
    this.isLock,
  }) : super(key: key);
  final Topic? topic;
  final Course course;
  final VoidCallback onTap;
  final bool? isLock;

  @override
  Widget build(BuildContext context) {
    return listTile();
  }

  ListTile _listTileBuilder() {
    return ListTile(
      title: Text(topic!.topicName),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget listTile() {
    String themeColor1FromFirebase = course.themeColor1;
    int themeColor1Int = int.parse(themeColor1FromFirebase);
    String themeColor2FromFirebase = course.themeColor2;
    int themeColor2Int = int.parse(themeColor2FromFirebase);
    return myListTileWidget(
      title: topic!.topicName,
      subTitle: "Topic No. : " + topic!.topicNo.toString(),
      color1: Color(themeColor1Int),
      color2: Color(themeColor2Int),
      onTap: onTap,
      iconLink: topic!.iconLink,
      opTapIcon: !isLock!
          ? Icon(
              Icons.arrow_forward,
              color: Color(themeColor2Int),
            )
          : Icon(
              Icons.lock,
              color: Color(themeColor2Int),
            ),
    );
  }

  // Container newMethod(int themeColor1Int, int themeColor2Int) {
  //   return Container(
  //     margin: EdgeInsets.only(bottom: 15.0),
  //     width: double.infinity,
  //     padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
  //     decoration: BoxDecoration(
  //       image: DecorationImage(
  //         colorFilter: ColorFilter.mode(
  //             Color(themeColor1Int).withOpacity(0.3), BlendMode.dstIn),
  //         alignment: Alignment.bottomRight,
  //         image: AssetImage("assets/images/bg.png"),
  //       ),
  //       borderRadius: BorderRadius.circular(10.0),
  //       gradient: LinearGradient(
  //         begin: Alignment.centerLeft,
  //         end: Alignment.centerRight,
  //         colors: [
  //           Color(themeColor1Int),
  //           Color(themeColor2Int),
  //         ],
  //       ),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Color(themeColor2Int),
  //           offset: Offset(0, 0),
  //           blurRadius: 3.0,
  //         ),
  //       ],
  //     ),
  //     child: ListTile(
  //       contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
  //       // minLeadingWidth: 100.0,
  //       minVerticalPadding: 0.0,
  //       leading: Container(
  //         color: Colors.white,
  //         width: 100,
  //         height: 100.0,
  //         child: CachedNetworkImage(
  //           imageUrl: topic!.iconLink,
  //           imageBuilder: (context, imageProvider) =>
  //               Image(image: imageProvider),
  //           placeholder: (context, url) =>
  //               SizedBox(height: 50.0, child: CircularProgressIndicator()),
  //           errorWidget: (context, url, error) => Image(
  //             height: 100.0,
  //             image: AssetImage("assets/images/image_placeholder.png"),
  //           ),
  //         ),
  //       ),
  //       title: Text(
  //         topic!.topicName,
  //         style: TextStyle(
  //           color: Colors.white,
  //           fontFamily: "Roboto",
  //           fontWeight: FontWeight.w800,
  //         ),
  //       ),
  //       subtitle: Text(
  //         "Topic No.  :  " + topic!.topicNo.toString(),
  //         style: TextStyle(color: Colors.white, fontSize: 10.0),
  //       ),
  //       trailing: CustomIconButton(
  //         elevation: 2.0,
  //         color: Colors.white,
  //         onTap: onTap,
  //         child: Icon(
  //           Icons.arrow_forward_rounded,
  //           color: Color(themeColor1Int),
  //         ),
  //       ),
  //       onTap: onTap,
  //     ),
  //   );
  // }

}

class TopicListTileAdmin extends StatelessWidget {
  const TopicListTileAdmin({
    Key? key,
    required this.topic,
    required this.onTap,
    required this.course,
    this.isLock,
  }) : super(key: key);
  final Topic? topic;
  final Course course;
  final VoidCallback onTap;
  final bool? isLock;

  @override
  Widget build(BuildContext context) {
    return listTile();
  }

  ListTile listTile() {
    return ListTile(
      title: Text(topic!.topicName),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
