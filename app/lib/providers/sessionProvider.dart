import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stuhub/models/sessionModel.dart';
import 'package:stuhub/repositories/sessionRepository.dart';

final sessionProvider = FutureProvider<Sessionmodel?>((ref)async{
  return Sessionrepository().getSession();
});