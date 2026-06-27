import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stuhub/databse/database_helper.dart';
import 'package:stuhub/models/attendanceModel.dart';
import 'package:stuhub/models/sessionModel.dart';
import 'package:stuhub/models/subjectModel.dart';
import 'package:stuhub/models/timeTableModel.dart';
import 'package:stuhub/repositories/attendanceRepository.dart';
import 'package:stuhub/repositories/sessionRepository.dart';
import 'package:stuhub/repositories/subjectRepository.dart';
import 'package:stuhub/repositories/timetableRepository.dart';
import 'package:stuhub/storage/token_storage.dart';

class Restorerepository {
  Future<void> restoreAll() async {
    final token = await TokenStorage.getToken();

    final response = await http.get(
      Uri.parse("https://stuhub-backend-v3h7.onrender.com/api/sync/restore"),
      headers: {"Authorization": "Bearer $token"},
    );
    print("========== RESTORE RESPONSE ==========");
print(response.statusCode);
print(response.body);
    if (response.statusCode != 200) {
      throw Exception("Restore failed");
    }

    final data = jsonDecode(response.body);

    final sessionRepo = Sessionrepository();
    final subjectRepo = Subjectrepository();

    final timetableRepo = Timetablerepository();

    final attendanceRepo = Attendancerepository(DatabaseHelper.instance);

    //clear local SQlite

    await attendanceRepo.clearAttendance();

    await timetableRepo.clearTimetable();

    await subjectRepo.clearSubjects();

    await sessionRepo.clearSession();

    print(response.body);

    //restore session
    if (data["session"] != null) {
      final session = data["session"];

      await sessionRepo.createSession(
        Sessionmodel(
          id: session["_id"],

          startDate: DateTime.parse(session["startDate"]).toLocal(),

          endDate: DateTime.parse(session["endDate"]).toLocal(),

          synced: true,

          createdAt: DateTime.now(),

          updatedAt: DateTime.now(),
        ),
      );
    }

    // Restore Subjects
    final subjects = data["subjects"] ?? [];
    for (final subject in subjects) {
      await subjectRepo.createSubject(
        Subjectmodel(
          id: subject["_id"],

          name: subject["name"],

          requiredAttendance: subject["requiredAttendance"].toDouble(),

          synced: true,

          createdAt: DateTime.now(),

          updatedAt: DateTime.now(),
        ),
      );
    }

    // Restore Timetable
    final timetables = data["timetables"] ?? [];
    for (final timetable in timetables) {
      await timetableRepo.createTimeTable(
        Timetablemodel(
          id: timetable["_id"],

          subjectId: timetable["subjectId"],

          weekday: timetable["weekday"],

          classCount: timetable["classCount"],

          synced: true,

          createdAt: DateTime.now(),

          updatedAt: DateTime.now(),
        ),
      );
    }


    // Restore Attendance
    final attendances = data["attendance"] ?? [];
    for (final record in attendances) {
      await attendanceRepo.markAttendance(
        attendance: Attendancemodel(
          id: record["_id"],

          subjectId: record["subjectId"],

          date: record["date"] ?? "",

          totalClasses: record["totalClasses"],

          attendedClasses: record["attendedClasses"],

          status: record["status"] ?? "",

          createdAt: DateTime.now(),

          updatedAt: DateTime.now(),
        ),
      );
    }
  }
}
