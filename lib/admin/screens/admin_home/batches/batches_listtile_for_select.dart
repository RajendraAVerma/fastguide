import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
import 'package:fastguide/login/data_models/user_class_model.dart';
import 'package:fastguide/login/data_models/user_model.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BatchListTileForSelect extends StatelessWidget {
  const BatchListTileForSelect({Key? key, required this.batch, this.onTap})
      : super(key: key);
  final Batch? batch;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<UserData?>(
      stream: database.UserStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final userData = snapshot.data;
          return _listTile(context, userData!);
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _listTile(BuildContext context, UserData userData) {
    String themeColor1FromFirebase = batch!.themeColor1;
    int themeColor1Int = int.parse(themeColor1FromFirebase);
    String themeColor2FromFirebase = batch!.themeColor2;
    int themeColor2Int = int.parse(themeColor2FromFirebase);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(5.0),
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.green,
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(themeColor1Int),
              Color(themeColor2Int),
            ],
          ),
          shape: BoxShape.rectangle,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        gradientText(
                          text: batch!.batchName,
                          color2: Colors.white,
                          color1: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          child: SizedBox(
                            width: 100.0,
                            child: Divider(
                              thickness: 1.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            gradientText(
                              text: batch!.tag,
                              color2: Colors.white,
                              color1: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _addToClass(context, userData),
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.white,
                                Colors.white,
                              ],
                            ),
                            shape: BoxShape.rectangle,
                          ),
                          height: 50.0,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Icon(
                                    Icons.add,
                                    color: Color(themeColor1Int),
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Expanded(
                                  flex: 5,
                                  child: gradientText(
                                    text: "इसे चुने",
                                    color2: Color(themeColor1Int),
                                    color1: Color(themeColor2Int),
                                    fontFamily: 'mukta',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _addToClass(BuildContext context, UserData userData) async {
    final database = Provider.of<Database>(context, listen: false);
    final userClassData = UserClassData(
      id: "userClassDoc",
      userClass: "${batch!.id}",
    );
    await database.setUserClass(
        userClassData: userClassData, );
    print('ADDED To Class');
  }

  _isAddedClass(BuildContext context, UserData userData) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<UserClassData>>(
      stream: database.UsersClassStream(userData: userData),
      builder: (context, snapshot) {
        final userClassData = snapshot.data;
        final userClass = userClassData?.first;
        if (snapshot.hasData) {
          return StreamBuilder<UserClassData>(
            stream: database.UserClassStream(
                userClassData: userClass!, userData: userData),
            builder: (context, snapshot) {
              final userClassDoc = snapshot.data;
              final userClassDocId = userClassDoc?.userClass;
              return Container(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => _addToClass(context, userData),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () => _addToClass(context, userData),
                        icon: userClassDocId == batch!.id
                            ? Icon(Icons.verified_rounded, color: Colors.white)
                            : Icon(Icons.add_circle_rounded,
                                color: Colors.white),
                      ),
                      Container(
                        child: userClassDocId == batch!.id
                            ? Text(
                                "My Class",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Add To Class',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          Container(
              child: Center(child: Text('Something Went Wrong in Course!!')));
        }
        ;
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
