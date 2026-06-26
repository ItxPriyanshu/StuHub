import 'package:flutter/material.dart';
import 'package:stuhub/widgets/analytics/analytics_header.dart';
import 'package:stuhub/widgets/analytics/attendanceTrend_card.dart';
import 'package:stuhub/widgets/analytics/attendance_score_card.dart';
import 'package:stuhub/widgets/analytics/custom_calendar.dart';
import 'package:stuhub/widgets/analytics/stats_row.dart';
import 'package:stuhub/widgets/analytics/status_overview_card.dart';
import 'package:stuhub/widgets/analytics/subject_dropdown.dart';

class Analyticscreen extends StatelessWidget {
  const Analyticscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            children: const [
              AnalyticsHeader(),
              SizedBox(height: 20),
              SubjectDropdown(),
              SizedBox(height: 20),
              AttendanceScoreCard(),
              SizedBox(height: 20),
              StatusOverviewCard(),
              SizedBox(height: 20),
              StatsRow(),
              SizedBox(height: 20),
              AttendancetrendCard(),
              SizedBox(height: 20),
              CustomCalendar(),
            ],
          ),
        ),
      ),
    );
  }
}
