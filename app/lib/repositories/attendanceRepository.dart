import 'package:sqflite/sqflite.dart';
import 'package:stuhub/databse/database_helper.dart';
import 'package:stuhub/models/attendanceModel.dart';
import 'package:stuhub/repositories/sessionRepository.dart';

class Attendancerepository {
  final DatabaseHelper _databaseHelper;

  Attendancerepository(this._databaseHelper);

  Future<Database> get _db async => await _databaseHelper.database;

  // mark attendance
  Future<void> markAttendance({required Attendancemodel attendance}) async {
    final session = await Sessionrepository().getSession();
    if(session == null){
      throw Exception("No active session");
    }
    final today = DateTime.now();
    final sessionStart = DateTime(session.startDate.year,session.startDate.month,session.startDate.day);
    if(today.isBefore(sessionStart)){
      throw Exception("Session has not started yet");
    }
    final db = await _db;

    final existing = await db.query(
      "attendance",
      where: "subjectId=? AND date = ?",
      whereArgs: [attendance.subjectId, attendance.date],
    );

    if (existing.isEmpty) {
      await db.insert("attendance", attendance.toMap());
    } else {
      await db.update(
        "attendance",
        attendance.toMap(),

        where: "subjectId = ? AND date = ?",
        whereArgs: [attendance.subjectId, attendance.date],
      );
    }
  }

  //get all

  Future<List<Attendancemodel>> getAllAttendance() async {
    final db = await _db;

    final result = await db.query("attendance", orderBy: "date DESC");

    return result.map((e) => Attendancemodel.fromMap(e)).toList();
  }

  //get by date

  Future<List<Attendancemodel>> getAttendanceByDate(String date) async {
    final db = await _db;

    final result = await db.query(
      "attendance",
      where: "date = ?",
      whereArgs: [date],
    );

    return result.map((e) => Attendancemodel.fromMap(e)).toList();
  }

  //get by subject

  Future<List<Attendancemodel>> getAttendanceBySubject(String subjectId) async {
    final db = await _db;
    final result = await db.query(
      "attendance",
      where: "subjectId = ?",
      whereArgs: [subjectId],
      orderBy: "date DESC",
    );

    return result.map((e) => Attendancemodel.fromMap(e)).toList();
  }

  //get single record
  Future<Attendancemodel?> getAttendanceRecord({
    required String subjectId,
    required String date,
  }) async {
    final db = await _db;
    final result = await db.query(
      "attendance",
      where: "subjectId = ? AND date = ?",
      whereArgs: [subjectId, date],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return Attendancemodel.fromMap(result.first);
  }

  //delete one
  Future<void> deleteAttendance(String id) async {
    final db = await _db;

    await db.delete("attendance", where: "id = ?", whereArgs: [id]);
  }

  //clear all

  Future<void> clearAttendance() async {
    final db = await _db;

    await db.delete("attendance");
  }



  //is attendance marked
  Future<bool> isAttendanceMarked({
  required String subjectId,
  required String date,
}) async {
  final db = await _db;

  final result = await db.query(
    "attendance",
    where: "subjectId = ? AND date = ?",
    whereArgs: [subjectId, date],
    limit: 1,
  );

  return result.isNotEmpty;
}
}
