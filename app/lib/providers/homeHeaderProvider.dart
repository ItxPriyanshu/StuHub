import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stuhub/providers/homeProvider.dart';

final totalClassesTodayProvider = FutureProvider<int>((ref)async{

  final classes = await ref.watch(todayClassesProvider.future);

  return classes.fold<int>(0, (sum,item)=> sum + item.classCount);
});