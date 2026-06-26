import 'package:riverpod/riverpod.dart';
import 'package:stuhub/repositories/analyticRepository.dart';

final actionRequiredProvider = FutureProvider((ref)async{
  return Analyticrepository().hasActionRequired();
});