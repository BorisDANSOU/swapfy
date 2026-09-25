import 'dart:async';

import '../../data/users.dart';
import '../../models/user.dart';
import '../auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  User? _currentUser;
  final _authChanges = StreamController<User?>.broadcast();

  @override
  Stream<User?> authStateChanges() async* {
    yield _currentUser;
    yield* _authChanges.stream;
  }

  @override
  Future<User> signIn(String email, String password) async {
    if (email != 'boris@example.com' || password != 'password') {
      throw const FormatException('Identifiants invalides');
    }
    _currentUser = MockUsers.currentUser;
    _authChanges.add(_currentUser);
    return _currentUser!;
  }

  @override
  Future<User> register(String email, String password) async {
    _currentUser = MockUsers.currentUser;
    _authChanges.add(_currentUser);
    return _currentUser!;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    _authChanges.add(null);
  }

  void dispose() {
    _authChanges.close();
  }
}
