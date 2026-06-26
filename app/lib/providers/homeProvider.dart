import 'package:riverpod/riverpod.dart';
import 'package:stuhub/models/todayClassModel.dart';
import 'package:stuhub/repositories/homeRepository.dart';

final todayClassesProvider = FutureProvider<List<Todayclassmodel>>((ref)async{
  return Homerepository().getTodayClasses();
});