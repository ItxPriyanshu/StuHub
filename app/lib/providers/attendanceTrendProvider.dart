import 'package:riverpod/riverpod.dart';
import 'package:stuhub/models/attendanceTrendPoint.dart';
import 'package:stuhub/providers/selected_subject_provider.dart';
import 'package:stuhub/repositories/analyticRepository.dart';

final AttendancetrendProvider = FutureProvider<List<Attendancetrendpoint>>((ref)async{
  final selected = ref.watch(selectedSubjectProvider);

  if(selected == null){
    return[];
  }
  return Analyticrepository().getAttendanceTrend(selected);
});