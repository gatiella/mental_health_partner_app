import '../../../core/storage/secure_storage.dart';
import '../../../core/storage/local_storage.dart';
import '../../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheTokens(String accessToken, String refreshToken);
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> clearAuth();
  Future<bool> isLoggedIn();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorage secureStorage;
  final LocalStorage localStorage;
  // ignore: constant_identifier_names
  static const String USER_KEY = 'cached_user';

  AuthLocalDataSourceImpl({
    required this.secureStorage,
    required this.localStorage,
  });

  @override
  Future<void> cacheTokens(String accessToken, String refreshToken) async {
    await secureStorage.setAccessToken(accessToken);
    await secureStorage.setRefreshToken(refreshToken);
  }

  @override
  Future<String?> getAccessToken() async {
    return await secureStorage.getAccessToken();
  }

  @override
  Future<String?> getRefreshToken() async {
    return await secureStorage.getRefreshToken();
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    await localStorage.setObject(USER_KEY, user.toJson());
  }

  @override
  Future<UserModel?> getUser() async {
    final userData = localStorage.getObject(USER_KEY);
    if (userData != null) {
      return UserModel.fromJson(userData);
    }
    return null;
  }

  @override
  Future<void> clearAuth() async {
    await secureStorage.clearAll();
    await localStorage.remove(USER_KEY);
  }

  @override
  Future<bool> isLoggedIn() async {
    return await secureStorage.isLoggedIn();
  }
}
