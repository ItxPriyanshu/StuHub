import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/legacy.dart';
import 'package:stuhub/repositories/timetableRepository.dart';

final editTimeTableProvider = StateProvider<Map<String, Map<int, int>>>(
  (ref) => {},
);

final allTimetableProvider = FutureProvider((ref)async{
  return Timetablerepository().getAllTimeTables();
});
