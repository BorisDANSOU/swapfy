import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/user.dart';
import '../repositories/auth_repository.dart';

class SessionService extends ChangeNotifier {
  final AuthRepository _authRepository;
  late final StreamSubscription<User?> _subscription;
  User? _currentUser;

  SessionService(this._authRepository) {
    _subscription = _authRepository.authStateChanges().listen((user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  User? get currentUser => _currentUser;

  Stream<User?> get userChanges => _authRepository.authStateChanges();

  Future<User> signIn(String email, String password) async {
    final user = await _authRepository.signIn(email, password);
    _currentUser = user;
    notifyListeners();
    return user;
  }

  Future<User> register(String email, String password) async {
    final user = await _authRepository.register(email, password);
    _currentUser = user;
    notifyListeners();
    return user;
  }

  Future<void> signOut() => _authRepository.signOut();

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
