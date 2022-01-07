import 'package:fastguide/app/widgets/all_type_text_widget.dart/gradientText.dart';
import 'package:flutter/material.dart';
import 'package:new_version/new_version.dart';

class NewVersionReminder extends StatefulWidget {
  @override
  _NewVersionReminderState createState() => _NewVersionReminderState();
}

class _NewVersionReminderState extends State<NewVersionReminder> {
  final newVersionA = NewVersion(
    androidId: 'com.fastguide.fastguide',
  );

  @override
  void initState() {
    super.initState();
  }

  basicStatusCheck(NewVersion newVersion) {
    newVersion.showAlertIfNecessary(context: context);
  }

  Future<VersionStatus?> checkNewVersion() async {
    final status = await newVersionA.getVersionStatus();
    return status;
  }

  advancedStatusCheck(NewVersion newVersion) async {
    final status = await newVersion.getVersionStatus();
    debugPrint(status!.releaseNotes);
    debugPrint(status.appStoreLink);
    debugPrint(status.localVersion);
    debugPrint(status.storeVersion);
    debugPrint(status.canUpdate.toString());
    newVersion.showUpdateDialog(
      allowDismissal: true,
      context: context,
      versionStatus: status,
      dismissButtonText: "Cancel",
      dialogTitle: 'Update Available',
      dialogText: 'नीचे अपडेट पर क्लिक करें |',
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: checkNewVersion(),
        builder: (BuildContext context, AsyncSnapshot<VersionStatus?> status) {
          if (status.hasData) {
            if (status.data!.storeVersion != status.data!.localVersion) {
              return Container(
                margin: EdgeInsets.only(top: 15.0),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(5.0),
                  shape: BoxShape.rectangle,
                ),
                child: Column(
                  children: [
                    gradientText(
                      text: "FastGuide App का नया Version अपडेट करें 😀",
                      color1: Colors.black87,
                      color2: Colors.black87,
                      fontFamily: "Mukta",
                      fontSize: 17.0,
                    ),
                    RaisedButton(
                      color: Colors.redAccent,
                      onPressed: () => advancedStatusCheck(newVersionA),
                      child: Text(
                        "Update Now",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: "Poppins",
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    gradientText(
                      text:
                          "* यदि आपने अभी तक अपडेट नहीं किया है, तो आप नई सुविधा का लाभ नहीं उठा पाएंगे। इसलिए अभी ऐप को अपडेट करें | ",
                      color1: Colors.black87,
                      color2: Colors.black87,
                      fontFamily: "Mukta",
                      fontSize: 15.0,
                    ),
                    SizedBox(height: 10.0),
                    gradientText(
                      text: 'New Version : ' +
                          status.data!.storeVersion.toString(),
                      color1: Colors.black87,
                      color2: Colors.black87,
                      fontFamily: "Mukta",
                      fontSize: 14.0,
                    ),
                    gradientText(
                      text:
                          'Your Current Version : ' + status.data!.localVersion,
                      color1: Colors.black87,
                      color2: Colors.black87,
                      fontFamily: "Mukta",
                      fontSize: 14.0,
                    ),
                  ],
                ),
              );
            }
            return Container();
          } else if (status.hasError) {
            return gradientText(
              text: "No Internet Connection !!",
              color1: Colors.red,
              color2: Colors.redAccent,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            );
          }
          return Container();
        });
  }
}
