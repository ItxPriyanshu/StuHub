import 'package:sqflite/sqflite.dart';
import 'package:stuhub/databse/database_helper.dart';
import 'package:stuhub/models/subjectModel.dart';

class Subjectrepository {
  Future<void> createSubject(Subjectmodel subject) async {
    final db = await DatabaseHelper.instance.database;

    await db.insert('subjects', {
      'id': subject.id,
      'name': subject.name,
      'required_attendance': subject.requiredAttendance,
      'synced': subject.synced ? 1 : 0,
      'created_at': subject.createdAt.toIso8601String(),
      'updated_at': subject.updatedAt.toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Subjectmodel>> getSubjects() async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query('subjects');

    return result.map((e) {
      return Subjectmodel(
        id: e['id'] as String,
        name: e['name'] as String,
        requiredAttendance: (e['required_attendance'] as num).toDouble(),
        synced: (e['synced'] as int) == 1,
        createdAt: DateTime.parse(e['created_at'] as String),
        updatedAt: DateTime.parse(e['updated_at'] as String),
      );
    }).toList();
  }


//DELETE METHOD
  Future<void> deleteSubject(String subjectId) async {
    final db = await DatabaseHelper.instance.database;

    await db.transaction((txn)async {
      await txn.delete("attendance",
      where: "subjectId = ?",
      whereArgs: [subjectId],
      );

      await txn.delete("timetable",
      where: "Subject_id = ?",
      whereArgs: [subjectId],
      );

      await txn.delete("subjects",
      where: "id = ?",
     whereArgs: [subjectId], 
      );
    },
    );
  }

  Future<Subjectmodel?> getSubjectById(String id) async{

  final db = await DatabaseHelper.instance.database;

  final result = await db.query("subjects",
  where: 'id = ?',
    whereArgs: [id],
    limit: 1,
  );

   if (result.isEmpty) {
    return null;
  }

    final e = result.first;

  return Subjectmodel(
    id: e['id'] as String,
    name: e['name'] as String,
    requiredAttendance:
        (e['required_attendance'] as num)
            .toDouble(),
    synced: (e['synced'] as int) == 1,
    createdAt:
        DateTime.parse(
          e['created_at'] as String,
        ),
    updatedAt:
        DateTime.parse(
          e['updated_at'] as String,
        ),
  );
}

Future<void> updateSubject(Subjectmodel subject) async{
  final db = await DatabaseHelper.instance.database;

  await db.update('subjects', {
      "name": subject.name,

      "required_attendance":
          subject.requiredAttendance,

      "synced": 0,

      "updated_at":
          subject.updatedAt
              .toIso8601String(),
    },

    where: "id = ?",

    whereArgs: [
      subject.id,
    ],
  );
}



Future<void> clearSubjects() async{
  final db = await DatabaseHelper.instance.database;
  await db.delete("subjects");
}


}
