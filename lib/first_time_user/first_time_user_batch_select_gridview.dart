// import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
// import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
// import 'package:fastguide/login/data_models/user_class_model.dart';
// import 'package:fastguide/services/database.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class BatchListTileForFirstTimeUser extends StatefulWidget {
//   const BatchListTileForFirstTimeUser({
//     Key? key,
//     required this.batch,
//   }) : super(key: key);
//   final Batch? batch;

//   @override
//   _BatchListTileForFirstTimeUserState createState() =>
//       _BatchListTileForFirstTimeUserState();
// }

// class _BatchListTileForFirstTimeUserState
//     extends State<BatchListTileForFirstTimeUser> {
//   @override
//   Widget build(BuildContext context) {
//     return _listTile(context);
//   }

//   bool _isClicked = false;
//   Widget _listTile(BuildContext context) {
//     return ListTile(
//       tileColor: _isClicked ? Colors.red : Colors.blue,
//       leading: Container(
//         width: 50,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           image: DecorationImage(
//             alignment: Alignment.center,
//             image: NetworkImage(widget.batch!.boxIconLink, scale: 5.0),
//           ),
//         ),
//       ),
//       title: Text(widget.batch!.batchName),
//       //subtitle: _isAddedClass(context),
//       trailing: Icon(Icons.check),
//       onTap: () {
//         setState(() {
//           _isClicked = !_isClicked;
//         });
//         return _addToClass(context);
//       },
//     );
//   }

//   _addToClass(BuildContext context) async {
//     final database = Provider.of<Database>(context, listen: false);
//     final userClassData = UserClassData(
//       id: "userClassDoc",
//       userClass: "${widget.batch!.id}",
//     );
//     await database.setUserClass(userClassData: userClassData);
//     print('ADDED To Class');
//   }

//   _isAddedClass(BuildContext context) {
//     final database = Provider.of<Database>(context, listen: false);
//     return StreamBuilder<List<UserClassData>>(
//       stream: database.UsersClassStream(),
//       builder: (context, snapshot) {
//         final userClassData = snapshot.data;
//         final userClass = userClassData?.first;
//         final uC = userClass?.id;

//         if (snapshot.hasData) {
//           StreamBuilder<UserClassData>(
//             stream: database.UserClassStream(userClassData: userClass!),
//             builder: (context, snapshot) {
//               final userClassDoc = snapshot.data;
//               final userClassDocId = userClassDoc?.userClass;
//               if (snapshot.hasData) {
//                 return Container(
//                   width: double.infinity,
//                   child: RaisedButton(
//                     onPressed: () async {
//                       final userClassData = UserClassData(
//                         id: "userClassDoc",
//                         userClass: "${widget.batch!.id}",
//                       );
//                       await database.setUserClass(userClassData: userClassData);
//                       print('ADDED To Class');
//                     },
//                     child: userClassDocId == widget.batch!.id
//                         ? Text("ADDED")
//                         : Text('Add To Class'),
//                   ),
//                 );
//               } else if (snapshot.hasError) {
//                 Container(
//                     child: Center(child: Text('Something Went Wrong !!')));
//               }

//               return Center(child: CircularProgressIndicator());
//             },
//           );
//         } else if (snapshot.hasError) {
//           Container(child: Center(child: Text('Something Went Wrong !!')));
//         }
//         ;
//         return Center(child: CircularProgressIndicator());
//       },
//     );
//   }
// }
