import 'package:riverpod/riverpod.dart';
import 'package:stuhub/models/calendarDayModel.dart';
import 'package:stuhub/providers/calendarMonthProvider.dart';
import 'package:stuhub/providers/selected_subject_provider.dart';
import 'package:stuhub/repositories/analyticRepository.dart';

final calendarProvider = FutureProvider<List<Calendardaymodel>>((ref)async{
  final subjectId = ref.watch(selectedSubjectProvider);

  final month = ref.watch(calendarMonthProvider);

  if(subjectId == null){
    return [];
  }

  return Analyticrepository().getCalendarMonth(subjectId, month);

});