import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stuhub/models/analyticsModel.dart';
import 'package:stuhub/models/subjectHealthModel.dart';
import 'package:stuhub/providers/selected_subject_provider.dart';
import 'package:stuhub/repositories/analyticRepository.dart';
import 'package:stuhub/repositories/subjectRepository.dart';

final subjectHealthProvider =
    FutureProvider.autoDispose<List<Subjecthealthmodel>>((ref) async {
      return Analyticrepository().getSubjectHealth();
    });

final analyticsProvider = FutureProvider<Analyticsmodel?>((ref) async {
  final subjects = await Subjectrepository().getSubjects();

  if (subjects.isEmpty) {
    return null;
  }

  final selectedId = ref.watch(selectedSubjectProvider);

  final subjectId = selectedId ?? subjects.first.id;

  return Analyticrepository().getAnalytics(subjectId);
});
