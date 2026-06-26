import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stuhub/repositories/userProfileRepository.dart';


final userProfilereRepositoryProvider = Provider<Userprofilerepository>((ref){
  return Userprofilerepository();
});


final userProfileProvider = FutureProvider((ref)async{
  return Userprofilerepository().getProfile();
});