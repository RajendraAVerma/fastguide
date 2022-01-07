import 'package:cached_network_image/cached_network_image.dart';
import 'package:fastguide/app/widgets/custom_icon_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget myListTileWidget({
  required String title,
  required String subTitle,
  required Color color1,
  required Color color2,
  // ImageProvider trailingBackground,
  required VoidCallback onTap,
  required Icon opTapIcon,
  required String iconLink,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: EdgeInsets.only(top: 15.0),
      padding: EdgeInsets.all(5.0),
      height: 100.0,
      width: double.maxFinite,
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter:
              ColorFilter.mode(color1.withOpacity(0.3), BlendMode.dstIn),
          alignment: Alignment.bottomRight,
          image: AssetImage("assets/images/bg.png"),
        ),
        borderRadius: BorderRadius.circular(10.0),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            color1,
            color2,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: color1,
            offset: Offset(0, 0),
            blurRadius: 3.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 100.0,
            width: 100.0,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
            ),
            child: CachedNetworkImage(
              imageUrl: iconLink,
              imageBuilder: (context, imageProvider) =>
                  Image(image: imageProvider),
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
          SizedBox(width: 7.0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                Text(
                  subTitle,
                  style: TextStyle(color: Colors.white, fontSize: 10.0),
                ),
              ],
            ),
          ),
          SizedBox(width: 7.0),
          CustomIconButton(
            elevation: 2.0,
            color: Colors.white,
            onTap: onTap,
            child: opTapIcon,
          ),
        ],
      ),
    ),
  );
}

Widget myListTileWidget1({
  required String title,
  required String subTitle,
  required Widget subText,
  required Color color1,
  required Color color2,
  // ImageProvider trailingBackground,
  required VoidCallback onTap,
  required Icon opTapIcon,
  required String iconLink,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: EdgeInsets.only(top: 15.0),
      padding: EdgeInsets.all(5.0),
      height: 110.0,
      width: double.maxFinite,
      decoration: BoxDecoration(
        // image: DecorationImage(
        //   colorFilter:
        //       ColorFilter.mode(color1.withOpacity(0.3), BlendMode.dstIn),
        //   alignment: Alignment.bottomRight,
        //   image: AssetImage("assets/images/bg.png"),
        // ),
        borderRadius: BorderRadius.circular(10.0),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            color1,
            color2,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: color1,
            offset: Offset(0, 0),
            blurRadius: 3.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 100.0,
            width: 100.0,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
            ),
            child: CachedNetworkImage(
              imageUrl: iconLink,
              imageBuilder: (context, imageProvider) =>
                  Image(image: imageProvider),
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
          SizedBox(width: 7.0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w800,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                subText,
              ],
            ),
          ),
          SizedBox(width: 7.0),
          CustomIconButton(
            elevation: 2.0,
            color: Colors.white,
            onTap: onTap,
            child: opTapIcon,
          ),
        ],
      ),
    ),
  );
}
