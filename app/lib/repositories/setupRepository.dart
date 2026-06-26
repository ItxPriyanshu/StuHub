import 'package:stuhub/databse/database_helper.dart';

class Setuprepository {
  Future<Map<String,dynamic>> getSetupStatus() async{
    final db = await DatabaseHelper.instance.database;

    final result = await db.query('app_setup',where: 'id=?',
    whereArgs: [1]);

    return result.first;
  }


  Future<void> markSessionComplete() async{
    final db = await DatabaseHelper.instance.database;

    await db.update('app_setup', {
      'session_completed': 1,
    },
    where: 'id=?',
    whereArgs: [1],
    );
  }

  Future<void> markSubjectsComplete() async{
    final db = await DatabaseHelper.instance.database;

    await db.update('app_setup', {
      'subjects_completed': 1,
    },
    where: 'id=?',
    whereArgs: [1],
    );
  }
  
  
  Future<void> markTimeTableComplete() async{
    final db = await DatabaseHelper.instance.database;

    await db.update('app_setup', {
      'timetable_completed': 1,
    },
    where: 'id=?',
    whereArgs: [1],
    );
  }


  Future<void> resetSetup() async{
  final db =
      await DatabaseHelper
          .instance
          .database;

  await db.update(
    "app_setup",
    {
      "session_completed": 0,
      "subjects_completed": 0,
      "timetable_completed": 0,
    },
    where: "id = 1",
  );
  }
}