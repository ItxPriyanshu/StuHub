import 'package:sqflite/sqlite_api.dart';
import 'package:stuhub/databse/database_helper.dart';
import 'package:stuhub/models/sessionModel.dart';

class Sessionrepository {
  Future<void> createSession(Sessionmodel session) async {
    final db = await DatabaseHelper.instance.database;

    await db.insert('session_config', {
      'id': session.id,
      'start_date': session.startDate.toIso8601String(),
      'end_date': session.endDate.toIso8601String(),
      'synced': session.synced ? 1 : 0,
      'created_at': session.createdAt.toIso8601String(),
      'updated_at': session.updatedAt.toIso8601String(),
    },
    conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Sessionmodel?> getSession() async {
  final db =
      await DatabaseHelper.instance.database;

  final result =
      await db.query('session_config');

  if (result.isEmpty) return null;

  final data = result.first;

  return Sessionmodel(
    id: data['id'] as String,
    startDate: DateTime.parse(
      data['start_date'] as String,
    ),
    endDate: DateTime.parse(
      data['end_date'] as String,
    ),
    synced: (data['synced'] as int) == 1,
    createdAt: DateTime.parse(
      data['created_at'] as String,
    ),
    updatedAt: DateTime.parse(
      data['updated_at'] as String,
    ),
  );
}


Future<void> updateSession(Sessionmodel session) async{
  final db =await DatabaseHelper.instance.database;
  await db.update("session_config", {
     "start_date":
          session.startDate
              .toIso8601String(),

      "end_date":
          session.endDate
              .toIso8601String(),

      "updated_at":
          DateTime.now()
              .toIso8601String(),

      "synced": 0,
  },
  where: "id = ?",
  whereArgs: [session.id],
  );
}


Future<void> clearSession() async{
  final db = await DatabaseHelper.instance.database;
  await db.delete("session_config");
}
}
