import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stuhub/repositories/subjectRepository.dart';

final manageSubjectProvider = FutureProvider((ref)async{
  return Subjectrepository().getSubjects();
});