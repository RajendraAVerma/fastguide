import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/admin/screens/admin_home/models/course.dart';
import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
import 'package:fastguide/app/widgets/webpage_iframe_page.dart';
import 'package:fastguide/login/data_models/user_model.dart';
import 'package:fastguide/login/data_models/user_subcribed_class_model.dart';
import 'package:fastguide/paytm%20services/PaymentScreen.dart';
import 'package:fastguide/paytm%20services/cart_course_list_item_builder.dart';
import 'package:fastguide/paytm%20services/cart_course_list_tile.dart';
import 'package:fastguide/paytm%20services/cart_model.dart';
import 'package:fastguide/paytm%20services/coupon_code.dart';
import 'package:fastguide/services/auth.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CartPage extends StatefulWidget {
  CartPage({
    required this.batch,
  });
  final Batch batch;

  static Future<void> show(
    BuildContext context,
    Batch batch,
  ) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => ChangeNotifierProvider(
          create: (context) => CartModel(),
          child: CartPage(batch: batch),
        ),
      ),
    );
  }

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    String documentIdFromCurrentDate() => DateTime.now().toIso8601String();
    final database = Provider.of<Database>(context, listen: false);
    final cartModel = Provider.of<CartModel>(context, listen: false);
    void _launchURL({required String url}) async => await canLaunch(url)
        ? await launch(url)
        : throw 'Could not launch $url';
    // _addToSubcribedClass() async {
    //   for (var courseId in cartModel.courseIdsList) {
    //     final userSubcribedClassData = UserSubcribedClassData(
    //       id: "id",
    //       userSubcribedBatch: '${widget.batch.id}',
    //       userSubcribedCourse: '${courseId}',
    //       date: documentIdFromCurrentDate(),
    //     );
    //     await database.setUserSubcribedClass(
    //       userSubcribedClassData: userSubcribedClassData,
    //     );
    //     print('ADDED To SubCribed Class : $courseId');
    //   }
    // }
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xff764ba2),
                Color(0xff667eea),
              ],
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("Purchase Page"),
        actions: [
          FlatButton(
              onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => WebPageViewiFrame(
                        url: 'https://fastguide.in/contact-us-app/',
                        color: Colors.blue.shade700,
                        title: 'Contact Us',
                      ),
                    ),
                  ),
              child: Row(
                children: [
                  Icon(
                    Icons.call,
                    color: Colors.white,
                    size: 18.0,
                  ),
                  SizedBox(width: 5),
                  Text(
                    "Help",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Poppins",
                        fontSize: 14.0),
                  ),
                ],
              ))
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  gradientText(
                    text: widget.batch.batchName + " - " + widget.batch.tag,
                    color1: Color(0xff764ba2),
                    color2: Color(0xff667eea),
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                  _userStreamBuilder(database),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 1.0, horizontal: 20.0),
                      child: Column(
                        children: [
                          SizedBox(height: 10.0),
                          gradientText(
                            text:
                                "आप जिस - जिस विषय की सदस्यता लेना चाहते हैं, उसके आगे ADD बटन पर क्लिक करें, फिर BUY NOW पर क्लिक करें।",
                            color1: Colors.black,
                            color2: Colors.black87,
                            fontFamily: "mukta",
                            fontSize: 15,
                          ),
                          SizedBox(height: 8.0),
                          gradientText(
                            text:
                                "किसी भी प्रकार की समस्या या जानकारी के लिए ऊपर दिए Help बटन पर क्लिक करके हमें कॉल करें।",
                            color1: Colors.black,
                            color2: Colors.black87,
                            fontFamily: "mukta",
                            fontSize: 15,
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 20.0),
                      child: _courseListTile(database),
                    ),
                    // Consumer<CartModel>(
                    //   builder: (context, cart, child) {
                    //     return Text(
                    //         "Total Course Selected: ${cart.courseIdsList}");
                    //   },
                    // ),
                    // Consumer<CartModel>(
                    //   builder: (context, cart, child) {
                    //     if (cart.memberList.isNotEmpty) {
                    //       return Text(cart.member.memberName);
                    //     }
                    //     return Text("Select Coupon");
                    //   },
                    // ),
                    SizedBox(height: 20.0),
                    _totalInvoice(context),
                    SizedBox(height: 20.0),
                    Consumer<CartModel>(
                      builder: (context, cart, child) {
                        return Center(
                          child: GestureDetector(
                            onTap: () => cart.clickedTerms(),
                            child: Container(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(width: 50.0),
                                  cart.isClickedTermsAndCondition
                                      ? Icon(
                                          Icons.check_box,
                                          color: Colors.blue,
                                        )
                                      : Icon(Icons
                                          .check_box_outline_blank_outlined),
                                  Expanded(
                                      child: GestureDetector(
                                    onTap: () => _launchURL(
                                      url:
                                          "https://fastguide.in/app-payment-terms/",
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Agree Terms And Condition"),
                                    ),
                                  )),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      height: 90.0,
                      child:
                          CouponCode(database: database, cartModel: cartModel),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(10.0),
                //   topRight: Radius.circular(10.0),
                // ),
                color: Colors.green,
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xff764ba2),
                    Color(0xff667eea),
                  ],
                ),
                shape: BoxShape.rectangle,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Consumer<CartModel>(
                      builder: (context, cart, child) {
                        return gradientText(
                          text: cart.couponCodeList.isEmpty
                              ? "Total Price ₹ " +
                                  cart.totalCoursePrice.toString()
                              : "Total Price ₹ " +
                                  cart.totalCoursePriceWhenCouponAdded
                                      .toStringAsFixed(2),
                          color2: Colors.white,
                          color1: Colors.white,
                          fontFamily: 'Roboto',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        );
                      },
                    ),
                  ),
                  Consumer<CartModel>(
                    builder: (context, cart, child) {
                      final bool _isSelected = cart.courseIdsList.length >= 1;
                      final bool _isCouponCode = cart.couponCodeList.isEmpty;
                      final bool _isCheckTerms =
                          cart.isClickedTermsAndCondition;
                      return GestureDetector(
                        onTap: () => _isSelected
                            ? _isCheckTerms
                                ? _isCouponCode
                                    ? PaymentScreen.show(
                                        context,
                                        widget.batch,
                                        database,
                                        cartModel,
                                        cart.totalCoursePrice
                                            .toStringAsFixed(2),
                                        auth.currentUser.phoneNumber.toString(),
                                      )
                                    : PaymentScreen.show(
                                        context,
                                        widget.batch,
                                        database,
                                        cartModel,
                                        cart.totalCoursePriceWhenCouponAdded
                                            .toStringAsFixed(2),
                                        auth.currentUser.phoneNumber.toString(),
                                      )
                                : null
                            : null,
                        child: Container(
                          width: 150.0,
                          height: 50.0,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: gradientText(
                              text: _isSelected ? "BUY NOW" : "Select Subject",
                              color2: _isSelected
                                  ? _isCheckTerms
                                      ? Colors.green
                                      : Colors.grey
                                  : Colors.grey,
                              color1: _isSelected
                                  ? Colors.green.shade300
                                  : Colors.green,
                              fontFamily: 'Roboto',
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _totalInvoice(BuildContext context) {
    return Consumer<CartModel>(
      builder: (context, cart, child) {
        return Stack(
          children: [
            Container(
              margin: EdgeInsets.all(15.0),
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(20.0),
                //color: Colors.green,
                // gradient: LinearGradient(
                //   begin: Alignment.centerLeft,
                //   end: Alignment.centerRight,
                //   colors: [
                //     Colors.blue.shade900,
                //     Colors.blue.shade500,
                //   ],
                // ),
                shape: BoxShape.rectangle,
              ),
              child: Column(
                children: [
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(width: 50.0),
                      Container(
                        child: gradientText(
                          text: "Price",
                          color2: Colors.black,
                          color1: Colors.black54,
                          fontFamily: 'Roboto',
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: Center(
                          child: Text(
                            "₹ " + cart.totalCourseMRPOnly.toString(),
                            style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Roboto',
                              decoration: TextDecoration.lineThrough,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 50.0),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 50.0),
                      Container(
                        child: gradientText(
                          text: "Offer Price",
                          color2: Colors.black,
                          color1: Colors.black54,
                          fontFamily: 'Roboto',
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: Center(
                          child: gradientText(
                            text: "₹ " + cart.totalCoursePrice.toString(),
                            color2: Colors.green,
                            color1: Colors.green.shade400,
                            fontFamily: 'Roboto',
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      SizedBox(width: 50.0),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  cart.couponCodeList.isEmpty
                      ? SizedBox()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: 50.0),
                            Container(
                              child: gradientText(
                                text: "After Discount Price",
                                color2: Colors.black,
                                color1: Colors.black54,
                                fontFamily: 'Roboto',
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Spacer(),
                            Container(
                              child: Center(
                                child: gradientText(
                                  text: cart.couponCodeList.isEmpty
                                      ? "₹ " + cart.totalCoursePrice.toString()
                                      : "₹ " +
                                          cart.totalCoursePriceWhenCouponAdded
                                              .toStringAsFixed(2),
                                  color2: Colors.green,
                                  color1: Colors.green.shade400,
                                  fontFamily: 'Roboto',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            SizedBox(width: 50.0),
                          ],
                        ),
                ],
              ),
            ),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.green,
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xff764ba2),
                      Color(0xff667eea),
                    ],
                  ),
                  shape: BoxShape.rectangle,
                ),
                child: Text(
                  "Your Price Detail",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _courseListTile(Database database) {
    return StreamBuilder<List<Course>>(
      stream: database.coursesStream(batchId: widget.batch.id),
      builder: (context, snapshot) {
        return ListItemsBuilder<Course>(
          snapshot: snapshot,
          itemBuilder: (context, course) => CourceListTile(
            // onTap: () {},
            course: course,
          ),
        );
      },
    );
  }

  _userStreamBuilder(Database database) {
    return StreamBuilder<UserData>(
      stream: database.UserStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final userData = snapshot.data;

          return CartPageDetail(userData: userData!);
        } else if (snapshot.hasError) {
          Container(child: Center(child: Text('Something Went Wrong !!')));
        }
        ;
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class CartPageDetail extends StatelessWidget {
  const CartPageDetail({Key? key, required this.userData}) : super(key: key);
  final UserData userData;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: gradientText(
          text: userData.userName,
          color1: Colors.black,
          color2: Colors.black,
          fontFamily: "Roboto",
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
