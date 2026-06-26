import 'package:riverpod/riverpod.dart';
import 'package:stuhub/models/subjectModel.dart';
import 'package:stuhub/repositories/subjectRepository.dart';

final subjectProvider = FutureProvider<List<Subjectmodel>>((ref)async{
  return Subjectrepository().getSubjects();
});