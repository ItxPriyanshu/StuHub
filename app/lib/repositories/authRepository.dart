import 'package:stuhub/models/userModel.dart';
import 'package:stuhub/models/userProfileModel.dart';
import 'package:stuhub/repositories/userProfileRepository.dart';
import 'package:stuhub/services/auth_service.dart';
import 'package:stuhub/storage/token_storage.dart';

class Authrepository {
  final AuthService service = AuthService();

  Future<Usermodel> login({
    required String email,
    required String password,
  }) async {
    final data = await service.login(email: email, password: password);

    await TokenStorage.saveToken(data["token"]);

    final user = Usermodel.fromJson(data["user"]);

    await Userprofilerepository().saveProfile(
      Userprofilemodel(
        id: user.id,
        username: user.name,
        email: user.email,
        profileImage: null,
        updatedAt: DateTime.now(),
      ),
    );

    return user;
  }

  Future<Usermodel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final data = await service.register(
      name: name,
      email: email,
      password: password,
    );

    await TokenStorage.saveToken(data["token"]);
    final user = Usermodel.fromJson(data["user"]);

     await Userprofilerepository().saveProfile(
      Userprofilemodel(
        id: user.id,
        username: user.name,
        email: user.email,
        profileImage: null,
        updatedAt: DateTime.now(),
      ),
    );

    return user;
  }
}
