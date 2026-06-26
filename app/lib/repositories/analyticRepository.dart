import 'package:intl/intl.dart';
import 'package:stuhub/databse/database_helper.dart';
import 'package:stuhub/models/analyticsModel.dart';
import 'package:stuhub/models/attendanceModel.dart';
import 'package:stuhub/models/attendanceTrendPoint.dart';
import 'package:stuhub/models/calendarDayModel.dart';
import 'package:stuhub/models/subjectHealthModel.dart';
import 'package:stuhub/repositories/attendanceRepository.dart';
import 'package:stuhub/repositories/sessionRepository.dart';
import 'package:stuhub/repositories/subjectRepository.dart';

class Analyticrepository {
  final Subjectrepository subjectRepo = Subjectrepository();
  final Attendancerepository attendanceRepo = Attendancerepository(
    DatabaseHelper.instance,
  );

  Future<List<Subjecthealthmodel>> getSubjectHealth() async {
    final subjects = await subjectRepo.getSubjects();

    List<Subjecthealthmodel> healthList = [];

    for (final subject in subjects) {
      final attendanceRecords = await attendanceRepo.getAttendanceBySubject(
        subject.id,
      );

      int present = 0;
      int absent = 0;
      int holiday = 0;

      for (final record in attendanceRecords) {
        if (record.status == "present") {
          present += record.attendedClasses;
        } else if (record.status == "absent") {
          absent += record.totalClasses;
        } else if (record.status == "holiday") {
          holiday += record.totalClasses;
        }
      }

      final totalConsidered = present + absent;
      final double percentage = totalConsidered == 0
          ? 0
          : (present / totalConsidered) * 100;

      healthList.add(
        Subjecthealthmodel(
          subjectId: subject.id,
          subjectName: subject.name,
          presentClasses: present,
          absentClasses: absent,
          holidayClasses: holiday,
          attendancePercentage: percentage,
        ),
      );
    }
    return healthList;
  }

  Future<bool> hasActionRequired() async {
    final session =  await Sessionrepository().getSession();
      if (session == null) {
    return false;
  }
    final today = DateTime.now();

  final sessionStart = DateTime(
    session.startDate.year,
    session.startDate.month,
    session.startDate.day,
  );
    if (today.isBefore(sessionStart)) {
    return false;
  }
    final health = await getSubjectHealth();

    final subjects = await Subjectrepository().getSubjects();

    for (final subject in subjects) {
      final healthData = health.firstWhere((e) => e.subjectId == subject.id);
      if (healthData.attendancePercentage < subject.requiredAttendance) {
        return true;
      }
    }
    return false;
  }

  Future<Analyticsmodel?> getAnalytics(String subjectId) async {
    final subject = await subjectRepo.getSubjectById(subjectId);
    if (subject == null) {
      return null;
    }

    final records = await attendanceRepo.getAttendanceBySubject(subjectId);

    int present = 0;
    int absent = 0;
    int holiday = 0;
    for (final record in records) {
      switch (record.status) {
        case "present":
          present += record.attendedClasses;
          break;

        case "absent":
          absent += record.totalClasses;
          break;

        case "holiday":
          holiday += record.totalClasses;
          break;
      }
    }

    final total = present + absent;
    final double percentage = total == 0 ? 0 : (present / total) * 100;

    int canMiss = 0;
    if (percentage >= subject.requiredAttendance) {
      while (true) {
        final nextPercentage = (present) / (total + canMiss + 1) * 100;

        if (nextPercentage < subject.requiredAttendance) {
          break;
        }
        canMiss++;
      }
    }
    int needToAttend = 0;
    if (percentage < subject.requiredAttendance) {
      while (true) {
        final nextPercentage =
            ((present + needToAttend + 1) / (total + needToAttend + 1)) * 100;
        if (nextPercentage >= subject.requiredAttendance) {
          needToAttend++;
          break;
        }
        needToAttend++;
      }
    }
    return Analyticsmodel(
      subjectId: subject.id,
      subjectName: subject.name,
      present: present,
      absent: absent,
      holiday: holiday,
      totalClasses: total,
      attendancePercentage: percentage,
      canMiss: canMiss,
      needToAttend: needToAttend,
    );
  }

  Future<List<Attendancetrendpoint>> getAttendanceTrend(
    String subjectId,
  ) async {
    final records = await attendanceRepo.getAttendanceBySubject(subjectId);

    records.sort(
      (a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)),
    );

    List<Attendancetrendpoint> trend = [];

    int present = 0;
    int absent = 0;
    for (final record in records) {
      if (record.status == "present") {
        present += record.attendedClasses;
      }

      if (record.status == "absent") {
        absent += record.totalClasses;
      }
      final total = present + absent;
      final double percentage = total == 0 ? 0 : (present / total) * 100;

      trend.add(
        Attendancetrendpoint(
          label: DateFormat('dd MMM').format(DateTime.parse(record.date)),
          percentage: percentage,
        ),
      );
    }

    return trend;
  }

  Future<List<Calendardaymodel>> getCalendarMonth(
    String subjectId,
    DateTime month,
  ) async {
    final session = await Sessionrepository().getSession();

    if (session == null) {
      return [];
    }

    final attendance = await attendanceRepo.getAttendanceBySubject(subjectId);

    final firstDay = DateTime(month.year, month.month, 1);

    final startWeekday = firstDay.weekday % 7;

    final gridStart = firstDay.subtract(Duration(days: startWeekday));

    List<Calendardaymodel> days = [];

    for (int i = 0; i < 42; i++) {
      final current = gridStart.add(Duration(days: i));

      Attendancemodel? record;

      try {
        record = attendance.firstWhere((e) {
          final date = DateTime.parse(e.date);

          return date.year == current.year &&
              date.month == current.month &&
              date.day == current.day;
        });
      } catch (_) {}

      days.add(
        Calendardaymodel(
          date: current,

          inCurrentMonth: current.month == month.month,

          inSession:
              !current.isBefore(session.startDate) &&
              !current.isAfter(session.endDate),

          status: record?.status,

          classCount: record?.totalClasses ?? 0,
        ),
      );
    }

    return days;
  }
}
