import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
import 'package:fastguide/login/data_models/user_model.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget totalStudentMeter(BuildContext context) {
  Widget _totalStudent(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<UserData>>(
      stream: database.UsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final totalStudent = snapshot.data!.length.toString();
          return Text(
            totalStudent,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Poppins',
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
          );
        } else if (snapshot.hasError) {
          return Text("Error in Snapshot");
        }
        ;
        return CircularProgressIndicator();
      },
    );
  }

  List<Widget> _columnList(BuildContext context) {
    return <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: gradientText(
              text: "Total Student Registered : ",
              color1: Colors.green.shade800,
              color2: Colors.lightGreen.shade700,
              fontFamily: "Poppins",
              fontSize: 15.0,
            ),
          ),
          _totalStudent(context),
        ],
      ),
    ];
  }

  return Container(
    margin: EdgeInsets.all(15.0),
    padding: EdgeInsets.all(20.0),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.blueAccent),
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: _columnList(context),
    ),
  );
}
