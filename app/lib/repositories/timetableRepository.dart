import 'package:sqflite/sqflite.dart';
import 'package:stuhub/databse/database_helper.dart';
import 'package:stuhub/models/timeTableModel.dart';

class Timetablerepository {
  Future<void> createTimeTable(Timetablemodel timetable) async {
    final db = await DatabaseHelper.instance.database;

    await db.insert('timetable', {
      'id': timetable.id,
      'subject_id': timetable.subjectId,
      'weekday': timetable.weekday,
      'class_count': timetable.classCount,
      'synced': timetable.synced ? 1 : 0,
      'created_at': timetable.createdAt.toIso8601String(),
      'updated_at': timetable.updatedAt.toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Timetablemodel>> getAllTimeTables() async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query('timetable');

    return result.map((e) {
      return Timetablemodel(
        id: e['id'] as String,
        subjectId: e['subject_id'] as String,
        weekday: e['weekday'] as int,
        classCount: e['class_count'] as int,
        synced: (e['synced'] as int) == 1,
        createdAt: DateTime.parse(e['created_at'] as String),
        updatedAt: DateTime.parse(e['updated_at'] as String),
      );
    }).toList();
  }

  //get time table by day
  Future<List<Timetablemodel>> getTimetableByDay(int weekday) async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query(
      "timetable",
      where: 'weekday = ?',
      whereArgs: [weekday],
    );

    return result.map((e) {
      return Timetablemodel(
        id: e['id'] as String,
        subjectId: e['subject_id'] as String,
        weekday: e['weekday'] as int,
        classCount: e['class_count'] as int,
        synced: (e['synced'] as int) == 1,
        createdAt: DateTime.parse(e['created_at'] as String),
        updatedAt: DateTime.parse(e['updated_at'] as String),
      );
    }).toList();
  }

  Future<void> updateTimeTable(Timetablemodel timetable) async {
    final db = await DatabaseHelper.instance.database;

    await db.update(
      "timetable",
      {
        "weekday": timetable.weekday,

        "class_count": timetable.classCount,

        "updated_at": DateTime.now().toIso8601String(),

        "synced": 0,
      },
      where: "id = ?",
      whereArgs: [timetable.id],
    );
  }

  Future<void> clearTimetable() async {
    final db = await DatabaseHelper.instance.database;
    await db.delete("timetable");
  }

  Future<void> saveTimetable(List<Timetablemodel> timetables) async {
    final db = await DatabaseHelper.instance.database;

    final batch = db.batch();
    for (final timetable in timetables) {
      batch.insert("timetable", timetable.toMap());
    }
    await batch.commit(noResult: true);
  }

  
}
