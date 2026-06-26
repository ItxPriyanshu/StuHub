import 'package:riverpod/riverpod.dart';
import 'package:stuhub/repositories/checkbackUpRepository.dart';

final lastBackupProvider = FutureProvider<DateTime?>((ref)async{
  return Checkbackuprepository().getLastBackup();
});