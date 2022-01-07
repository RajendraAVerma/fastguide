import 'package:fastguide/admin/admin_dashboard/widgets/appbar.dart';
import 'package:fastguide/admin/admin_dashboard/widgets/total_member_meter.dart';
import 'package:fastguide/admin/admin_dashboard/widgets/total_payment_meter.dart';
import 'package:fastguide/admin/admin_dashboard/widgets/total_student_meter.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(context),
      body: Container(
        child: Column(
          children: [
            totalStudentMeter(context),
            totalMemberMeter(context),
           // Expanded(child: totalPaymentMeter(context)),
          ],
        ),
      ),
    );
  }
}
