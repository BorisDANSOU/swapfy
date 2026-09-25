import '../models/user.dart';

abstract interface class UsersRepository {
  Stream<User?> watchCurrentUser();
  Stream<List<User>> watchMatches();
  Future<void> saveProfile(User user);
}
