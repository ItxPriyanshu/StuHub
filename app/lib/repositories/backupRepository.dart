import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stuhub/databse/database_helper.dart';
import 'package:stuhub/repositories/attendanceRepository.dart';
import 'package:stuhub/repositories/sessionRepository.dart';
import 'package:stuhub/repositories/subjectRepository.dart';
import 'package:stuhub/repositories/timetableRepository.dart';
import 'package:stuhub/storage/token_storage.dart';

class Backuprepository {
  Future<void> backupAll() async {
    final session = await Sessionrepository().getSession();
    final subjects = await Subjectrepository().getSubjects();
    final timetables = await Timetablerepository().getAllTimeTables();
    final attendance = await Attendancerepository(
      DatabaseHelper.instance,
    ).getAllAttendance();

    final token = await TokenStorage.getToken();

    final response = await http.post(
      Uri.parse("https://stuhub.duckdns.org/api/sync/backup"),
      headers: {
        "Content-Type": "application/json",

        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "session": session == null
            ? null
            : {
                "id": session.id,
                "startDate": session.startDate.toIso8601String(),
                "endDate": session.endDate.toIso8601String(),
              },

        "subjects": subjects.map((e) => e.toMap()).toList(),

        "timetables": timetables.map((e) => e.toJson()).toList(),

        "attendance": attendance.map((e) => e.toMap()).toList(),
      }),
    );
    print("============backup response =========");
    print(response.statusCode);
    print(response.body);
    if (response.statusCode != 200) {
      throw Exception("Backup failed");
    }
  }
}
