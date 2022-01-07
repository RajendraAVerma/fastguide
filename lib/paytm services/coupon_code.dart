import 'package:fastguide/admin/screens/team/model/member.dart';
import 'package:fastguide/paytm%20services/cart_model.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CouponCode extends StatefulWidget {
  final Database database;
  final CartModel cartModel;

  const CouponCode({Key? key, required this.database, required this.cartModel})
      : super(key: key);

  static Future<void> show(
    BuildContext context,
    Database database,
  ) async {
    final database = Provider.of<Database>(context, listen: false);
    final cartModel = Provider.of<CartModel>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => CouponCode(
          database: database,
          cartModel: cartModel,
        ),
      ),
    );
  }

  @override
  _CouponCodeState createState() => _CouponCodeState();
}

class _CouponCodeState extends State<CouponCode> {
  TextEditingController _couponCode = TextEditingController();
  @override
  void dispose() {
    _couponCode.clear();
    super.dispose();
  }

  @override
  void initState() {
    _couponCode.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding:
            EdgeInsets.only(top: 10.0, bottom: 10.0, left: 40.0, right: 10.0),
        decoration: BoxDecoration(
          color: Colors.pink.shade200,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextFormField(
                controller: _couponCode,
                autofocus: false,
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'coupon (OPTIONAL)',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) =>
                    value!.isNotEmpty ? null : 'Can\'t be empty',
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: CartStreamBuilder(
                couponCode: _couponCode.text,
                database: widget.database,
                cartModel: widget.cartModel,
                context: context,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartStreamBuilder extends StatefulWidget {
  const CartStreamBuilder({
    Key? key,
    required this.couponCode,
    required this.database,
    required this.cartModel,
    required this.context,
  }) : super(key: key);
  final String couponCode;
  final Database database;
  final CartModel cartModel;
  final BuildContext context;
  @override
  _CartStreamBuilderState createState() => _CartStreamBuilderState();
}

class _CartStreamBuilderState extends State<CartStreamBuilder> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Member>>(
      stream: widget.database.membersStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            final memberList = snapshot.data;

            final _checkingMember = memberList!
                .map((item) => item.couponCode)
                .contains(widget.couponCode);

            if (_checkingMember) {
              final memberIter = memberList.where(
                  (oldValue) => widget.couponCode == (oldValue.couponCode));

              return AppyButton(
                memberIter: memberIter,
              );
            } else {
              Future.delayed(Duration.zero, () async {
                widget.cartModel.removeAllCouponCodeOff();
                widget.cartModel.removeCodeRedeemUser();
              });

              if (widget.couponCode.isNotEmpty) {
                return Text(
                  "NOT MATCHED!!",
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.red,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                );
              }

              return Text(
                "Any Coupon Code ?",
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              );
            }
          } else if (snapshot.hasError) {
            Container(child: Center(child: Text('Something Went Wrong !!')));
          }
          ;
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Text("Wait..."),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          return Center(
            child: Text("Network Error !!"),
          );
        } else {
          return Center(
            child: Text("Something Went Wrong"),
          );
        }
      },
    );
  }
}

class AppyButton extends StatefulWidget {
  const AppyButton({
    Key? key,
    this.onTap,
    required this.memberIter,
  }) : super(key: key);
  final Function? onTap;
  final Iterable<Member> memberIter;

  @override
  _AppyButtonState createState() => _AppyButtonState();
}

class _AppyButtonState extends State<AppyButton> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<CartModel>(
      builder: (context, cart, child) {
        bool _isTotalIsMore = cart.courseIdsList.length >= 2;
        return _isTotalIsMore
            ? RaisedButton(
                color: _isSelected ? Colors.green : Colors.blue,
                child: _isSelected
                    ? Text(
                        "Applied! 😉",
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500),
                      )
                    : Text(
                        "Apply",
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500),
                      ),
                onPressed: () {
                  setState(() {
                    _isSelected = !_isSelected;
                  });

                  !_isSelected
                      ? cart.addCouponCodeOff(
                          -widget.memberIter.first.percentage.toDouble())
                      : cart.addCouponCodeOff(
                          widget.memberIter.first.percentage.toDouble());

                  _isSelected
                      ? cart.addCodeRedeemUser(widget.memberIter.first)
                      : cart.removeCodeRedeemUser();
                })
            : FlatButton(
                onPressed: () {},
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Applied For Two Course Only !!",
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
