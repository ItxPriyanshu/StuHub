import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stuhub/providers/actionRequiredProvider.dart';
import 'package:stuhub/providers/analyticsProvider.dart';
import 'package:stuhub/providers/attendanceTrendProvider.dart';
import 'package:stuhub/providers/attendance_Provider.dart';
import 'package:stuhub/providers/calendarProvider.dart';
import 'package:stuhub/providers/editTimeTableProvider.dart';
import 'package:stuhub/providers/homeProvider.dart';
import 'package:stuhub/providers/manageSubjectProvider.dart';
import 'package:stuhub/providers/sessionProvider.dart';
import 'package:stuhub/providers/subjectProvider.dart';
import 'package:stuhub/providers/userProfileProvider.dart';

class ApprefreshServiceProvider {
  static void refreshAll(WidgetRef ref){
    ref.invalidate(subjectProvider);
    ref.invalidate(manageSubjectProvider);

    ref.invalidate(todayClassesProvider);

    ref.invalidate(subjectHealthProvider);
    ref.invalidate(analyticsProvider);

    ref.invalidate(AttendancetrendProvider);

    ref.invalidate(calendarProvider);

    ref.invalidate(actionRequiredProvider);

    ref.invalidate(sessionProvider);

    ref.invalidate(allTimetableProvider);

    ref.invalidate(userProfileProvider);
  }
}