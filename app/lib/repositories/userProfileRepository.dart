import 'package:sqflite/sqlite_api.dart';
import 'package:stuhub/databse/database_helper.dart';
import 'package:stuhub/models/userProfileModel.dart';
import 'package:stuhub/services/auth_service.dart';

class Userprofilerepository {
  Future<void> saveProfile(Userprofilemodel profile) async {
    final db = await DatabaseHelper.instance.database;

    await db.insert(
      "user_profile",
      profile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Userprofilemodel?> getProfile() async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query("user_profile", limit: 1);
    if (result.isEmpty) {
      return null;
    }

    return Userprofilemodel.fromMap(result.first);
  }

  Future<void> updatePhoto(String imagePath) async {
    final db = await DatabaseHelper.instance.database;

    await db.update("user_profile", {
      "profile_image": imagePath,
      "updated_at": DateTime.now().toIso8601String(),
    });
  }

  Future<void> updateProfile({
    required String username,
    required String email,
  }) async {
    final db = await DatabaseHelper.instance.database;

    await db.update("user_profile", {
      "username": username,
      "email": email,
      "updated_at": DateTime.now().toIso8601String(),
    },
    where: "id = ?",
    whereArgs: [
      (await getProfile())!.id,
    ],
    );
    await AuthService().updateProfile(name: username, email: email);
  }



  Future<void> updateProfilePhoto(String imagePath)async{
    final db = await DatabaseHelper.instance.database;

    final profile = await getProfile();

    if(profile == null){
      return;
    }

    await db.update("user_profile", {
      "profile_image": imagePath,
      "updated_at":
          DateTime.now()
              .toIso8601String(),
    },
    where: "id = ?",
    whereArgs: [profile.id],
    );
  }



  Future<void> clearProfile() async{
    final db = await DatabaseHelper.instance.database;
    await db.delete("user_profile");
  }
}
