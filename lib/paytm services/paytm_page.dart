import 'package:flutter/material.dart';


class MyPaytmPage extends StatefulWidget {
  @override
  _MyPaytmPageState createState() => _MyPaytmPageState();
}

class _MyPaytmPageState extends State<MyPaytmPage> {
  TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Paytm Payments"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: "Enter Amount", border: UnderlineInputBorder()),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          MaterialButton(
            onPressed: () {
              //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PaymentScreen(amount: _amountController.text,)));
            },
            color: Colors.blue,
            child: Text(
              "Proceed to Checkout",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
