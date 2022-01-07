import 'package:fastguide/login/data_models/user_device_model.dart';
import 'package:fastguide/login/data_models/user_model.dart';
import 'package:fastguide/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserdevicePage extends StatelessWidget {
  const UserdevicePage({Key? key, required this.userData}) : super(key: key);
  final UserData userData;

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<UserDeviceData>(
      stream: database.userDeviceStream(userData: userData),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final userDeviceData = snapshot.data;
          return _buildContent(userDeviceData!);
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Something Went Wrong !!"),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Container _buildContent(UserDeviceData userDeviceData) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Android Id"),
                Text(
                  userDeviceData.androidId.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Device Manufacture"),
                Text(
                  userDeviceData.deviceManufacture,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Device Model"),
                Text(
                  userDeviceData.deviceModel,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Last Login"),
                Text(
                  userDeviceData.lastLogin,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
