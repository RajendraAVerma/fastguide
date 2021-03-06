import 'package:fastguide/login/firebase/auth/phone_auth/select_country.dart';
import 'package:flutter/material.dart';

import '../data_models/country.dart';

class PhoneAuthWidgets {
  static Widget getLogo({String? logoPath, double? height}) => Material(
        type: MaterialType.transparency,
        elevation: 10.0,
        child: Image.asset(logoPath!, height: height),
      );
}

class SearchCountryTF extends StatelessWidget {
  final TextEditingController? controller;

  const SearchCountryTF({Key? key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 2.0, right: 8.0),
      child: Card(
        child: TextFormField(
          autofocus: false,
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Search your country',
            contentPadding: const EdgeInsets.only(
                left: 5.0, right: 5.0, top: 10.0, bottom: 10.0),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

class PhoneNumberField extends StatelessWidget {
  final TextEditingController? controller;
  final String? prefix;

  const PhoneNumberField({Key? key, this.controller, this.prefix})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.blue.shade100,
      ),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => SelectCountry()),
            ),
            child: Container(
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.0),
                    bottomLeft: Radius.circular(5.0)),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.indigo,
                    Colors.blue,
                  ],
                ),
                shape: BoxShape.rectangle,
              ),
              child: Center(
                child: Text(
                  "     " + prefix! + "     ",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: TextFormField(
              style: TextStyle(
                fontSize: 18.0,
                fontFamily: "Roboto",
                fontWeight: FontWeight.w500,
              ),
              controller: controller,
              autofocus: false,
              keyboardType: TextInputType.phone,
              key: Key('EnterPhone-TextFormField'),
              decoration: InputDecoration(
                border: InputBorder.none,
                errorMaxLines: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SubTitle extends StatelessWidget {
  final String? text;

  const SubTitle({Key? key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Text(' $text',
            style: TextStyle(color: Colors.black, fontSize: 14.0)));
  }
}

class ShowSelectedCountry extends StatelessWidget {
  final VoidCallback? onPressed;
  final Country? country;

  const ShowSelectedCountry({Key? key, this.onPressed, this.country})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 4.0, right: 4.0, top: 8.0, bottom: 8.0),
          child: Row(
            children: <Widget>[
              Expanded(child: Text('${country!.dialCode}')),
              Icon(Icons.arrow_drop_down, size: 24.0)
            ],
          ),
        ),
      ),
    );
  }
}

class SelectableWidget extends StatelessWidget {
  final Function(Country)? selectThisCountry;
  final Country? country;

  const SelectableWidget({Key? key, this.selectThisCountry, this.country})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      type: MaterialType.canvas,
      child: InkWell(
        onTap: () => selectThisCountry!(country!), //selectThisCountry(country),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "  " +
                country!.flag! +
                "  " +
                country!.name! +
                " (" +
                country!.dialCode! +
                ")",
            style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
