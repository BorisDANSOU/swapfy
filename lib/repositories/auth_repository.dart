import '../models/user.dart';

abstract interface class AuthRepository {
  Stream<User?> authStateChanges();
  Future<User> signIn(String email, String password);
  Future<User> register(String email, String password);
  Future<void> signOut();
}
