import 'package:riverpod/riverpod.dart';
import 'package:stuhub/databse/database_helper.dart';
import 'package:stuhub/repositories/attendanceRepository.dart';

final AttendancerepositoryProvider = Provider<Attendancerepository>((ref){
  return Attendancerepository(DatabaseHelper.instance);
});