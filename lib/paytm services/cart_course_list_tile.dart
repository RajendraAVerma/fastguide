import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/app/widgets/listtile_widget.dart';
import 'package:fastguide/paytm%20services/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CourceListTile extends StatefulWidget {
  const CourceListTile({
    Key? key,
    required this.course,
    this.onTap,
  }) : super(key: key);
  final Course? course;
  final Function? onTap;

  @override
  _CourceListTileState createState() => _CourceListTileState();
}

class _CourceListTileState extends State<CourceListTile> {
  bool _isSelected = false;
  @override
  Widget build(BuildContext context) {
    String themeColor1FromFirebase = widget.course!.themeColor1;
    int themeColor1Int = int.parse(themeColor1FromFirebase);
    String themeColor2FromFirebase = widget.course!.themeColor2;
    int themeColor2Int = int.parse(themeColor2FromFirebase);
    return Consumer<CartModel>(
      builder: (context, cart, child) {
        return myListTileWidget1(
          color1: !_isSelected ? Colors.grey.shade700 : Color(themeColor1Int),
          color2: !_isSelected ? Colors.grey.shade700 : Color(themeColor2Int),
          iconLink: widget.course!.boxIconLink,
          onTap: () {
            setState(() {
              _isSelected = !_isSelected;
            });
            !_isSelected
                ? cart.add(-widget.course!.courseSellingPrice.toDouble())
                : cart.add(widget.course!.courseSellingPrice.toDouble());
            print(widget.course!.courseName);
            !_isSelected
                ? cart.addMRP(-widget.course!.courseMRP.toDouble())
                : cart.addMRP(widget.course!.courseMRP.toDouble());
            print(widget.course!.courseName);
            _isSelected
                ? cart.addCourseId(widget.course!.id)
                : cart.removeCourseId(widget.course!.id);
          },
          opTapIcon: _isSelected ? Icon(Icons.check) : Icon(Icons.add),
          title: widget.course!.courseName,
          subText: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Price : ",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontFamily: "Roboto"),
                  ),
                  Text(
                    "₹ " + widget.course!.courseMRP.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Roboto",
                      fontSize: 15.0,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Sale Price : ",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontFamily: "Roboto"),
                  ),
                  Text(
                    "₹ " + widget.course!.courseSellingPrice.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Roboto",
                    ),
                  ),
                ],
              ),
            ],
          ),
          subTitle: '',
        );
      },
    );
  }
}
