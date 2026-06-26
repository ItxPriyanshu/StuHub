import 'package:stuhub/databse/database_helper.dart';

class Checkbackuprepository {
  Future<void> updateLastBackup(DateTime date) async{
    final db = await DatabaseHelper.instance.database;
    await db.update("app_setup", {
       "last_backup":
            date.toIso8601String(),
    },
    where: "id = 1",
    );
  }


   Future<DateTime?> getLastBackup()
  async {

    final db =
        await DatabaseHelper
            .instance
            .database;

    final result =
        await db.query(
      "app_setup",
      where: "id = 1",
    );

    if (result.isEmpty) {
      return null;
    }

    final value =
        result.first["last_backup"];

    if (value == null) {
      return null;
    }

    return DateTime.parse(
      value.toString(),
    );
  }
}