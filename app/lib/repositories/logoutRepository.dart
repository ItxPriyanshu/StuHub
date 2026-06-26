import 'package:stuhub/databse/database_helper.dart';
import 'package:stuhub/repositories/attendanceRepository.dart';
import 'package:stuhub/repositories/sessionRepository.dart';
import 'package:stuhub/repositories/setupRepository.dart';
import 'package:stuhub/repositories/subjectRepository.dart';
import 'package:stuhub/repositories/timetableRepository.dart';
import 'package:stuhub/repositories/userProfileRepository.dart';
import 'package:stuhub/storage/token_storage.dart';

class Logoutrepository {
  Future<void> clearLocalData()async{
    final attendanceRepo = Attendancerepository(DatabaseHelper.instance);

    final timetableRepo = Timetablerepository();
    final subjectRepo = Subjectrepository();
    final sessionRepo = Sessionrepository();
    final profileRepo = Userprofilerepository();
    final setupRepo = Setuprepository();




    await attendanceRepo.clearAttendance();
    await timetableRepo.clearTimetable();
    await sessionRepo.clearSession();
    await profileRepo.clearProfile();
    await subjectRepo.clearSubjects();


    await setupRepo.resetSetup();
    await TokenStorage.clearToken();
  }
}