import 'package:cached_network_image/cached_network_image.dart';
import 'package:fastguide/admin/screens/admin_home/models/batches.dart';
import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
import 'package:fastguide/login/data_models/user_class_model.dart';
import 'package:fastguide/login/data_models/user_model.dart';
import 'package:fastguide/paytm%20services/cart_page.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class BatchListTile extends StatelessWidget {
  const BatchListTile({Key? key, required this.batch, this.onTap})
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
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
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
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 100.0,
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.white,
                          Colors.white,
                        ],
                      ),
                    ),
                    child: Center(
                      child: CachedNetworkImage(
                        imageUrl: batch!.boxIconLink,
                        imageBuilder: (context, imageProvider) =>
                            Image(image: imageProvider),
                        placeholder: (context, url) => SizedBox(
                          height: 50.0,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey.shade400,
                            highlightColor: Colors.white,
                            child: Image(
                              height: 50.0,
                              image: AssetImage(
                                  "assets/images/image_placeholder.png"),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image(
                            height: 100.0,
                            image: AssetImage(
                                "assets/images/image_placeholder.png"),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20.0),
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
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          child: SizedBox(
                            width: 200.0,
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
                            _isAddedClass(context, userData),
                          ],
                        ),
                        gradientText(
                          text: "1 Year Full Course",
                          color2: Colors.white,
                          color1: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 15.0),
            Row(
              children: [
                GestureDetector(
                  onTap: () => CartPage.show(context, batch!),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.green,
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.white24,
                            Colors.white24,
                          ],
                        ),
                        shape: BoxShape.rectangle,
                      ),
                      height: 50.0,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10.0),
                            gradientText(
                              text: "BUY NOW",
                              color2: Colors.white,
                              color1: Colors.white,
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
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
                                Icons.subscriptions_outlined,
                                color: Color(themeColor1Int),
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Expanded(
                              flex: 6,
                              child: gradientText(
                                text: "Demo Class",
                                color2: Color(themeColor1Int),
                                color1: Color(themeColor2Int),
                                fontFamily: 'Roboto',
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
              ],
            )
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
        userClassData: userClassData,);
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
